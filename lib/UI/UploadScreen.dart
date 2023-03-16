import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? file;
  File? upload_file;
  bool fileSelected = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

/////////////////// build //////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151719),
      body: fileSelected
          ? uploadWidget()
          : Center(
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        backgroundColor: Color(0xff151719),
                        strokeWidth: 20,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 100,
                      left: 100,
                      right: 100,
                      bottom: 100,
                      child: IconButton(
                          splashRadius: 1.0,
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              openFiles();
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_upward,
                            size: 120,
                          ))),
                  Positioned(
                    top: 400,
                    left: 50,
                    right: 50,
                    bottom: 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "Click to browse for image xd",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Text("(Allowed :PDF, TIFF, JPEG, PNG)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
  ///////////////// fin /////////////////

  // method to choose file
  void openFiles() async {
    try {
      FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["png", "pdf", "tiff", "jpeg"]);
      if (resultFile != null) {
        ////////////////////////
        setState(() {
          fileSelected = true;
        });
        ///////////////////////
        file = resultFile.files.first;
        upload_file = File(file!.path.toString());
      } else {}
    } catch (e) {
      print(e);
    }
  }

  //fin
//////////****  widget upload ******* /////////////
  Widget? uploadWidget() {
    if (file != null) {
      return Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: Image.file(upload_file!),
        ),
      );
    }
    return null;
  }
}
