import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../manager/firebase_constants.dart';
import '../utils/utils.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get profilePhoto => _pickedImage.value;

  final Rx<String> _uid = "".obs;

  final editFormKey = GlobalKey<FormState>();
  Rx<bool> isLoading = false.obs;

  void toggleLoading({bool showMessage = false, String message = ''}) {
    isLoading.value = !isLoading.value;
    if (showMessage) {
      Utils.showSnackBar(
        message,
        isSuccess: false,
      );
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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

  void updateUserName() async {}

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
          'You have successfully selected your profile picture!');
    });
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
}
