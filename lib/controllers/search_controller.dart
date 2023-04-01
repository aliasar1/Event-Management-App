import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/manager/firebase_constants.dart';
import 'package:event_booking_app/models/event.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final Rx<List<Event>> _searchedEvents = Rx<List<Event>>([]);
  RxBool isInit = false.obs;

  List<Event> get searchedEvents => _searchedEvents.value;

  Future<void> searchEvent(String typedUser) async {
    List<Event> retVal = [];
    QuerySnapshot query = await firestore
        .collection('events')
        .where('name', isGreaterThanOrEqualTo: typedUser.toLowerCase())
        .get();
    for (var elem in query.docs) {
      Event event = await Event.fromSnap(elem);
      if (event.name.toLowerCase().contains(typedUser.toLowerCase())) {
        retVal.add(event);
      }
    }
    isInit.value = !isInit.value;
    _searchedEvents.value = retVal;
  }
}
