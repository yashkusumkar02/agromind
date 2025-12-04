import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  RxBool isTyping = false.obs;

  final GenerativeModel model = GenerativeModel(
    model: "gemini-2.0-flash",
    apiKey: "AIzaSyDx9GcqmJzNhfEojVY00pyO7N3-ziGD4qM", // 🔥 Replace with secure API storage
  );

  @override
  void onInit() {
    super.onInit();
    _sendWelcomeMessage(); // ✅ Send Welcome Message on Start
  }

  // ✅ Send Welcome Message when Chat Starts
  void _sendWelcomeMessage() {
    messages.insert(0, {
      "sender": "bot",
      "text":
      "🌿 Welcome to **AgroMind**! I am your **Plant Health Advisor**. 🌱\n\nYou can ask me about:\n✅ Plant Care (Watering, Sunlight, Fertilizer)\n✅ Disease Diagnosis\n✅ Growth & Maintenance Advice"
    });
  }

  // ✅ Send User Message and Fetch AI Response
  void sendMessage() async {
    String userMessage = textController.text.trim();
    if (userMessage.isEmpty) return;

    messages.insert(0, {"sender": "user", "text": userMessage});
    textController.clear();
    isTyping.value = true;

    try {
      // ✅ Ensure AI only answers plant-related queries
      if (!_isPlantRelated(userMessage)) {
        messages.insert(0, {
          "sender": "bot",
          "text": "🚫 I can only help with **plant care, plant health, and gardening advice**. 🌱 Try asking about watering, sunlight, or plant diseases."
        });
      } else {
        // ✅ Send query to Gemini AI
        final response = await model.generateContent([Content.text(userMessage)]);
        String botResponse = response.text ?? "I'm not sure, please try again!";
        messages.insert(0, {"sender": "bot", "text": botResponse});
      }
    } catch (e) {
      messages.insert(0, {"sender": "bot", "text": "⚠️ Error: Unable to process your request at the moment."});
    }

    isTyping.value = false;
  }

  // ✅ Validate if Query is Plant-Related
  bool _isPlantRelated(String query) {
    List<String> plantKeywords = [
      "plant", "watering", "fertilizer", "soil", "disease", "sunlight", "leaves", "growth",
      "flowers", "gardening", "seeds", "roots", "photosynthesis", "botany"
    ];

    for (String keyword in plantKeywords) {
      if (query.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }
}
