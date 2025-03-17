import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/task_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TaskController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermissions() async {
    if (GetPlatform.isIOS || GetPlatform.isMacOS) {
      final IOSFlutterLocalNotificationsPlugin? iosPlatform =
      notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      await iosPlatform?.requestPermissions(alert: true, badge: true, sound: true);

      print("✅ iOS/macOS Notification permissions requested.");
    } else {
      print("✅ Android does not require explicit notification permission.");
    }
  }


  // ✅ Call this in `onInit()`
  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    _initializeNotifications();
    requestNotificationPermissions();
    requestExactAlarmPermission();// ✅ Fix for Android 13+
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(settings);

    // ✅ Request Permission only for iOS/macOS
    if (GetPlatform.isIOS || GetPlatform.isMacOS) {
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    print("✅ Notifications Initialized");
  }

  // ✅ Fetch Tasks from Firestore in Real-time
  void fetchTasks() {
    User? user = auth.currentUser;
    if (user == null) return;

    firestore
        .collection("users")
        .doc(user.uid)
        .collection("tasks")
        .orderBy("startTime", descending: false)
        .snapshots()
        .listen((snapshot) {
      tasks.clear();
      for (var doc in snapshot.docs) {
        tasks.add(Task.fromJson(doc.data(), doc.id));
      }
    });
  }

  Future<void> addTask(Task task) async {
    User? user = auth.currentUser;
    if (user == null) return;

    try {
      // ✅ Store Task in Firestore & Get Firestore-generated ID
      DocumentReference taskRef = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("tasks")
          .add(task.toJson());

      // ✅ Update Task ID only after Firestore confirms it
      task.id = taskRef.id;

      // ✅ Fetch Latest Data (Prevents Duplicates)
      fetchTasks();

      // ✅ Schedule Reminder
      scheduleNotification(task);

      print("✅ Task Added Successfully");
    } catch (e) {
      print("❌ Error adding task: $e");
    }
  }

  void deleteTask(Task task) async {
    User? user = auth.currentUser;
    if (user == null) return;

    try {
      // ✅ Delete from Firestore
      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("tasks")
          .doc(task.id)
          .delete();

      // ✅ Remove from local list
      tasks.removeWhere((t) => t.id == task.id);

      print("✅ Task Deleted Successfully");
    } catch (e) {
      print("❌ Error deleting task: $e");
    }
  }

  void updateTask(Task oldTask, String newName, String newStart, String newEnd, String newPriority) async {
    User? user = auth.currentUser;
    if (user == null) return;

    try {
      // ✅ Find task in Firestore
      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("tasks")
          .doc(oldTask.id)
          .update({
        "name": newName,
        "startTime": newStart,
        "endTime": newEnd,
        "priority": newPriority,
        "reminderTime": oldTask.reminderTime, // Preserve reminder time
      });

      // ✅ Update local list
      int index = tasks.indexWhere((t) => t.id == oldTask.id);
      if (index != -1) {
        tasks[index] = Task(
          id: oldTask.id,
          name: newName,
          startTime: newStart,
          endTime: newEnd,
          priority: newPriority,
          reminderTime: oldTask.reminderTime,
        );
      }

      print("✅ Task Updated Successfully");
    } catch (e) {
      print("❌ Error updating task: $e");
    }
  }

  Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> scheduleNotification(Task task) async {
    try {
      if (await Permission.scheduleExactAlarm.isDenied) {
        print("❌ Exact alarm permission is not granted. Cannot schedule notification.");
        return;
      }

      tz.initializeTimeZones();
      DateTime reminderTime = DateTime.parse(task.reminderTime);

      if (reminderTime.isBefore(DateTime.now())) {
        print("❌ Reminder time is in the past. Skipping notification.");
        return;
      }

      int notificationId = reminderTime.millisecondsSinceEpoch % 100000;
      final tz.TZDateTime tzReminderTime = tz.TZDateTime.from(reminderTime, tz.local);

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        "task_reminder_channel",
        "Task Reminders",
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      await notificationsPlugin.zonedSchedule(
        notificationId,
        "Task Reminder",
        "Your task '${task.name}' is starting soon!",
        tzReminderTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print("✅ Notification Scheduled for ${task.reminderTime}");
    } catch (e) {
      print("❌ Error scheduling notification: $e");
    }
  }

}
