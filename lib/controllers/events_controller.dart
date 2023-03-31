import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../manager/color_manager.dart';
import '../manager/firebase_constants.dart';
import '../models/event.dart';
import '../utils/utils.dart';
import '../widgets/packages/dropdown_plus/src/dropdown.dart';

class EventController extends GetxController {
  Rx<bool> isLoading = false.obs;
  final addFormKey = GlobalKey<FormState>();

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get posterPhoto => _pickedImage.value;

  RxList<Event> myEvents = <Event>[].obs;
  RxList<Event> allEvents = <Event>[].obs;

  final nameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final priceController = TextEditingController();
  var categoryController = DropdownEditingController<String>();

  void toggleLoading({bool showMessage = false, String message = ''}) {
    isLoading.value = !isLoading.value;
    if (showMessage) {
      Utils.showSnackBar(
        message,
        isSuccess: false,
      );
    }
  }

  Future<String> _uploadToStorage(File image) async {
    String id = await getUniqueId();
    Reference ref = firebaseStorage.ref().child('eventPoster').child(id);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getUniqueId() async {
    var allDocs = await firestore.collection('events').get();
    int len = allDocs.docs.length;
    return len.toString();
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar(
          'Poster Added!', 'You have successfully selected your event poster!');
    }
    _pickedImage.value = File(pickedImage!.path);
    update();
  }

  void addEvent(String name, String startDate, String endDate, String startTime,
      String endTime, String price, String category) async {
    if (addFormKey.currentState!.validate()) {
      addFormKey.currentState!.save();
      String id = await getUniqueId();
      toggleLoading();
      String posterUrl = await _uploadToStorage(_pickedImage.value!);

      Event event = Event(
        id: id,
        name: name,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        price: price,
        category: category,
        posterUrl: posterUrl,
        participants: [],
        organizerId: firebaseAuth.currentUser!.uid,
      );
      await firestore.collection('events').doc(id).set(event.toJson());
      allEvents.add(event);
      toggleLoading();
      Get.back();
      Get.snackbar(
        'Success!',
        'Event added successfully.',
      );
      resetFields();
    }
  }

  Future<List<Event>> getEventsOrganized() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('events')
          .where('organizerId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      List<Future<Event>> futures =
          snapshot.docs.map((doc) => Event.fromSnap(doc)).toList();
      List<Event> events = await Future.wait(futures);
      myEvents = RxList<Event>.from(events.toList());
      return events;
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Error fetching event details.',
      );
      return [];
    }
  }

  void deleteEvent(String eventId) async {
    try {
      Get.dialog(
        AlertDialog(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete event?'),
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
                await firestore.collection('events').doc(eventId).delete();
                allEvents.removeWhere((event) => event.id == eventId);
                myEvents.removeWhere((event) => event.id == eventId);
                Get.back();
                Get.snackbar(
                  'Success!',
                  'Event successfully deleted.',
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: ColorManager.backgroundColor),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('events').get();
      List<Future<Event>> futures =
          snapshot.docs.map((doc) => Event.fromSnap(doc)).toList();
      List<Event> events = await Future.wait(futures);
      allEvents = RxList<Event>.from(events.toList());
      return events; // return the list of Event objects
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Error fetching event detaisl.',
      );
      return []; // return an empty list instead of null
    }
  }

  void resetFields() {
    nameController.clear();
    startDateController.clear();
    endDateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    priceController.clear();
    categoryController.dispose();
    categoryController = DropdownEditingController<String>();
    _pickedImage.value = null;
  }
}
