// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:aldoc/UI/GenericForm.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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
      DeviceOrientation.portraitUp,
    ]);
  }

/////////////////// build //////////////////
  @override
  Widget build(BuildContext context) {
    final camProv = Provider.of<cameraProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffF8FBFA),
      body: fileSelected
          ? const GenericForm()
          : Center(
              child: Stack(
                children: [
                  const Positioned(
                      top: 100,
                      left: 100,
                      right: 100,
                      bottom: 200,
                      child: RiveAnimation.asset(
                          "assets/uploadbuttonanimation.riv")),
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              color: Color(0xff41B072),
                              backgroundColor: Color(0xff151719),
                              strokeWidth: 20,
                            ),
                          ),
                          Text(
                            "  \n\n  click to browse for image xd \n(Allowed :PDF, TIFF, JPEG, PNG)",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                    top: 100,
                    left: 100,
                    right: 100,
                    bottom: 200,
                    child: GestureDetector(
                      onTap: () {
                        openFiles();
                        setState(() {
                          camProv.setCurrentState("uploadFile");
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  ///////////////// fin /////////////////

  // method to choose file
  Future<void> openFiles() async {
    final camProv = Provider.of<cameraProvider>(context, listen: false);
    try {
      FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["png", "pdf", "tiff", "jpeg"]);
      if (resultFile != null) {
        ///////////////////////
        setState(() {
          fileSelected = true;
        });
        ///////////////////////
        file = resultFile.files.first;
        upload_file = File(file!.path.toString());
        camProv.setUploadPath(upload_file!.path);
      } else {}
    } catch (e) {
      print(e);
    }
  }
}
