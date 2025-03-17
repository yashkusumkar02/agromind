import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthSummaryController extends GetxController {
  RxInt totalPlantsTracked = 0.obs;
  RxInt healthyPlants = 0.obs;
  RxInt riskyPlants = 0.obs;
  RxInt diseasedPlants = 0.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchHealthSummary();
  }

  // ✅ Fetch real-time plant health summary
  void fetchHealthSummary() {
    User? user = auth.currentUser;
    if (user == null) return;

    // Listen to real-time updates in plant diagnosis
    firestore
        .collection("users")
        .doc(user.uid)
        .collection("plant_diagnosis")
        .snapshots()
        .listen((snapshot) {
      totalPlantsTracked.value = snapshot.docs.length;

      // Reset counters before updating
      int healthy = 0;
      int risky = 0;
      int diseased = 0;

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String plantCondition = data["plantCondition"] ?? "Healthy"; // Default to healthy

        if (plantCondition == "Healthy") {
          healthy++;
        } else if (plantCondition == "Risky") {
          risky++;
        } else if (plantCondition == "Diseased") {
          diseased++;
        }
      }

      // Update observable values
      healthyPlants.value = healthy;
      riskyPlants.value = risky;
      diseasedPlants.value = diseased;
    });
  }
}
