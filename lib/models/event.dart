import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/models/user.dart';

class Event {
  String id, name, startDate, endDate, startTime, endTime, posterUrl, price;
  List<User>? participants;

  Event({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.posterUrl,
    required this.price,
    this.participants,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "startDate": startDate,
        "endDate": endDate,
        "startTime": startTime,
        "endTime": endTime,
        "posterUrl": posterUrl,
        "price": price,
        "participants": participants,
      };

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Event(
        id: snapshot['id'],
        name: snapshot['name'],
        startDate: snapshot['startDate'],
        endDate: snapshot['endDate'],
        startTime: snapshot['startTime'],
        endTime: snapshot['endTime'],
        posterUrl: snapshot['posterUrl'],
        price: snapshot['price'],
        participants: snapshot['participants']);
  }
}
