import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name, email, uid, profilePhoto, phone;

  User({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilePhoto,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "phone": phone,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot["email"],
      name: snapshot["name"],
      uid: snapshot["uid"],
      profilePhoto: snapshot["profilePhoto"],
      phone: snapshot["phone"],
    );
  }
}
