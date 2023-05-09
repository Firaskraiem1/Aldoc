// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:io';

import 'package:aldoc/UI/GenericForm.dart';
import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  RequestClass requestClass = RequestClass();
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
    return Scaffold(
      backgroundColor: const Color(0xffF8FBFA),
      body: body(),
    );
  }

  ///////////////// fin /////////////////
  Widget body() {
    final camProv = Provider.of<cameraProvider>(context, listen: false);
    if (camProv.getGenericState() == true) {
      return const GenericForm();
    }
    return Center(
      child: Stack(
        children: [
          const Positioned(
              top: 100,
              left: 100,
              right: 100,
              bottom: 200,
              child: RiveAnimation.asset("assets/uploadbuttonanimation.riv")),
          Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: LoadingAnimationWidget.discreteCircle(
                        secondRingColor: const Color(0xff41B072),
                        thirdRingColor: const Color(0xff41B072),
                        color: const Color(0xff41B072),
                        size: 180),
                    // child: CircularProgressIndicator(
                    //   color: Color(0xff41B072),
                    //   backgroundColor: Color(0xff151719),
                    //   strokeWidth: 20,
                    // ),
                  ),
                  const Text(
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
              onTap: () async {
                var connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.mobile ||
                    connectivityResult == ConnectivityResult.wifi) {
                  openFiles();
                  setState(() {
                    camProv.setCurrentState("uploadFile");
                  });
                } else {
                  Fluttertoast.showToast(
                      msg: "Failed to connect to host",
                      backgroundColor: Colors.grey);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

// method to choose file
  Future<void> openFiles() async {
    final camProv = Provider.of<cameraProvider>(context, listen: false);
    try {
      FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["png", "pdf", "tiff", "jpeg"]);
      if (resultFile != null) {
        ///////////////////////
        // setState(() {
        //   fileSelected = true;
        //   camProv.setGenericState(true);
        // });
        ///////////////////////
        file = resultFile.files.first;
        upload_file = File(file!.path.toString());
        if (upload_file!.path.split(".").last == 'pdf') {
          camProv.setUploadPath(upload_file!.path.toString());
          // post request
          requestClass.postRequestIdDocument(upload_file!.path.toString(), "");
          setState(() {
            camProv.setGenericState(true);
          });
        } else {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: upload_file!.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            uiSettings: [
              AndroidUiSettings(
                  activeControlsWidgetColor: const Color(0xff41B072),
                  backgroundColor: const Color(0xffF8FBFA),
                  toolbarTitle: 'Cropper',
                  toolbarColor: const Color(0xffF8FBFA),
                  toolbarWidgetColor: Colors.black,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
            ],
          );
          if (croppedFile != null) {
            camProv.setUploadPath(croppedFile.path.toString());
            // post request
            requestClass.postRequestIdDocument(croppedFile.path.toString(), "");
            setState(() {
              camProv.setGenericState(true);
            });
          } else {
            setState(() {
              camProv.setGenericState(false);
              camProv.removeAppBar(false);
            });
          }
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }
}
