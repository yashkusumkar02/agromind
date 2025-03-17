import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs; // ✅ Loading state

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // ✅ Email Validation
  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(
        email);
  }

  // ✅ Password Security Validation
  bool isValidPassword(String password) {
    return RegExp(r"^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
        .hasMatch(password);
  }

  // ✅ Name Validation (Only Letters)
  bool isValidName(String name) {
    return RegExp(r"^[a-zA-Z]+$").hasMatch(name);
  }

  // ✅ Check if Email Already Exists
  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(
          email);
      return signInMethods
          .isNotEmpty; // ✅ Returns true if email is already registered
    } catch (e) {
      return false;
    }
  }

  // ✅ Register User and Send Email Verification
  Future<void> registerUser(String firstName, String lastName, String email,
      String password, String confirmPassword) async {
    if (!isValidName(firstName) || !isValidName(lastName)) {
      Get.snackbar(
          "Error", "First name and Last name should only contain letters.");
      return;
    }
    if (!isValidEmail(email)) {
      Get.snackbar("Error", "Enter a valid email address.");
      return;
    }
    if (!isValidPassword(password)) {
      Get.snackbar("Error",
          "Password must have at least 8 characters, 1 uppercase, 1 number, and 1 special character.");
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match.");
      return;
    }

    try {
      isLoading.value = true; // Start Loading

      // ✅ Check if Email is Already Registered
      if (await isEmailAlreadyRegistered(email)) {
        isLoading.value = false;
        Get.snackbar("Error", "This email is already in use. Try logging in.");
        return;
      }

      // ✅ Create user in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Send Email Verification Link
      await userCredential.user?.sendEmailVerification();

      // ✅ Store User Data in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "createdAt": DateTime.now(),
        "isVerified": false, // ✅ Track if the email is verified
      });

      isLoading.value = false; // Stop Loading

      // ✅ ✅ ✅ Manually Check if Email is Verified Before Navigating
      Future.delayed(Duration(seconds: 3), () async {
        await userCredential.user?.reload();
        if (userCredential.user?.emailVerified == true) {
          Get.offAllNamed('/login'); // ✅ If verified, navigate to login
        } else {
          Get.toNamed('/register-verify-account',
              arguments: email); // ✅ Else, go to verify account screen
        }
      });
    } on FirebaseAuthException catch (e) {
      isLoading.value = false; // Stop Loading
      String message = e.message ?? "Registration failed.";

      if (e.code == 'email-already-in-use') {
        message = "This email is already in use. Try logging in.";
      } else if (e.code == 'weak-password') {
        message = "Your password is too weak. Use a stronger password.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format.";
      }

      Get.snackbar("Registration Error", message);
    } catch (e) {
      isLoading.value = false; // Stop Loading
      Get.snackbar(
          "Registration Error", "Something went wrong. Please try again.");
    }
  }
}