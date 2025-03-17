import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/RecommendationController/RecommendationController.dart';

class RecommendationSection extends StatelessWidget {
  final RecommendationController controller = Get.put(RecommendationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header with Title & Refresh Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Recommendations",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.blue), // ✅ Small Refresh Icon
                  onPressed: () {
                    controller.fetchTodayScans(); // ✅ Fetch Latest Data
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ✅ If no scans today, show default UI
            if (controller.scannedPlants.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/broken_robot.png',
                      height: 150,
                      width: 250,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "No Recommendations Yet. Scan A Plant To Receive Tips!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // ✅ Show List of Today's Scanned Plants
              Container(
                height: 200, // ✅ Fixed height for scrolling
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.scannedPlants.length,
                  itemBuilder: (context, index) {
                    final scan = controller.scannedPlants[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          "🌿 ${scan['plantName']}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[800],
                          ),
                        ),
                        subtitle: Text(
                          "🦠 ${scan['diseaseName']}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }
}
