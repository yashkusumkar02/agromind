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
  final String apiKey = "AIzaSyDx9GcqmJzNhfEojVY00pyO7N3-ziGD4qM"; // Replace with actual API key

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      // Load model with error handling
      interpreter = await Interpreter.fromAsset("assets/models/plant_disease_model.tflite",
          options: InterpreterOptions()..threads = 4);

      // Print model input/output details for debugging
      print("Model input details: ${interpreter.getInputTensors()}");
      print("Model output details: ${interpreter.getOutputTensors()}");

      // Load labels
      labels = await loadLabels();
      if (labels.isEmpty) {
        throw Exception("No labels loaded");
      }
      print("Loaded ${labels.length} labels");

    } catch (e) {
      print("❌ Critical error loading model: $e");
      Get.snackbar("Error", "Failed to initialize plant recognition system");
      throw e; // Re-throw to prevent further execution
    }
  }

  Future<List<String>> loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString("assets/models/plant_labels.txt");
      final loadedLabels = labelsData.split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();

      // Verify labels have correct format
      for (final label in loadedLabels) {
        if (!label.contains(RegExp(r'_{2,3}'))) {
          print("⚠️ Potentially malformed label: $label");
        }
      }

      print("Successfully loaded ${loadedLabels.length} labels");
      return loadedLabels;
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
      Get.snackbar("Error", "Please select an image first");
      return;
    }

    try {
      final inputImage = await preprocessImage(File(selectedImagePath.value));
      final output = List<double>.filled(labels.length, 0.0).reshape([1, labels.length]);
      interpreter.run(inputImage, output);

      final predictions = (output[0] as List).cast<double>();
      final maxConfidence = predictions.reduce((a, b) => a > b ? a : b);
      final predictedIndex = predictions.indexOf(maxConfidence);

      print("Raw predictions: $predictions");
      print("Max confidence: $maxConfidence at index $predictedIndex");

      if (maxConfidence < 0.6) {
        Get.snackbar(
          "Low Confidence",
          "Please try a clearer image (${(maxConfidence * 100).toStringAsFixed(1)}% confidence)",
          duration: Duration(seconds: 3),
        );
        return;
      }

      if (predictedIndex < 0 || predictedIndex >= labels.length) {
        throw FormatException("Invalid prediction index: $predictedIndex");
      }

      final fullLabel = labels[predictedIndex];
      print("Raw label: $fullLabel");

      // Handle different label formats
      final separator = fullLabel.contains('___') ? '___' :
      fullLabel.contains('__') ? '__' : '_';
      final labelParts = fullLabel.split(separator);

      if (labelParts.isEmpty) {
        throw FormatException("Empty label at index $predictedIndex");
      }

      plantName.value = labelParts[0].replaceAll('_', ' ').trim();
      diseaseName.value = labelParts.length > 1
          ? labelParts[1].replaceAll('_', ' ').trim()
          : "Unknown Disease";

      predictionConfidence.value = maxConfidence;
      await getRecommendationFromGemini(diseaseName.value);
      await savePredictionToFirestore();

      isAnalyzed.value = true;

    } catch (e) {
      print("❌ Analysis error: $e");
      if (e is StackTrace) {
        print("Stack trace: $e");
      }

      String errorMessage = "Analysis failed";
      if (e is FormatException) {
        errorMessage = "Invalid image format";
      } else if (e.toString().contains("Malformed label")) {
        errorMessage = "Plant database error";
      }

      Get.snackbar(
        "Error",
        errorMessage,
        duration: Duration(seconds: 3),
      );
      resetAnalysis();
    }
  }

  void resetAnalysis() {
    plantName.value = "";
    diseaseName.value = "";
    recommendation.value = "";
    predictionConfidence.value = 0.0;
    isAnalyzed.value = false;
  }

  Future<void> verifyModel() async {
    try {
      // Test with dummy input
      final dummyInput = List<List<List<List<double>>>>.generate(
        1,
            (_) => List<List<List<double>>>.generate(
          224,
              (y) => List<List<double>>.generate(
            224,
                (x) => [0.5, 0.5, 0.5], // Gray image
          ),
        ),
      );

      final output = List<double>.filled(labels.length, 0.0).reshape([1, labels.length]);
      interpreter.run(dummyInput, output);

      print("Model test successful. Output shape: ${output.length}x${output[0].length}");
    } catch (e) {
      print("❌ Model verification failed: $e");
      throw Exception("Model test failed");
    }
  }

  Future<List<List<List<List<double>>>>> preprocessImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Image decoding failed");

      final resizedImage = img.copyResize(image, width: 224, height: 224);

      // Create properly typed 4D array
      final input = List<List<List<List<double>>>>.generate(
        1,
            (_) => List<List<List<double>>>.generate(
          224,
              (y) => List<List<double>>.generate(
            224,
                (x) {
              final pixel = resizedImage.getPixel(x, y);
              return <double>[
                pixel.r.toDouble() / 255.0,
                pixel.g.toDouble() / 255.0,
                pixel.b.toDouble() / 255.0,
              ];
            },
          ),
        ),
      );

      print("First pixel values (normalized): ${input[0][0][0]}");
      return input;
    } catch (e) {
      print("❌ Preprocessing error: $e");
      throw Exception("Image processing failed");
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
