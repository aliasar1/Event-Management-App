import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/manager/firebase_constants.dart';
import 'package:event_booking_app/models/event.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final Rx<List<Event>> _searchedEvents = Rx<List<Event>>([]);

  List<Event> get searchedEvents => _searchedEvents.value;

  Future<void> searchEvent(String typedUser) async {
    if (typedUser.isEmpty) {
      _searchedEvents.value = [];
      return;
    }
    List<Event> retVal = [];
    QuerySnapshot query = await firestore
        .collection('events')
        .where('name', isGreaterThanOrEqualTo: typedUser.toLowerCase())
        .get();
    if (query.docs.isEmpty) {
      Get.snackbar(
        'Event not found!',
        'The event does not exist.',
      );
    } else {
      for (var elem in query.docs) {
        Event event = await Event.fromSnap(elem);
        if (event.name.toLowerCase().contains(typedUser.toLowerCase())) {
          retVal.add(event);
        }
      }
    }
    _searchedEvents.value = retVal;
  }
}
