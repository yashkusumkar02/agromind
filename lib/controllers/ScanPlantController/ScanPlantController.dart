import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanPlantController extends GetxController {
  RxInt plantHealthCount = 0.obs;
  RxInt recommendationCount = 0.obs;
  RxInt waterReminderCount = 0.obs; // ✅ Updated to count from My Garden Plants
  RxInt aiReminderCount = 0.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchRealTimeUpdates();
  }

  // ✅ Fetch Real-Time Data from Firestore
  void fetchRealTimeUpdates() {
    User? user = auth.currentUser;
    if (user == null) return;

    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);

    // ✅ Listen for "Plant Health Checks" (Today’s scans)
    firestore
        .collection("users")
        .doc(user.uid)
        .collection("plant_diagnosis")
        .where("timestamp", isGreaterThanOrEqualTo: todayStart)
        .snapshots()
        .listen((snapshot) {
      plantHealthCount.value = snapshot.docs.length;
      recommendationCount.value = snapshot.docs.length; // ✅ Each scan is a recommendation
    });

    // ✅ Count total number of plants in "My Garden" for Water Reminder
    firestore
        .collection("users")
        .doc(user.uid)
        .collection("plants") // ✅ This collection stores the user's plants
        .snapshots()
        .listen((snapshot) {
      waterReminderCount.value = snapshot.docs.length; // ✅ Set count to total plants
    });

    // ✅ Listen for "AI Reminders"
    firestore
        .collection("users")
        .doc(user.uid)
        .collection("ai_recommendations")
        .where("timestamp", isGreaterThanOrEqualTo: todayStart)
        .snapshots()
        .listen((snapshot) {
      aiReminderCount.value = snapshot.docs.length;
    });
  }
}
