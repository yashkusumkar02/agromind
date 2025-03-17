import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PlantLibraryController extends GetxController {
  RxList<Map<String, dynamic>> plants = <Map<String, dynamic>>[].obs; // ✅ Correct Typing
  RxBool isLoading = false.obs;

  final String apiKey = "sk-S1vd67d7aa4e7f9139192"; // 🔥 Replace with your Perenual API key
  final String apiUrl = "https://perenual.com/api/species-list";

  Future<void> fetchPlants() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse("$apiUrl?key=$apiKey"));

      print("🔥 Raw API Response: ${response.body}"); // ✅ Debugging

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Decoded JSON: $data"); // ✅ Debugging

        if (data is Map<String, dynamic> && data.containsKey("data")) {
          List<Map<String, dynamic>> plantList =
          List<Map<String, dynamic>>.from(data["data"]); // ✅ Ensure Proper Typing

          plants.assignAll(plantList); // ✅ Update RxList Correctly
          print("🌿 Plants List: ${plants.length} items");
        } else {
          print("🚨 Unexpected JSON format: $data");
        }
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Error Fetching Plants: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToPlantDetails(Map<String, dynamic> plant) {
    List<dynamic> hardinessZones = [];
    if (plant.containsKey("hardiness") && plant["hardiness"] is List) {
      hardinessZones = plant["hardiness"].map((zone) {
        if (zone.containsKey("min") && zone.containsKey("max")) {
          return "${zone["min"]} - ${zone["max"]}";
        }
        return zone.toString(); // Handle any extra values
      }).toList();
    }

    Get.toNamed(
      "/plantDetails",
      arguments: {
        "id": plant["id"],
        "common_name": plant["common_name"] ?? "Unknown Plant",
        "scientific_name": plant["scientific_name"]?.join(", ") ?? "N/A",
        "watering": plant["watering"] ?? "Unknown",
        "cycle": plant["cycle"] ?? "Unknown",
        "sunlight": plant["sunlight"] ?? [],
        "image_url": plant["default_image"]?["original_url"] ?? "",
        "hardiness": hardinessZones, // ✅ Updated Hardiness Zone
        "hardiness_map": plant["hardiness_map"] ?? "",
        "soil": plant["soil"] ?? "Not Available",
        "poisonous_to_humans": plant["poisonous_to_humans"] ?? false,
        "medicinal": plant["medicinal"] ?? "",
      },
    );
  }
}
