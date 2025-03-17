import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller/home_controller.dart';
import '../../widgets/scan_section.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/task_section.dart';
import '../../widgets/health_summary.dart';
import '../../widgets/recommendation_section.dart';
import '../custom_drawer/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/homescreen_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Main Content with Drawer Button
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Top Section (App Logo + Welcome Message)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleDrawer();
                          },
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            height: 40,
                          ),
                        ),
                      ),
                      Center(
                        child: Obx(() => Text(
                          "Welcome, ${controller.userName.value}!", // ✅ Dynamically Display User's First Name
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ✅ Weather and Location Card
                  WeatherCard(),
                  const SizedBox(height: 20),

                  // ✅ Scan Plant Section
                  ScanPlantSection(),
                  const SizedBox(height: 20),

                  // ✅ Task Section
                  TaskSection(),
                  const SizedBox(height: 20),

                  // ✅ Health Summary
                  HealthSummary(),
                  const SizedBox(height: 30),

                  // ✅ Today's Recommendation
                  RecommendationSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // ✅ Animated Drawer Overlay (Use Obx properly)
          Obx(() => controller.isDrawerOpen.value
              ? GestureDetector(
            onTap: () => controller.toggleDrawer(),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          )
              : SizedBox.shrink()),

          // ✅ Slide-in Custom Drawer (Fixed `Obx` usage)
          Obx(() {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              left: controller.isDrawerOpen.value ? 0 : -270,
              child: CustomDrawer(onClose: controller.toggleDrawer),
            );
          }),
        ],
      ),
    );
  }
}
