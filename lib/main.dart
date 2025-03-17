import 'package:agromind/bindings/chat_binding/chat_binding.dart';
import 'package:agromind/bindings/community_binding/community_binding.dart';
import 'package:agromind/bindings/drawer_bindings/drawer_binding.dart';
import 'package:agromind/bindings/forgot_password/forgot_password_binding.dart';
import 'package:agromind/bindings/info_screen/info_binding.dart';
import 'package:agromind/bindings/plant_library_binding/plant_library_binding.dart';
import 'package:agromind/bindings/profile_binding/profile_binding.dart';
import 'package:agromind/bindings/splash_screen/splash_binding.dart';
import 'package:agromind/screens/CommunityDetailsScreen/CommunityDetailsScreen.dart';
import 'package:agromind/screens/CreatePostScreen/CreatePostScreen.dart';
import 'package:agromind/screens/HomeScreen/home_screen.dart';
import 'package:agromind/screens/PlantDetailsScreen/PlantDetailsScreen.dart';
import 'package:agromind/screens/PlantLibraryScreen/PlantLibraryScreen.dart';
import 'package:agromind/screens/chat_screen/chat_screen.dart';
import 'package:agromind/screens/community_screen/community_screen.dart';
import 'package:agromind/screens/info_screen/info_screen.dart';
import 'package:agromind/screens/my_garden_screen/my_garden_screen.dart';
import 'package:agromind/screens/plant_diagnosis_screen/plant_diagnosis_screen.dart';
import 'package:agromind/screens/profile_screen/profile_screen.dart';
import 'package:agromind/screens/register_screen/register_screen.dart';
import 'package:agromind/screens/register_verifyaccount/register_verify_account_screen.dart';
import 'package:agromind/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import Screens
import 'package:agromind/screens/welcome/welcome_screen.dart';
import 'package:agromind/screens/login_screen/login_screen.dart';
import 'package:agromind/screens/forgot_password/forgot_password_screen.dart';
import 'package:agromind/screens/verify_account_screens/verify_account_screen.dart';
import 'package:agromind/screens/create_new_password_screen/new_password_screen.dart';

// Import Bindings
import 'package:agromind/bindings/welcome_screen/welcome_binding.dart';
import 'package:agromind/bindings/login_screen/login_binding.dart';
import 'package:agromind/bindings/verify_account_binding/verify_account_binding.dart';
import 'package:agromind/bindings/create_new_password_binding/new_password_binding.dart';
import 'bindings/home_binding/home_binding.dart';
import 'bindings/my_garden_binding/my_garden_binding.dart';
import 'bindings/plant_diagnosis_binding/plant_diagnosis_binding.dart';
import 'bindings/register_binding/register_binding.dart';
import 'bindings/register_verifyaccount_binding/register_verify_account_binding.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Ensure `initialRoute` is never null
  String initialRoute = FirebaseAuth.instance.currentUser != null ? '/home' : '/splash';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen(), binding: SplashBinding()), // ✅ Fix this
        GetPage(name: '/info', page: () => InfoScreen(), binding: InfoBinding()),
        GetPage(name: '/welcome', page: () => WelcomeScreen(), binding: WelcomeBinding()), // ✅ Keep only this
        GetPage(name: '/login', page: () => LoginScreen(), binding: LoginBinding()),
        GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen(), binding: ForgotPasswordBinding()),
        GetPage(name: '/verify-account', page: () => VerifyAccountScreen(), binding: VerifyAccountBinding()),
        GetPage(name: '/new-password', page: () => NewPasswordScreen(), binding: NewPasswordBinding()),
        GetPage(name: '/register', page: () => RegisterScreen(), binding: RegisterBinding()),
        GetPage(name: '/register-verify-account', page: () => RegisterVerifyAccountScreen(), binding: RegisterVerifyAccountBinding()),
        GetPage(name: '/home', page: () => HomeScreen(), binding: HomeBinding()),
        GetPage(name: '/plantDiagnosis', page: () => PlantDiagnosisScreen(), binding: PlantDiagnosisBinding()),
        GetPage(name: '/mygarden', page: () => MyGardenScreen(), binding: MyGardenBinding()),
        GetPage(name: '/profile', page: () => ProfileScreen(), binding: ProfileBinding()),
        GetPage(name: '/plant-health-advisor', page: () => ChatScreen(), binding: ChatBinding()),
        GetPage(name: '/plant_library', page: ()=> PlantLibraryScreen(), binding: PlantLibraryBinding()),
        GetPage(name: '/plantDetails', page: () => PlantDetailsScreen()),
        GetPage(name: '/community', page: ()=> CommunityScreen(), binding: CommunityBinding()),
        GetPage(name: '/communityDetails', page: () => CommunityDetailsScreen()),
        GetPage(name: "/createPost", page: () => CreatePostScreen()),
      ],
    );
  }
}