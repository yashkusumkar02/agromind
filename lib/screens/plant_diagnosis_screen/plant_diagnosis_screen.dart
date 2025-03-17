import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/plant_diagnosis_controller/plant_diagnosis_controller.dart';
import '../custom_drawer/custom_drawer.dart'; // ✅ Custom Drawer Imported

class PlantDiagnosisScreen extends StatelessWidget {
  final PlantDiagnosisController controller = Get.put(PlantDiagnosisController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // ✅ Added GlobalKey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // ✅ Assign Scaffold Key
      drawer: CustomDrawer(onClose: () { // ✅ Fixed Missing onClose
        _scaffoldKey.currentState?.closeDrawer();
      }),
      body: Stack(
        children: [
          // ✅ Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/plantdiagnosis_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Main Content
          SafeArea(
            child: Column(
              children: [
                // ✅ Header Section (Now Uses Builder to Open Drawer)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer(); // ✅ Opens Drawer Properly
                            },
                            child: Image.asset('assets/images/app_logo.png', height: 40),
                          );
                        },
                      ),
                      Text(
                        "Plant Diagnosis",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.blueAccent),
                        onPressed: () {
                          Get.snackbar("Info", "Upload or capture an image for analysis.");
                        },
                      ),
                    ],
                  ),
                ),

                // ✅ Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ✅ Instruction Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                          child: Text(
                            "Upload a clear image of the affected plant area or take a photo for analysis.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                        ),

                        // ✅ File Upload Box
                        GestureDetector(
                          onTap: () => controller.pickImageFromGallery(),
                          child: Obx(() => Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: controller.selectedImagePath.isEmpty
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 40, color: Colors.grey),
                                const SizedBox(height: 5),
                                Text("Select file", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                              ],
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(File(controller.selectedImagePath.value), fit: BoxFit.cover),
                            ),
                          )),
                        ),

                        const SizedBox(height: 30),

                        // ✅ OR Separator
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.black54)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "or",
                                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.black54)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ✅ Open Camera Button
                        GestureDetector(
                          onTap: () => controller.captureImageFromCamera(),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.green, width: 2),
                              boxShadow: [
                                BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 5, spreadRadius: 2),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  "Open Camera & Take Photo",
                                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ✅ **AI Diagnosis Results**
                        // ✅ AI Diagnosis Results - Adjusts size based on content
                        Obx(() => controller.plantName.value.isNotEmpty
                            ? Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "🌿 Plant: ${controller.plantName.value}",
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                  const SizedBox(height: 5), // ✅ Added spacing for readability
                                  Text(
                                    "🦠 Disease: ${controller.diseaseName.value}",
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                  const SizedBox(height: 5), // ✅ Added spacing

                                  // ✅ Auto-Resizing Recommendation Box
                                  Container(
                                    width: double.infinity, // ✅ Takes full width
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green, width: 1),
                                    ),
                                    child: Text(
                                      "💡 Recommendation: ${controller.recommendation.value}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                            : Container()), // ✅ Show nothing if plantName is empty
                      ],
                    ),
                  ),
                ),

                // ✅ Continue Button (Fixed at Bottom)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.selectedImagePath.isNotEmpty) {
                        controller.analyzeImage(); // ✅ Run TFLite Model First
                      } else {
                        Get.snackbar("Error", "Please upload or capture an image.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                    ),
                    child: Text(
                      "Analyze",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
