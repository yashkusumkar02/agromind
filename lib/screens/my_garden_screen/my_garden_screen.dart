import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/my_garden_controller/my_garden_controller.dart';
import '../custom_drawer/custom_drawer.dart';

class MyGardenScreen extends StatelessWidget {
  MyGardenScreen({Key? key}) : super(key: key);

  final MyGardenController controller = Get.put(MyGardenController());
  final RxBool isDrawerOpen = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ✅ Header Section
                Container(
                  height: 180,
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
                            // ✅ Custom Drawer Open with Logo Tap
                            GestureDetector(
                              onTap: () => isDrawerOpen.value = true,
                              child: Image.asset('assets/images/app_logo.png', height: 40),
                            ),
                            Text("My Garden",
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                            // ✅ Refresh Button
                            IconButton(
                              icon: Icon(Icons.refresh, color: Colors.blue, size: 30),
                              onPressed: () => controller.fetchPlants(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // ✅ Search Bar
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                          ),
                          child: TextField(
                            onChanged: controller.searchPlants,
                            decoration: InputDecoration(
                              hintText: "Search Plants...",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ Plants List with Pull-to-Refresh
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.fetchPlants();
                    },
                    child: Obx(() {
                      if (controller.filteredPlants.isEmpty) {
                        return Center(child: Text("No plants found!"));
                      }
                      return ListView.builder(
                        itemCount: controller.filteredPlants.length,
                        itemBuilder: (context, index) {
                          var plant = controller.filteredPlants[index];

                          return Dismissible(
                            key: Key(plant["id"]),
                            background: _editBackground(),
                            secondaryBackground: _deleteBackground(),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                _showEditDialog(context, plant);
                                return false;
                              } else if (direction == DismissDirection.endToStart) {
                                return await _confirmDeleteDialog(context, plant);
                              }
                              return false;
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: _displayPlantImage(plant["image_base64"] ?? ""),
                                title: Text(
                                  plant["name"] ?? "Unknown Plant",
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Last Watered: ${plant['lastWatered'] ?? 'Unknown'}"),
                                trailing: _priorityIndicator(plant["priority"] ?? "Healthy"),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Custom Drawer Overlay (to close it when tapping outside)
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

      // ✅ Floating Action Button (FAB) for Adding a Plant
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _showAddPlantDialog(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// ✅ Display Image from Base64
  Widget _displayPlantImage(String base64Image) {
    if (base64Image.isEmpty) {
      return Icon(Icons.image, color: Colors.grey, size: 50);
    }
    Uint8List bytes = base64Decode(base64Image);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(bytes, width: 50, height: 50, fit: BoxFit.cover),
    );
  }

  /// ✅ Add Plant Dialog
  void _showAddPlantDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    RxString selectedPriority = "Healthy".obs;
    RxString selectedImagePath = "".obs;
    List<String> priorityOptions = ["Healthy", "At Risk", "Needs Care ASAP"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Plant", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Image Picker Button
              Obx(() => GestureDetector(
                onTap: () async {
                  String? imagePath = await controller.pickImageFromGallery();
                  if (imagePath != null) {
                    selectedImagePath.value = imagePath;
                  }
                },
                child: selectedImagePath.value.isEmpty
                    ? Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add_a_photo, color: Colors.grey[700], size: 40),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(selectedImagePath.value), height: 100, fit: BoxFit.cover),
                ),
              )),
              SizedBox(height: 10),

              // ✅ Plant Name Input
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Plant Name"),
              ),
              SizedBox(height: 10),

              // ✅ Priority Dropdown
              Obx(() => DropdownButtonFormField<String>(
                value: selectedPriority.value,
                items: priorityOptions.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedPriority.value = value!;
                },
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                controller.addNewPlant(
                  nameController.text,
                  selectedPriority.value,
                  imagePath: selectedImagePath.value,
                );
                Get.back();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Edit Plant Dialog
  void _showEditDialog(BuildContext context, Map<String, dynamic> plant) {
    TextEditingController nameController = TextEditingController(text: plant["name"]);
    RxString updatedPriority = plant["priority"].obs;
    List<String> priorityOptions = ["Healthy", "At Risk", "Needs Care ASAP"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Plant", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Plant Name"),
              ),
              SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                value: updatedPriority.value,
                items: priorityOptions.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  updatedPriority.value = value!;
                },
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updatePlant(
                  plant["id"],
                  nameController.text,
                  updatedPriority.value,
                );
                Get.back();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Delete Background
  Widget _deleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  /// ✅ Priority Indicator
  Widget _priorityIndicator(String priority) {
    Color color;
    IconData icon;
    switch (priority) {
      case "Healthy":
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case "At Risk":
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case "Needs Care ASAP":
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  /// ✅ Confirm Delete Dialog
  Future<bool> _confirmDeleteDialog(BuildContext context, Map<String, dynamic> plant) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Plant"),
        content: Text("Are you sure you want to delete '${plant["name"]}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              controller.deletePlant(plant["id"]);
              Navigator.of(context).pop(true);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  /// ✅ Edit Background
  Widget _editBackground() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.edit, color: Colors.white, size: 30),
    );
  }

}
