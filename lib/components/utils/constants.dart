import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tutorials_library/Auth/controllers/auth_controller.dart';

AuthController authController = AuthController.instance;
final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final CollectionReference usersCollection =
    firebaseFirestore.collection('users');
final CollectionReference filesCollection =
    firebaseFirestore.collection('files');
final hiveStorage = Hive.openBox('mainData');
