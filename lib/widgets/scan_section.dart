import 'package:agromind/screens/plant_diagnosis_screen/plant_diagnosis_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ScanPlantController/ScanPlantController.dart';

class ScanPlantSection extends StatelessWidget {
  final ScanPlantController controller = Get.put(ScanPlantController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PlantDiagnosisScreen()); // ✅ Navigate to Plant Diagnosis Page
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/scan_frame.png',
                height: 220,
              ),
              ClipOval(
                child: Image.asset(
                  'assets/images/sample_plant.png',
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "SCAN PLANT HEALTH",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Display Real-Time Data from Controller
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusCircle("${controller.plantHealthCount.value}", "Plant Health Check",
                  Colors.orangeAccent.withOpacity(0.6)),
              _buildStatusCircle("${controller.recommendationCount.value}", "New Recommendation",
                  Colors.redAccent.withOpacity(0.6)),
              _buildStatusCircle("${controller.waterReminderCount.value}", "Water Reminder",
                  Colors.greenAccent.withOpacity(0.6)),
              _buildStatusCircle("${controller.aiReminderCount.value}", "AI Reminder",
                  Colors.pinkAccent.withOpacity(0.6)),
            ],
          )),
        ],
      ),
    );
  }

  /// ✅ Status Circle with Dynamic Data
  Widget _buildStatusCircle(String number, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
