import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../local/chache_manager.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/views_exports.dart';
import '../models/user.dart' as model;

class AuthenticateController extends GetxController with CacheManager {
  RxBool isLoggedIn = false.obs;
  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
  }

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  Future<bool> login(String email, String password) async {
    try {
      if (loginFormKey.currentState!.validate()) {
        loginFormKey.currentState!.save();
        toggleLoading();

        UserCredential userCredential = await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;

        if (user != null) {
          if (user.emailVerified) {
            saveToken(true);
            toggleLoading();
            clearfields();
            checkLoginStatus();
            return true;
          } else {
            toggleLoading();
            Get.snackbar(
              'Error Logging in',
              'Please verify your email to login.',
            );
            return true;
          }
        } else {
          toggleLoading();
          Get.snackbar(
            'Error Logging in',
            'Invalid email or password.',
          );
          return false;
        }
      }
      return false;
    } catch (err) {
      toggleLoading();
      Get.snackbar(
        'Error Logging in',
        err.toString(),
      );
      return false;
    }
  }

  Future<bool> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      if (signupFormKey.currentState!.validate()) {
        signupFormKey.currentState!.save();
        toggleLoading();
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await firebaseAuth.currentUser!.sendEmailVerification();

        model.User user = model.User(
          name: name,
          uid: cred.user!.uid,
          phone: phone,
          email: email,
          profilePhoto: "",
        );

        await firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        removeToken();
        toggleLoading();

        Get.snackbar(
          'Account created successfully!',
          'Please verify account to proceed.',
        );
        return true;
      }
      return false;
    } catch (e) {
      toggleLoading();
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
      return false;
    }
  }

  void logout() async {
    removeToken();
    await firebaseAuth.signOut();

    // Get.dialog(
    //   AlertDialog(
    //     backgroundColor: ColorManager.scaffoldBackgroundColor,
    //     title: const Text('Confirm Logout'),
    //     content: const Text('Are you sure you want to log out?'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Get.back(),
    //         child: const Text(
    //           'Cancel',
    //           style: TextStyle(color: ColorManager.primaryColor),
    //         ),
    //       ),
    //       ElevatedButton(
    //         style: ButtonStyle(
    //             backgroundColor:
    //                 MaterialStateProperty.all(ColorManager.primaryColor)),
    //         onPressed: () async {
    //           await firebaseAuth.signOut();
    //           removeToken();
    //           isLoggedIn.value = false;
    //           Get.offAllNamed(LoginScreen.routeName);
    //         },
    //         child: const Text(
    //           'Logout',
    //           style: TextStyle(color: ColorManager.backgroundColor),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void checkLoginStatus() {
    if (getToken() == null || getToken() == false) {
      Get.offAll(LoginScreen());
    } else {
      Get.offAll(const OrganizerHomeScreen());
    }
  }

  void clearfields() {
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    nameController.clear();
  }
}
