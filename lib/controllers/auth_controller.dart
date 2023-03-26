import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../manager/firebase_constants.dart';
import '../utils/utils.dart';
import '../models/user.dart' as model;
import '../views/user_type_views/organizer/organizer_home_screen.dart';
import '../views/user_type_views/participant/participant_home_screen.dart';
import '../views/login_screen.dart';

class AuthenticateController extends GetxController {
  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoading = false.obs;
  //late Rx<User?> _user;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late String userTypeController = 'Participant';

  // User get user => _user.value!;

  // @override
  // void onReady() {
  //   super.onReady();
  //   _user = Rx<User?>(firebaseAuth.currentUser!);
  //   _user.bindStream(firebaseAuth.authStateChanges());
  //   ever(_user, _setInitialScreen);
  // }

  // _setInitialScreen(User? user) {
  //   if (user == null) {
  //     Get.offAll(LoginScreen());
  //   } else {
  //     Get.offAll(HomeScreen());
  //   }
  // }

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
  }

  void toggleLoading({bool showMessage = false, String message = ''}) {
    isLoading.value = !isLoading.value;
    if (showMessage) {
      Utils.showSnackBar(
        message,
        isSuccess: false,
      );
    }
  }

  Future<void> loginUser(String email, String password, String userType) async {
    try {
      if (loginFormKey.currentState!.validate()) {
        loginFormKey.currentState!.save();
        toggleLoading();
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        if (userType == 'Participant') {
          Get.offNamed(ParticipantHomeScreen.routeName);
        } else {
          Get.offNamed(OrganizerHomeScreen.routeName);
        }
        toggleLoading();
        resetFields();
      }
    } catch (e) {
      toggleLoading();
      Get.snackbar(
        'Error Loggin in',
        e.toString(),
      );
    }
  }

  Future<void> registerUser(
      String email, String password, String name, String phone) async {
    try {
      if (signupFormKey.currentState!.validate()) {
        signupFormKey.currentState!.save();
        toggleLoading();
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        model.User user = model.User(
            name: name,
            email: email,
            profilePhoto: '',
            uid: cred.user!.uid,
            phone: phone);
        await firestore
            .collection(usersCollection)
            .doc(cred.user!.uid)
            .set(user.toJson());
        toggleLoading();
        Get.snackbar(
          'Success!',
          'Account created successfully.',
        );
        Get.offNamed(LoginScreen.routeName);
        resetFields();
      }
    } catch (e) {
      toggleLoading();
      Get.snackbar(
        'Error Loggin in',
        e.toString(),
      );
    }
  }

  void resetFields() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    phoneController.clear();
    userTypeController = 'Participant';
  }

  void logout() async {
    await firebaseAuth.signOut();
    Get.offAllNamed(LoginScreen.routeName);
  }
}
