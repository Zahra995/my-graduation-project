import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tutorials_library/api/firebase_api.dart';
import 'package:tutorials_library/components/utils/constants.dart';
import 'package:tutorials_library/components/widgets/custom_formfield.dart';
import 'package:tutorials_library/models/uploaded_file.dart';
import 'package:tutorials_library/widget/custom_button.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key, required this.category}) : super(key: key);
  final int category;
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _desc = TextEditingController();
  String get desc => _desc.text.trim();
  final _title = TextEditingController();
  String get title => _title.text.trim();
  UploadTask? task;
  File? file;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No file selected';
    return SizedBox(
      child: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ButtonWidget(
              text: 'Select File',
              icon: Icons.attach_file,
              onClicked: selectFile,
            ), // ButtonWidget
            const SizedBox(height: 8),
            Text(fileName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30), // Text
            CustomFormField(
              headingText: "Title",
              hintText: "Title",
              obsecureText: false,
              suffixIcon: const SizedBox(),
              maxLines: 1,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              controller: _title,
            ),
            CustomFormField(
              headingText: "Description",
              hintText: "Description",
              obsecureText: false,
              suffixIcon: const SizedBox(),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              controller: _desc,
            ),
            const SizedBox(height: 48),
            ButtonWidget(
              text: 'Upload File',
              icon: Icons.cloud_upload_outlined,
              onClicked: uploadFile,
            ),
            const SizedBox(height: 20),
            task != null ? buildUploadStatus(task!) : Container(),
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future uploadFile() async {
    try {
      if (file == null) return;
      final fileName = basename(file!.path);
      final destination = 'files/$fileName';
      task = FirebaseApi.uploadFile(destination, file!);
      setState(() {});
      if (task == null) return;
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      filesCollection.add(UploadedFile(
        title: title,
        name: fileName,
        downloadURL: urlDownload,
        instructorID: await hiveStorage.then((value) => value.get('user')),
        description: desc,
        category: widget.category,
      ).toMap());
    } on FirebaseException catch (ex) {
      Get.snackbar('Error', ex.message ?? 'No Certain Message');
    }
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            return Text('${(progress * 100).toStringAsFixed(1)} %');
          } else {
            return Container();
          }
        },
      );
}
