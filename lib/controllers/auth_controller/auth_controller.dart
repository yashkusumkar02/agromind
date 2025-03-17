import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:io';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var user = Rxn<User>(); // ✅ Track logged-in user

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges()); // ✅ Track login state
  }

  /// ✅ **Implement onClose() Method**
  @override
  void onClose() {
    user.close(); // ✅ Dispose the user stream
    super.onClose();
  }

  /// **Get User Details from Firestore**
  Future<Map<String, dynamic>?> getUserDetails() async {
    if (user.value == null) return null;
    var doc = await _firestore.collection("users").doc(user.value!.uid).get();
    return doc.data();
  }

  /// **Update User Profile in Firestore**
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String location,
    File? imageFile,
  }) async {
    if (user.value == null) return;

    try {
      await _firestore.collection("users").doc(user.value!.uid).update({
        "firstName": firstName,
        "lastName": lastName,
        "location": location,
      });

      Get.snackbar("Success", "Profile updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile.");
    }
  }

  /// **Logout User**
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed("/login"); // ✅ Redirect to login screen
  }
}
