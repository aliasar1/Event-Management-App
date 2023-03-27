import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../manager/firebase_constants.dart';
import '../models/enums.dart';
import '../utils/utils.dart';
import '../models/user.dart' as model;
import '../views/user_type_views/organizer/organizer_home_screen.dart';
import '../views/user_type_views/participant/participant_home_screen.dart';
import '../views/login_screen.dart';

class AuthenticateController extends GetxController with CacheManager {
  RxBool isLoggedIn = false.obs;
  RxBool isAdmin = false.obs;
  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late String userTypeController = 'Participant';

  //model.User user = model.User();

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
    await firebaseAuth.signOut();
    Get.offAllNamed(LoginScreen.routeName);
  }

  Future<void> checkLoginStatus() async {
    firebaseAuth.idTokenChanges().listen((User? user) {
      if (user == null) {
        removeToken();
        Get.offAllNamed(LoginScreen.routeName);
      } else {
        Get.offAllNamed(
          OrganizerHomeScreen.routeName,
        );
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

  Future<bool> saveOrganizerDetails(model.User organizer) async {
    final box = GetStorage();
    await box.write(
        CacheManagerKeys.organizerDetails.toString(), organizer.toJson());
    return true;
  }

  Future<bool> saveParticipantDetails(model.User participant) async {
    final box = GetStorage();
    await box.write(
        CacheManagerKeys.participantDetails.toString(), participant.toJson());
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKeys.token.toString());
  }

  model.User? getOrganizerDetails() {
    final box = GetStorage();
    return model.User.fromSnap(
        box.read(CacheManagerKeys.organizerDetails.toString()));
  }

  model.User? getParticipantDetails() {
    final box = GetStorage();
    return model.User.fromSnap(
        box.read(CacheManagerKeys.participantDetails.toString()));
  }

  bool? getUserType() {
    final box = GetStorage();
    return box.read(CacheManagerKeys.isOrganizer.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKeys.token.toString());
    await box.remove(CacheManagerKeys.isOrganizer.toString());
    await box.remove(CacheManagerKeys.organizerDetails.toString());
    await box.remove(CacheManagerKeys.participantDetails.toString());
  }
}
