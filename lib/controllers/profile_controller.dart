import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../manager/firebase_constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get profilePhoto => _pickedImage.value;

  final Rx<String> _uid = "".obs;

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
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage.value = File(pickedImage!.path);
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
