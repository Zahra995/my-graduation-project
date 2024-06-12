import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tutorials_library/Auth/controllers/auth_controller.dart';
import 'package:tutorials_library/Auth/ui/signin.dart';
import 'package:tutorials_library/components/utils/constants.dart';
import 'package:tutorials_library/models/category.dart';
import 'package:tutorials_library/models/uploaded_file.dart';
import 'package:tutorials_library/screens/common/category_item.dart';
import 'package:tutorials_library/screens/instructor/upload_screen.dart';
import 'package:tutorials_library/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await FlutterDownloader.initialize(debug: true);
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.instance;
    authController.loadCurrent();
    String uID = authController.crrntUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const SplashScreen() /*uID == '' ? const Signin() : const MyHomePage()*/,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<UploadedFile>> files;
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AOU library'),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.logout,
                color: Color.fromRGBO(195, 95, 30, 1),
              ),
            ),
            onTap: () {
              hiveStorage.then((value) => value.put('user', ''));
              hiveStorage.then((value) => value.put('userType', ''));
              Get.offAll(const Signin());
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const ListTile(
            title: Text('Choose your Specialization:'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) => CategoryItem(
                data[index],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //

}
