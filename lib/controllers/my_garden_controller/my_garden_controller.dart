import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyGardenController extends GetxController {
  var plants = <Map<String, dynamic>>[].obs;
  var filteredPlants = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var selectedImagePath = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchPlants();
    searchQuery.listen((value) {
      searchPlants(value);
    });
  }

  /// ✅ Get Current User ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// ✅ Fetch Plants for the Logged-in User
  void fetchPlants() async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("plants")
        .snapshots()
        .listen((snapshot) {
      plants.assignAll(snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList());
      filteredPlants.assignAll(plants);
    });
  }

  /// ✅ Convert Image to Base64
  Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  /// ✅ Add New Plant (Auto-Refresh Enabled)
  Future<void> addNewPlant(String name, String priority, {String? imagePath}) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    String base64Image = "";
    if (imagePath != null && imagePath.isNotEmpty) {
      File imageFile = File(imagePath);
      base64Image = await convertImageToBase64(imageFile);
    }

    await FirebaseFirestore.instance.collection("users").doc(userId).collection("plants").add({
      "name": name,
      "priority": priority,
      "image_base64": base64Image,
      "lastWatered": "Just Now",
    });

    fetchPlants(); // ✅ Auto-refresh after adding a new plant
  }

  /// ✅ Pick Image from Gallery
  Future<String?> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  /// ✅ Delete Plant (Auto-Refresh Enabled)
  Future<void> deletePlant(String plantId) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await FirebaseFirestore.instance.collection("users").doc(userId).collection("plants").doc(plantId).delete();
    fetchPlants(); // ✅ Auto-refresh after deleting a plant
  }

  /// ✅ Update Plant (User-Specific)
  Future<void> updatePlant(String plantId, String name, String priority) async {
    String? userId = getCurrentUserId();
    if (userId == null) return;

    await FirebaseFirestore.instance.collection("users").doc(userId).collection("plants").doc(plantId).update({
      "name": name,
      "priority": priority,
    });
  }

  /// ✅ Search Functionality
  void searchPlants(String query) {
    if (query.isEmpty) {
      filteredPlants.assignAll(plants);
    } else {
      filteredPlants.assignAll(plants.where((plant) {
        return plant["name"].toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }
}
