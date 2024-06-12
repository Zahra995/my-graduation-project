import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String? password;
  String? email;
  bool isInstructor;
  User(
      {this.id,
      required this.name,
      required this.password,
      required this.email,
      required this.isInstructor});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'Password': password,
      'Email': email,
      'IsInstructor': isInstructor
    };
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final u = User.fromJson(snapshot.data() as Map<String, dynamic>);
    u.id = snapshot.reference.id;
    return u;
  }
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['Id'],
        name: map['Name'],
        password: map['Password'],
        email: map['Email'],
        isInstructor: map['IsInstructor']);
  }
}
