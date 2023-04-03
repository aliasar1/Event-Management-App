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
      description,
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
    required this.description,
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
        "participants": participants?.map((e) => e.toJson()).toList(),
        "description": description,
        "organizerId": organizerId
      };

  static Future<Event> fromSnap(DocumentSnapshot? snap) async {
    if (snap == null) {
      return Future.error('Document snapshot is null');
    }

    var snapshot = snap.data() as Map<String, dynamic>;

    List<User>? participants;
    if (snapshot["participants"] != null) {
      participants = (snapshot["participants"] as List<dynamic>)
          .map((e) => User.fromMap(e))
          .toList();
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
      description: snapshot['description'],
      organizerId: snapshot['organizerId'],
    );
  }
}
