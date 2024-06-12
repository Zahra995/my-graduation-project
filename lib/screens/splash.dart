import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorials_library/Auth/controllers/auth_controller.dart';
import 'package:tutorials_library/Auth/ui/signin.dart';
import 'package:tutorials_library/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    timer = Timer(const Duration(seconds: 2), navigate);
    super.initState();
  }

  navigate() async {
    AuthController authController = AuthController.instance;
    authController.loadCurrent();
    String uID = authController.crrntUser;
    Get.off(() {
      if (uID == '') {
        return const Signin();
      } else {
        return const MyHomePage();
      }
    }, transition: Transition.fade, duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset('assets/images/aou.jpeg'),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'AOU library',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
