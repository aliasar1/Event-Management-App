import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/enums.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/views_exports.dart';
import '../utils/utils.dart';
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
  late String userTypeController = 'Participant';

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
        isLoggedIn.value = true;
        toggleLoading();
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        if (userType == 'Participant') {
          saveToken(firebaseAuth.currentUser!.uid, false);
          Get.offNamed(ParticipantHomeScreen.routeName);
        } else {
          saveToken(firebaseAuth.currentUser!.uid, true);
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
        Get.offAllNamed(LoginScreen.routeName);
        Get.snackbar(
          'Success!',
          'Account created successfully.',
        );
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
    update();
  }

  void logout() async {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorManager.primaryColor)),
            onPressed: () async {
              await firebaseAuth.signOut();
              removeToken();
              isLoggedIn.value = false;
              Get.offAllNamed(LoginScreen.routeName);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: ColorManager.backgroundColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkLoginStatus() async {
    firebaseAuth.idTokenChanges().listen((User? user) {
      if (user == null) {
        removeToken();
        Get.offAllNamed(LoginScreen.routeName);
      } else {
        if (getUserType() == true) {
          Get.offAllNamed(OrganizerHomeScreen.routeName);
        } else {
          Get.offAllNamed(ParticipantHomeScreen.routeName);
        }
      }
    });
  }
}

mixin CacheManager {
  Future<bool> saveToken(String token, bool isOrganizer) async {
    final box = GetStorage();
    await box.write(CacheManagerKeys.token.toString(), token);
    await box.write(CacheManagerKeys.isOrganizer.toString(), isOrganizer);
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKeys.token.toString());
  }

  bool? getUserType() {
    final box = GetStorage();
    return box.read(CacheManagerKeys.isOrganizer.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKeys.token.toString());
    await box.remove(CacheManagerKeys.isOrganizer.toString());
  }
}
