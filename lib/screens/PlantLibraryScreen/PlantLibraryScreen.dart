import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/PlantLibraryController/PlantLibraryController.dart';
import '../custom_drawer/custom_drawer.dart'; // ✅ Import Custom Drawer

class PlantLibraryScreen extends StatelessWidget {
  final PlantLibraryController controller = Get.put(PlantLibraryController());
  final RxBool isDrawerOpen = false.obs; // ✅ Drawer state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ✅ Custom Header Section (Now includes Category Filters)
                Container(
                  height: 150, // Increased height to fit categories
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ Open Drawer Button (Toggles Drawer)
                            GestureDetector(
                              onTap: () => isDrawerOpen.value = true,
                              child: Image.asset('assets/images/app_logo.png', height: 40),
                            ),
                            Text("Plant Library",
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                            // ✅ Refresh Button
                            IconButton(
                              icon: Icon(Icons.refresh, color: Colors.blue, size: 30),
                              onPressed: controller.fetchPlants,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ✅ Category Filter inside Header
                        Container(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              categoryButton("All"),
                              categoryButton("Herbs"),
                              categoryButton("Flowers"),
                              categoryButton("Trees"),
                              categoryButton("Succulents"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ Plant Grid (Fetches & Displays Plant Data)
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (controller.plants.isEmpty) {
                      return Center(child: Text("No plants found!"));
                    }

                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                        itemCount: controller.plants.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          var plant = controller.plants[index];

                          return GestureDetector(
                            onTap: () => controller.goToPlantDetails(plant),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.network(
                                        plant["default_image"]?["regular_url"] ?? "",
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Icon(Icons.image_not_supported, size: 50),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plant["common_name"] ?? "Unknown Plant",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          plant["scientific_name"] != null
                                              ? plant["scientific_name"].join(", ")
                                              : "No Scientific Name",
                                          style: TextStyle(
                                              fontSize: 12, fontStyle: FontStyle.italic, color: Colors.green),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // ✅ Custom Drawer Overlay (Closes Drawer When Tapping Outside)
          Obx(() => isDrawerOpen.value
              ? GestureDetector(
            onTap: () => isDrawerOpen.value = false,
            child: Container(color: Colors.black.withOpacity(0.5)),
          )
              : SizedBox.shrink()),

          // ✅ Slide-in Custom Drawer
          Obx(() {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: isDrawerOpen.value ? 0 : -270,
              child: CustomDrawer(onClose: () => isDrawerOpen.value = false),
            );
          }),
        ],
      ),
    );
  }

  // ✅ Filter Button Widget (Category Buttons inside Header)
  Widget categoryButton(String category) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          print("Filter by: $category");
          // Add filtering logic here
        },
        child: Text(category, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
