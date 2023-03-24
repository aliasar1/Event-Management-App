import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticateController extends GetxController {
  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
  }

  void toggleLoading({bool showMessage = false, String message = ''}) {
    isLoading.value = !isLoading.value;
    if (showMessage) {
      // Utils.showSnackBar(
      //   message,
      //   isSuccess: false,
      // );
    }
  }

  void loginUser(String email, String password) {}
}
