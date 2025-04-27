import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';

class PlantDiagnosisController extends GetxController {
  RxString selectedImagePath = ''.obs;
  RxString plantName = ''.obs;
  RxString diseaseName = ''.obs;
  RxString recommendation = ''.obs;
  RxBool isAnalyzed = false.obs;
  RxDouble predictionConfidence = 0.0.obs; // ✅ Track confidence

  late Interpreter interpreter;
  List<String> labels = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String apiKey = "AIzaSyAYTg-RgwvuKcGc0b9GxI20RMcNgaUK85E"; // Replace with actual API key

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset("assets/models/plant_disease_model.tflite");
      labels = await loadLabels();
    } catch (e) {
      print("❌ Error loading TFLite model: $e");
    }
  }

  Future<List<String>> loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString("assets/models/plant_labels.txt");
      return labelsData.split('\n').where((element) => element.isNotEmpty).toList();
    } catch (e) {
      print("❌ Error loading labels: $e");
      return [];
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      isAnalyzed.value = false;
    }
  }

  Future<void> captureImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      isAnalyzed.value = false;
    }
  }

  Future<void> analyzeImage() async {
    if (selectedImagePath.value.isEmpty) {
      Get.snackbar("Error", "Please upload or capture an image.");
      return;
    }

    try {
      File imageFile = File(selectedImagePath.value);
      var input = await preprocessImage(imageFile);
      var output = List.filled(1 * labels.length, 0.0).reshape([1, labels.length]);

      interpreter.run(input, output);

      List<double> prediction = output[0].cast<double>();
      int predictedIndex = prediction.indexOf(
          prediction.reduce((double a, double b) => a > b ? a : b)
      );
      double confidence = prediction[predictedIndex];
      predictionConfidence.value = confidence; // ✅ Save for UI if needed

      if (confidence < 0.6) {
        plantName.value = "";
        diseaseName.value = "";
        recommendation.value = "";
        isAnalyzed.value = false;

        Get.snackbar(
          "Unrecognized Plant",
          "Image confidence is too low (${(confidence * 100).toStringAsFixed(1)}%). Please try again with a clearer image of a plant leaf.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      plantName.value = labels[predictedIndex];
      diseaseName.value = labels[predictedIndex];

      print("✅ Prediction: ${plantName.value} with ${(confidence * 100).toStringAsFixed(2)}% confidence");

      await getRecommendationFromGemini(diseaseName.value);
      await savePredictionToFirestore();

      isAnalyzed.value = true;
    } catch (e) {
      print("❌ Failed to analyze the image: $e");
      Get.snackbar("Error", "Failed to analyze the image.");
    }
  }

  Future<List<List<List<List<double>>>>> preprocessImage(File imageFile) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception("Failed to decode image.");
      }

      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      List<List<List<List<double>>>> input = List.generate(
        1,
            (i) => List.generate(
          224,
              (j) => List.generate(
            224,
                (k) {
              img.Pixel pixel = resizedImage.getPixel(j, k);
              return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
            },
          ),
        ),
      );

      return input;
    } catch (e) {
      print("❌ Error preprocessing image: $e");
      throw e;
    }
  }

  Future<void> getRecommendationFromGemini(String plantDisease) async {
    if (plantDisease.isEmpty) return;

    try {
      var url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey");
      var headers = {"Content-Type": "application/json"};
      var body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "What is the best treatment for $plantDisease? Provide recommendations."}
            ]
          }
        ]
      });

      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        recommendation.value = jsonResponse["candidates"][0]["content"]["parts"][0]["text"];
        print("✅ Gemini Recommendation: ${recommendation.value}");
      } else {
        print("❌ Failed to get recommendation from Gemini.");
      }
    } catch (e) {
      print("❌ Gemini API Error: $e");
    }
  }

  Future<void> savePredictionToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ User not authenticated");
        return;
      }

      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("plant_diagnosis")
          .add({
        "imagePath": selectedImagePath.value,
        "plantName": plantName.value,
        "diseaseName": diseaseName.value,
        "recommendation": recommendation.value,
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("✅ Diagnosis saved for user: ${user.uid}");
    } catch (e) {
      print("❌ Failed to save diagnosis: $e");
    }
  }
}
