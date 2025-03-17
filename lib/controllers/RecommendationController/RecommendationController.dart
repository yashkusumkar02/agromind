import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationController extends GetxController {
  RxList<Map<String, String>> scannedPlants = <Map<String, String>>[].obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTodayScans();
  }

  // ✅ Fetch all scanned plants for today ONLY
  Future<void> fetchTodayScans() async {
    try {
      User? user = auth.currentUser;
      if (user == null) return;

      // ✅ Get today's start time (00:00 AM)
      DateTime now = DateTime.now();
      DateTime todayStart = DateTime(now.year, now.month, now.day);

      // ✅ Query Firestore for scans done **today**
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .doc(user.uid)
          .collection("plant_diagnosis")
          .where("timestamp", isGreaterThanOrEqualTo: todayStart)
          .orderBy("timestamp", descending: true)
          .get();

      // ✅ Clear previous data and update with today's scans
      scannedPlants.clear();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          scannedPlants.add({
            "plantName": data["plantName"] ?? "Unknown Plant",
            "diseaseName": data["diseaseName"] ?? "Unknown Disease",
          });
        }
      }
    } catch (e) {
      print("❌ Error fetching today's scans: $e");
    }
  }
}
