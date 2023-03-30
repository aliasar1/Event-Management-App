import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/models/user.dart';

class Event {
  String id,
      name,
      startDate,
      endDate,
      startTime,
      endTime,
      posterUrl,
      price,
      category;
  List<User>? participants;
  String organizerId;

  Event({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.posterUrl,
    required this.price,
    required this.category,
    required this.organizerId,
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
        "category": category,
        "participants": participants,
        "organizerId": organizerId
      };

  static Future<Event> fromSnap(DocumentSnapshot snap) async {
    var snapshot = snap.data() as Map<String, dynamic>;

    List<String> participantIds = List<String>.from(snapshot['participants']);
    List<User> participants = [];
    for (String id in participantIds) {
      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      participants.add(User.fromSnap(userSnap));
    }

    return Event(
      id: snapshot['id'],
      name: snapshot['name'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      startTime: snapshot['startTime'],
      endTime: snapshot['endTime'],
      posterUrl: snapshot['posterUrl'],
      price: snapshot['price'],
      category: snapshot['category'],
      participants: participants,
      organizerId: snapshot['organizerId'],
    );
  }
}
