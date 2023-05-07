import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/exports/manager_exports.dart';
import '../utils/utils.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get profilePhoto => _pickedImage.value;

  final Rx<String> _uid = "".obs;

  final editFormKey = GlobalKey<FormState>();
  final editPassFormKey = GlobalKey<FormState>();
  Rx<bool> isLoading = false.obs;
  Rx<bool> isObscure1 = true.obs;
  Rx<bool> isObscure2 = true.obs;
  Rx<bool> isObscure3 = true.obs;

  void toggleLoading({bool showMessage = false, String message = ''}) {
    isLoading.value = !isLoading.value;
    if (showMessage) {
      Utils.showSnackBar(
        message,
        isSuccess: false,
      );
    }
  }

  void toggleVisibility1() {
    isObscure1.value = !isObscure1.value;
  }

  void toggleVisibility2() {
    isObscure2.value = !isObscure2.value;
  }

  void toggleVisibility3() {
    isObscure3.value = !isObscure3.value;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController newRePassController = TextEditingController();

  updateUser(String name, String phone) async {
    if (editFormKey.currentState!.validate()) {
      editFormKey.currentState!.save();
      toggleLoading();
      await firestore.collection('users').doc(_uid.value).update({
        'name': name,
        'phone': phone,
      }).whenComplete(() {
        toggleLoading();
        getUserData();
        Get.back();
        Get.snackbar('User details updated!',
            'You have successfully updated user details!');
      });
    }
  }

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  void getUserData() async {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid.value).get();
    _user.value = userDoc.data()! as dynamic;
    update();
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _pickedImage.value = File(pickedImage!.path);
    String downloadUrl = await _uploadToStorage(_pickedImage.value!);
    await firestore
        .collection('users')
        .doc(_uid.value)
        .update({'profilePhoto': downloadUrl}).whenComplete(() {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture.');
    });
    update();
  }

  void changePassword(
      String currentPass, String newPass, String newRePass) async {
    if (newPass == newRePass) {
      if (editPassFormKey.currentState!.validate()) {
        editPassFormKey.currentState!.save();
        toggleLoading();
        try {
          final cred = EmailAuthProvider.credential(
              email: firebaseAuth.currentUser!.email!, password: currentPass);
          await firebaseAuth.currentUser!.reauthenticateWithCredential(cred);
          await firebaseAuth.currentUser!.updatePassword(newPass);
          Get.snackbar('Password updated successfully!',
              'You have successfully updated your password.');
          Get.back();
          toggleLoading();
        } catch (error) {
          toggleLoading();
          Get.snackbar('Password updated failed!', error.toString());
        }
      }
    } else {
      toggleLoading();
      Get.snackbar('Error!', 'Password does not match.');
    }
    resetFields();
  }

  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void resetFields() {
    nameController.clear();
    phoneController.clear();
    newPassController.clear();
    newRePassController.clear();
    oldPassController.clear();
    update();
  }
}
