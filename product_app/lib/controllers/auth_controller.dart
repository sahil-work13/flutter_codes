import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../routes/app_routes.dart';
import '../services/session_services.dart';

class AuthController extends GetxController {
  RxBool   isLoading = false.obs;
  late FirebaseAuth _auth;
  Rxn<User> firebaseuser = Rxn<User>();


  @override
  Future<void> init() async {
    _auth = FirebaseAuth.instance;

    firebaseuser.bindStream(_auth.authStateChanges());

    ever(firebaseuser, (_) {
      isLoading.value = false;
    });
  }

  Future<void> loginController(String email,String password) async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    //await SessionServices.saveUser(email);

    UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    isLoading.value = false;

    Get.offAllNamed(AppRoutes.home); // ✅ FIXED
  }

  Future<void> signupController(String Signupemail,String SignupPassword) async{
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 3));

    //await SessionServices.saveSignupUser(Signupemail, SignupPassword);

    UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: Signupemail, password: SignupPassword);

    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> logoutController() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login); // ✅ FIXED
  }
}
