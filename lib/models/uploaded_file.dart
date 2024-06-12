import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tutorials_library/Auth/controllers/auth_controller.dart';
import 'package:tutorials_library/components/utils/constants.dart';

class UploadedFile {
  String? title;
  String name;
  String downloadURL;
  String instructorID;
  String? instructorName;
  String? description;
  int? category;
  UploadedFile({
    this.title,
    required this.name,
    required this.downloadURL,
    required this.instructorID,
    this.instructorName,
    this.description,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'name': name,
      'downloadURL': downloadURL,
      'instructorID': instructorID,
      'description': description,
      'category': category,
    };
  }

  factory UploadedFile.fromSnapshot(DocumentSnapshot snapshot) {
    final u = UploadedFile.fromJson(snapshot.data() as Map<String, dynamic>);
    var ins = AuthController.instance;
    ins.setUSerName(u.instructorID);
    debugPrint(ins.UserName);
    u.instructorName = ins.UserName;
    return u;
  }
  factory UploadedFile.fromJson(Map<String, dynamic> map) {
    return UploadedFile(
      title: map['title'],
      name: map['name'],
      downloadURL: map['downloadURL'],
      instructorID: map['instructorID'],
      description: map['description'],
      category: map['category'],
    );
  }
}
