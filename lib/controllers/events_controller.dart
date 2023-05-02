import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  RxList<Event> favoriteEvents = <Event>[].obs;

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
    Reference ref = firebaseStorage.ref().child('events').child(id);

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

  Future<void> generateAndSaveQrCode(User user, String eventId) async {
    try {
      // Generate QR code data
      //final qrData = user.toJson().toString();
      final qrData = "${user.uid}-$eventId";
      final qrImage = await QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        emptyColor: Colors.white,
      ).toImage(300);

      // Convert QR image to bytes
      final pngBytes = await qrImage.toByteData(format: ImageByteFormat.png);
      final pngBytesList = pngBytes!.buffer.asUint8List();

      // Upload QR image to Firebase Storage
      final ref = firebaseStorage
          .ref()
          .child('qrCodes')
          .child(eventId)
          .child(firebaseAuth.currentUser!.uid);
      final uploadTask = await ref.putData(pngBytesList);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      final participantRef = firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc(firebaseAuth.currentUser!.uid);
      await participantRef.set(
        {
          ...user.toJson(),
          'qrCode': downloadUrl,
          'haveAttended': false,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Failure!',
        'Failed to register in event.',
      );
    }
  }

  Future<void> addParticipantToEvent(dynamic userObj, String eventId) async {
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

      generateAndSaveQrCode(user, eventId);
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

  Future<String> showEventQr(Event event) async {
    final participantRef = firestore
        .collection('events')
        .doc(event.id)
        .collection('participants')
        .doc(firebaseAuth.currentUser!.uid);
    final docSnapshot = await participantRef.get();
    final participantData = docSnapshot.data();
    return participantData!['qrCode'];
  }

  void removeParticipantFromEvent(String participantId, String eventId) async {
    try {
      final participantRef = firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc(participantId);
      final participantDoc = await participantRef.get();
      if (!participantDoc.exists) {
        throw Exception('Participant document does not exist');
      }

      await participantRef.delete();

      final qrCodeUrl = participantDoc['qrCode'];
      if (qrCodeUrl != null) {
        final storageRef = firebaseStorage.refFromURL(qrCodeUrl);
        await storageRef.delete();
      }

      Get.back();
      Get.snackbar(
        'Success!',
        'You have successfully deregister yourself from the event.',
      );
    } catch (e) {
      Get.snackbar(
        'Failure!',
        'Failed to remove the participant from the event.',
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

  Future<List<String>> getAllEventIds() async {
    CollectionReference eventsRef = firestore.collection('events');
    QuerySnapshot<Object?> querySnapshot = await eventsRef.get();
    List<String> eventIds = querySnapshot.docs.map((doc) => doc.id).toList();
    return eventIds;
  }

  Future<Event?> getEventById(String eventId) async {
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .get();

    if (eventSnapshot.exists) {
      return Event.fromSnap(eventSnapshot);
    } else {
      return null;
    }
  }

  Stream<List<Event>> getUserFavEvents() async* {
    List<String> eventIds = await getAllEventIds();
    List<Event> events = [];
    for (var i in eventIds) {
      if (await isEventFavorite(i)) {
        Event? event = await getEventById(i);
        events.add(event!);
      }
    }
    yield events;
  }

  Future<List<Event>> getEventsByIds(List<String> eventIds) {
    CollectionReference eventsRef = firestore.collection('events');
    Query eventsQuery =
        eventsRef.where(FieldPath.documentId, whereIn: eventIds);
    return eventsQuery.get().then((querySnapshot) =>
        querySnapshot.docs.map((doc) => Event.fromSnap(doc)).toList());
  }

  Future<bool> isEventFavorite(String eventId) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('events')
          .doc(eventId)
          .collection('favourite')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      return snapshot.exists && snapshot.get('isFav') == true;
    } catch (e) {
      print('Error checking if event is favorite: $e');
      return false;
    }
  }

  Future<bool> getFavStatus(String id) async {
    QuerySnapshot<Map<String, dynamic>> snap = await firestore
        .collection('events')
        .doc(id)
        .collection('favourite')
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

  Future<List<Map<String, dynamic>>> getUserPresence(String eventId) async {
    final querySnapshot = await firestore
        .collection('events')
        .doc(eventId)
        .collection('participants')
        .get();

    final participantList = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {'uid': data['uid'], 'haveAttended': data['haveAttended']};
    }).toList();

    return participantList;
  }

  Future<List<User>> getAllEventParticipants(String eventId) async {
    final participantRef =
        firestore.collection('events').doc(eventId).collection('participants');

    final participantSnapshot = await participantRef.get();

    final participantList = <User>[];

    if (participantSnapshot.docs.isEmpty) {
      return participantList;
    }

    for (final participantDoc in participantSnapshot.docs) {
      final participant = User.fromMap(participantDoc);
      participantList.add(participant);
    }
    return participantList;
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
