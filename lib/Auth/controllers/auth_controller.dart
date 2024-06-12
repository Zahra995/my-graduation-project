import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tutorials_library/components/utils/constants.dart';
import 'package:tutorials_library/main.dart';
import 'package:tutorials_library/models/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  String get crrntUserType {
    loadCurrentType();
    return _CrrntType ?? '';
  }

  String? _CrrntType;
  void loadCurrentType() async {
    _CrrntType = await hiveStorage.then((value) => value.get('userType'));
  }

  String get crrntUser {
    loadCurrent();
    return _CrrntType ?? '';
  }

  String? _Crrnt;
  void loadCurrent() async {
    _Crrnt = await hiveStorage.then((value) => value.get('userType'));
  }

  String? UserName;
  Future setUSerName(String userID) async {
    var data = await firebaseFirestore.doc('/users/$userID').get();
    debugPrint('test  ' + data.data()!['Name']);
    UserName = data.data()!['Name'];
  }

  void register(String name, String email, password, bool isInstructor) async {
    try {
      var ref = usersCollection.add(User(
              name: name,
              password: password,
              email: email,
              isInstructor: isInstructor)
          .toMap());
      hiveStorage.then((value) => value.put('user', ref));
      hiveStorage.then(
          (value) => value.put('userType', isInstructor ? 'inst' : 'stu'));
      Get.snackbar('Login Successful', 'welcome  $name');
      Get.off(const MyHomePage());
    } catch (firebaseAuthException) {}
  }

  void login(String email, String password) async {
    try {
      if (email == "" || password == "") {
        Get.snackbar('Incomplete Data',
            'You should complete date before you try to login!');
      } else {
        User user;
        usersCollection
            .where('Email', isEqualTo: email)
            .where('Password', isEqualTo: password)
            .limit(1)
            .get()
            .then((value) async {
          if (value.docs.isEmpty) {
            Get.snackbar('Try again', 'wrong phone or password!');
          } else {
            user = User.fromSnapshot(value.docs.first);
            Get.snackbar('Login Successful', 'welcome  ${user.name ?? ''}');
            hiveStorage.then((value) => value.put('user', user.id!));
            hiveStorage.then((value) =>
                value.put('userType', user.isInstructor ? 'inst' : 'stu'));
            Get.off(const MyHomePage());
          }
        });
      }
    } catch (firebaseAuthException) {}
  }
}
