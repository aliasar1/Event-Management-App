import 'package:cloud_firestore/cloud_firestore.dart';

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
        "description": description,
        "organizerId": organizerId,
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
      category: snapshot['category'],
      description: snapshot['description'],
      organizerId: snapshot['organizerId'],
    );
  }
}
