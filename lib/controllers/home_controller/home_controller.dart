import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/task_model.dart';
import '../../widgets/weather_service.dart';
import '../TaskController/TaskController.dart';

class HomeController extends GetxController {
  final TaskController taskController = Get.put(TaskController());
  var city = ''.obs;
  var temperature = 0.0.obs;
  var weatherCondition = ''.obs;
  var isDrawerOpen = false.obs;
  var userName = "".obs; // ✅ Fetch from Firebase
  var location = "India".obs;
  var tasks = <Task>[].obs;

  final WeatherService weatherService = WeatherService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchWeatherData();
    fetchUserData(); // ✅ Fetch user data on init
  }

  /// ✅ Fetch the user's first name from Firestore
  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
        if (userDoc.exists) {
          userName.value = userDoc["firstName"] ?? "User"; // ✅ Fallback if no name found
        }
      } catch (e) {
        print("⚠️ Error fetching user data: $e");
      }
    }
  }

  /// ✅ Fetch Weather Data
  void fetchWeatherData() async {
    try {
      var data = await weatherService.fetchWeather();
      if (data != null) {
        city.value = data["city"] ?? "Unknown Location";
        temperature.value = (data["main"]["temp"] ?? 0.0).toDouble();
        weatherCondition.value = data["weather"][0]["main"] ?? "Clear";
      }
    } catch (e) {
      city.value = "Error fetching data";
      weatherCondition.value = "N/A";
      temperature.value = 0.0;
      print("⚠️ Weather API Error: $e");
    }
  }


  /// ✅ Toggle Drawer
  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }
}
