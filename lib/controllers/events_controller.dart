import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../manager/color_manager.dart';
import '../manager/firebase_constants.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../utils/utils.dart';
import '../widgets/packages/dropdown_plus/src/dropdown.dart';

class EventController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> isLoading2 = false.obs;
  final addFormKey = GlobalKey<FormState>();

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get posterPhoto => _pickedImage.value;

  RxList<Event> myEvents = <Event>[].obs;
  RxList<Event> allEvents = <Event>[].obs;
  RxList<Event> registeredEvents = <Event>[].obs;

  final nameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
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

  void toggleLoading2() {
    isLoading.value = !isLoading.value;
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
      String endTime, String price, String category, String description) async {
    if (addFormKey.currentState!.validate()) {
      addFormKey.currentState!.save();
      toggleLoading();
      String id = await getUniqueId();

      String posterUrl = await _uploadToStorage(_pickedImage.value!);
      name = name.toLowerCase();
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
        description: description,
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

  void addParticipantToEvent(dynamic userObj, String eventId) async {
    try {
      toggleLoading2();
      User user;
      if (userObj is User) {
        user = userObj;
      } else {
        final docSnapshot =
            await firestore.collection('users').doc(userObj.uid).get();
        user = User.fromMap(docSnapshot.data()!);
      }

      final eventRef = firestore.collection('events').doc(eventId);
      await eventRef.update({
        'participants': FieldValue.arrayUnion([user.toJson()])
      });
      toggleLoading2();
      Get.back();
      Get.snackbar(
        'Success!',
        'You have successfully registered to attend the event.',
      );
    } catch (e) {
      toggleLoading2();
      Get.snackbar(
        'Failure!',
        'Failed to register in event.',
      );
    }
  }

  Future<List<Event>> getEventsOrganized() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('events')
          .where('organizerId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      List<Future<Event>> futures = [];
      futures = snapshot.docs.map((doc) => Event.fromSnap(doc)).toList();

      List<Event> events = [];

      for (var future in futures) {
        try {
          var event = await future;
          events.add(event);
        } catch (e) {
          Get.snackbar(
            'Error!',
            'Error fetching event details: $e',
          );
        }
      }
      allEvents = RxList<Event>.from(events.toList());
      return events;
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Error fetching event details: $e',
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
      List<Future<Event>> futures = [];
      futures = snapshot.docs.map((doc) => Event.fromSnap(doc)).toList();

      List<Event> events = [];

      for (var future in futures) {
        try {
          var event = await future;
          events.add(event);
        } catch (e) {
          Get.snackbar(
            'Error!',
            'Error fetching event details: $e',
          );
        }
      }
      allEvents = RxList<Event>.from(events.toList());
      return events;
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Error fetching event details: $e',
      );
      return [];
    }
  }

  // Future<List<Event>> getRegisteredEvents() async {
  //   try {
  //     QuerySnapshot snapshot = await firestore.collection('events').get();
  //     List<Future<Event>> futures = [];
  //     futures = snapshot.docs.map((doc) => Event.fromSnap(doc)).toList();

  //     List<Event> events = [];

  //     for (var future in futures) {
  //       try {
  //         var event = await future;
  //         events.add(event);
  //       } catch (e) {
  //         Get.snackbar(
  //           'Error!',
  //           'Error fetching event details: $e',
  //         );
  //       }
  //     }
  //     allEvents = RxList<Event>.from(events.toList());
  //     return events;
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error!',
  //       'Error fetching event details: $e',
  //     );
  //     return [];
  //   }
  // }

  Future<List<Event>> getAttendedEvents() async {
    try {
      print(firebaseAuth.currentUser!.uid);
      QuerySnapshot snapshot = await firestore.collection('events').where(
          'participants',
          arrayContains: {'uid': firebaseAuth.currentUser!.uid}).get();

      print(snapshot.docs.length);
      print("here");
      List<Future<Event>> futures = [];
      futures = snapshot.docs.map((doc) => Event.fromSnap(doc)).toList();
      print(futures.length);
      for (var future in futures) {
        try {
          var event = await future;
          registeredEvents.add(event);
        } catch (e) {
          Get.snackbar(
            'Error!',
            'Error fetching event details: $e',
          );
        }
      }
      registeredEvents = RxList<Event>.from(registeredEvents.toList());
      return registeredEvents;
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Error fetching event details: $e',
      );
      return [];
    }
  }

  void resetFields() {
    nameController.clear();
    startDateController.clear();
    endDateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    priceController.clear();
    descriptionController.clear();
    categoryController.dispose();
    categoryController = DropdownEditingController<String>();
    _pickedImage.value = null;
  }
}
