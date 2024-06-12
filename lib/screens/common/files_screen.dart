import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart' as getx;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorials_library/Auth/controllers/auth_controller.dart';
import 'package:tutorials_library/Auth/ui/signin.dart';
import 'package:tutorials_library/components/utils/constants.dart';
import 'package:tutorials_library/models/uploaded_file.dart';
import 'package:tutorials_library/screens/instructor/upload_screen.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({Key? key, required this.category}) : super(key: key);
  final int category;
  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  late Future<List<UploadedFile>> files;
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    setState(() {
      debugPrint('init');
      files = _getFiles();
    });
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AuthController authController = AuthController.instance;
    authController.loadCurrentType();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
        actions: [
          GestureDetector(
            child: const Icon(
              Icons.logout,
              color: Color.fromRGBO(195, 95, 30, 1),
            ),
            onTap: () {
              hiveStorage.then((value) => value.put('user', ''));
              hiveStorage.then((value) => value.put('userType', ''));
              getx.Get.offAll(const Signin());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UploadedFile>>(
        future: files,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: authController.crrntUserType == 'inst'
                            ? [
                                Expanded(
                                  flex: 9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(snapshot.data![i].title ?? ''),
                                          Text(
                                              ' ,by: ${snapshot.data![i].instructorName ?? ''}'),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'File Name: ' + snapshot.data![i].name,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Notes: ' +
                                          (snapshot.data![i].description ??
                                              '')),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            : [
                                Expanded(
                                  flex: 9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(snapshot.data![i].title ?? ''),
                                          Text(
                                              ' ,by: ${snapshot.data![i].instructorName ?? ''}'),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'File Name: ' + snapshot.data![i].name,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Notes: ' +
                                          (snapshot.data![i].description ??
                                              '')),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: const Icon(
                                      Icons.download_sharp,
                                      color: Color.fromRGBO(29, 95, 194, 1),
                                    ),
                                    onTap: () {
                                      downloadFile(
                                          snapshot.data![i].downloadURL,
                                          snapshot.data![i].name);
                                    },
                                  ),
                                ),
                              ],
                      ),
                    ),
                  );
                });
          }
          if (snapshot.hasError) {
            return const Text('Error has happened fetching data');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading ...');
          }
          return SizedBox();
        },
      ),
      // ignore: unrelated_type_equality_checks
      floatingActionButton: AuthController.instance.crrntUserType == 'inst'
          ? DraggableFab(
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(29, 95, 194, 1),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: SizedBox(
                        height: size.height * 0.6,
                        child: UploadScreen(
                          category: widget.category,
                        ),
                      ),
                    ),
                  );
                },
                tooltip: 'Increment',
                child: const Icon(Icons.cloud_upload),
              ),
            )
          : null,
    );
  }

  Future<List<UploadedFile>> _getFiles() async {
    List<UploadedFile> _files = [];
    filesCollection
        .where('category', isEqualTo: widget.category)
        .get()
        .then((value) => value.docs.forEach((element) {
              setState(() {
                _files.add(UploadedFile.fromSnapshot(element));
              });
              debugPrint(element.toString());
            }));
    return _files;
    //return filesCollection.snapshots().map((event) => null)
  }

  void downloadFile(String url, String fileName) async {
    await Permission.storage.request();
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + Platform.pathSeparator + 'files';
    //String filePath = path + Platform.pathSeparator + fileName;
    //await FlutterDownloader.initialize();
    final savedDir = Directory(path);
    bool hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
    await FlutterDownloader.enqueue(url: url, savedDir: path);
    getx.Get.snackbar('Done', 'Download Completed\nFile path: $fileName',
        showProgressIndicator: true, titleText: Text('Downloading $fileName'));
    //startDownload(Dio(), url, filePath);
  }

  /*Future startDownload(Dio dio, String url, String filePath) async {
    try {
      Response response = await dio.get(url,
          //onReceiveProgress: showDownloadProgress,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) => status! < 500));
      File file = File(filePath);
      var ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();
      getx.Get.snackbar('Done', 'Download Completed\nFile path: $filePath');
    } catch (e) {
      debugPrint(e.toString());
    }
  }*/

/*  void showDownloadProgress(int count, int total) {
    if (total != -1) {}
  }*/
}
