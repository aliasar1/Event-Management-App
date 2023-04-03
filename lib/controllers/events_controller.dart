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
  Rx<bool> isFav = false.obs;
  final addFormKey = GlobalKey<FormState>();

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get posterPhoto => _pickedImage.value;

  RxList<Event> organizedEvents = <Event>[].obs;
  RxList<Event> allEvents = <Event>[].obs;
  RxList<Event> attendedEvents = <Event>[].obs;

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
        user = User.fromMap(docSnapshot);
      }
      await firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .add(user.toJson());
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
      var eventsList = snapshot.docs.map((e) => Event.fromSnap(e)).toList();
      List<Event> events = [];
      for (var event in eventsList) {
        try {
          events.add(event);
        } catch (e) {
          Get.snackbar(
            'Error!',
            'Error fetching event details: $e',
          );
        }
      }
      organizedEvents = RxList<Event>.from(events.toList());
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
                organizedEvents.removeWhere((event) => event.id == eventId);
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

  Future<List<Event>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('events').get();
      var eventsList = snapshot.docs.map((e) => Event.fromSnap(e)).toList();
      List<Event> events = [];
      for (var event in eventsList) {
        try {
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

  Future<List<Event>> getAttendedEvents() async {
    try {
      QuerySnapshot eventSnapshot = await firestore.collection('events').get();
      List<String> eventIds = eventSnapshot.docs.map((doc) => doc.id).toList();
      List<Event> events = [];
      for (var eventId in eventIds) {
        QuerySnapshot participantSnapshot = await firestore
            .collection('events')
            .doc(eventId)
            .collection('participants')
            .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
            .get();

        if (participantSnapshot.docs.isNotEmpty) {
          DocumentSnapshot eventDoc =
              await firestore.collection('events').doc(eventId).get();
          Event event = Event.fromSnap(eventDoc);
          events.add(event);
        }
      }
      attendedEvents = RxList<Event>.from(events.toList());
      return events;
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Error fetching event details: $e',
      );
      return [];
    }
  }

  Future<bool> getFavStatus(String id) async {
    QuerySnapshot<Map<String, dynamic>> snap = await firestore
        .collection('events')
        .doc(id)
        .collection('participants')
        .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    if (snap.docs.isNotEmpty) {
      Map<String, dynamic> data = snap.docs.first.data();
      return data['isFav'] ?? false;
    } else {
      return false;
    }
  }

  void toggleFavStatus(Event event) async {
    try {
      DocumentReference docRef = firestore
          .collection('events')
          .doc(event.id)
          .collection('favourite')
          .doc(firebaseAuth.currentUser!.uid);

      bool status = (await docRef.get()).exists;

      if (!status) {
        await docRef.set({
          'eventId': event.id,
          'uid': firebaseAuth.currentUser!.uid,
          'isFav': true
        });
        Get.snackbar(
          'Success!',
          'Event successfully marked as favourite.',
        );
      } else {
        await docRef.delete();
      }
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Error marking event as favourite.',
      );
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
