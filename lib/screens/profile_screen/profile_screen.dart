import 'package:agromind/screens/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../controllers/auth_controller/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String email = "";
  File? _selectedImage;
  bool _isEditing = false; // ✅ Toggle edit mode

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// **Load user details from Firestore**
  void loadUserData() async {
    var userData = await authController.getUserDetails();
    if (userData != null) {
      setState(() {
        firstNameController.text = userData['firstName'] ?? "";
        lastNameController.text = userData['lastName'] ?? "";
        locationController.text = userData['location'] ?? "";
        email = userData['email'] ?? ""; // ✅ Fetch Email ID
      });
    }
  }

  /// **Pick Profile Image**
  Future<void> pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  /// **Update User Profile in Firestore**
  void updateProfile() async {
    await authController.updateUserProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      location: locationController.text,
      imageFile: _selectedImage,
    );
    setState(() {
      _isEditing = false; // ✅ After saving, disable edit mode
    });
    Get.snackbar("Success", "Profile updated successfully!");
  }

  void onClose() {
    Navigator.of(context).pop(); // ✅ Closes the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(onClose: onClose), // ✅ Custom Drawer Added
      extendBodyBehindAppBar: true, // ✅ Extend body behind AppBar for a better UI
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile & Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ✅ Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/plantdiagnosis_background.png", // 🌿 Use Plant Diagnosis background
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Profile Content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10), // ✅ Spacing after title

                  // 🌟 Profile Picture with Floating Action Button
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : AssetImage("assets/images/profile_placeholder.png") as ImageProvider,
                        child: _selectedImage == null
                            ? Icon(Icons.person, size: 50, color: Colors.white70)
                            : null,
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.green.shade700,
                          onPressed: pickImage,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20), // ✅ Space below profile image

                  // 🌟 Email (Non-Editable)
                  buildTextField(
                    label: "Email",
                    icon: Icons.email,
                    value: email,
                    isEditable: false,
                  ),
                  SizedBox(height: 10),

                  // 🌟 First Name Field
                  buildTextField(
                    controller: firstNameController,
                    label: "First Name",
                    icon: Icons.person,
                    isEditable: _isEditing,
                  ),
                  SizedBox(height: 10),

                  // 🌟 Last Name Field
                  buildTextField(
                    controller: lastNameController,
                    label: "Last Name",
                    icon: Icons.person_outline,
                    isEditable: _isEditing,
                  ),
                  SizedBox(height: 10),

                  // 🌟 Location Field
                  buildTextField(
                    controller: locationController,
                    label: "Location",
                    icon: Icons.location_on,
                    isEditable: _isEditing,
                  ),
                  SizedBox(height: 20),

                  // 🌟 Save or Edit Profile Button
                  ElevatedButton(
                    onPressed: () {
                      if (_isEditing) {
                        updateProfile(); // ✅ Save if in editing mode
                      } else {
                        setState(() {
                          _isEditing = true; // ✅ Enable edit mode
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _isEditing ? "Save Profile" : "Edit Profile",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ❌ Logout Button
                  ElevatedButton(
                    onPressed: () {
                      authController.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🌟 **Reusable TextField Widget**
  Widget buildTextField({
    TextEditingController? controller,
    required String label,
    required IconData icon,
    bool isEditable = true,
    String? value,
  }) {
    return TextField(
      controller: controller ?? TextEditingController(text: value),
      readOnly: !isEditable, // ✅ Make non-editable when needed
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade800),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(fontSize: 16),
    );
  }
}
