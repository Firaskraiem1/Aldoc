import 'dart:io';
import 'package:aldoc/UI/GenericForm.dart';
import 'package:aldoc/UI/Home.dart';
import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  XFile? image;
  RequestClass requestClass = RequestClass();
  // image croped Path (ronger)
  String? cropPath;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    initCamera().then((value) {
      startCamera(0);
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    // orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future initCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  void startCamera(int index) async {
    cameraController = CameraController(
      cameras![index],
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );

    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  bool _isCaptureInProgress = false;
  Future<void> captureImage() async {
    if (_isCaptureInProgress) {
      return;
    }
    try {
      _isCaptureInProgress = true;
      image = await cameraController!.takePicture();
      setState(() {});
      _isCaptureInProgress = false;
    } on CameraException catch (e) {
      print('Erreur de capture : ${e.description}');
    }
  }

  Future<void> setFlashOn() async {
    await cameraController?.setFlashMode(FlashMode.torch);
  }

  Future<void> setFlashoff() async {
    await cameraController?.setFlashMode(FlashMode.off);
  }

  @override
  Widget build(BuildContext context) {
    final camProv = Provider.of<cameraProvider>(context);
    bool stateCamera = camProv.getCameraState();
    bool stateFlash = camProv.getFlashState();
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const SizedBox(
        child: Text(""),
      );
    } else if (stateCamera == true) {
      captureImage().whenComplete(() async {
        camProv.cameraState(false);
        if (stateFlash == true) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {
                camProv.flashState(false);
              });
            },
          );
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: image!.path,
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
            cropPath = croppedFile.path;
            camProv.setImagePath(croppedFile.path.toString());
            // post request //
            requestClass.postRequestIdDocument(
                croppedFile.path.toString(), camProv.getCurrentState());
            camProv.removeAppBar(true);
          } else {
            camProv.setGenericState(false);
          }
        } else {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: image!.path,
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
            cropPath = croppedFile.path;
            camProv.setImagePath(croppedFile.path.toString());
            // post request //
            requestClass.postRequestIdDocument(
                croppedFile.path.toString(), camProv.getCurrentState());
            camProv.removeAppBar(true);
          } else {
            camProv.setGenericState(false);
          }
        }
      }).then((value) {});
    } else if (stateFlash == true) {
      setFlashOn();
    } else if (stateFlash == false) {
      setFlashoff();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: body()),
    );
  }

  Widget? body() {
    final camProv = Provider.of<cameraProvider>(context);
    String? imagePath = camProv.getPathImage();
    bool invoiceState = camProv.getInvoiceCamera();
    bool passportState = camProv.getPassportCamera();
    if (cropPath == null && invoiceState == false && passportState == false) {
      return Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(cameraController!)),
        Center(
          child: Container(
              width: 300,
              height: 230,
              color: const Color.fromARGB(52, 253, 224, 224),
              child: Stack(
                children: [
                  const RiveAnimation.asset("assets/scan.riv"),
                  // Coin supérieur gauche
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 30.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 4.0, color: Colors.white),
                          left: BorderSide(width: 4.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Coin supérieur droit
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 30.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 4.0, color: Colors.white),
                          right: BorderSide(width: 4.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Coin inférieur gauche
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 30.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 4.0, color: Colors.white),
                          left: BorderSide(width: 4.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Coin inférieur droit
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 30.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 4.0, color: Colors.white),
                          right: BorderSide(width: 4.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ]);
    } else if (imagePath == "" &&
        invoiceState == false &&
        passportState == false) {
      cropPath = null;
      return null;
    } else if (imagePath == "" &&
        invoiceState == true &&
        passportState == false) {
      return Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(cameraController!)),
      ]);
    } else if (imagePath == "" &&
        passportState == true &&
        invoiceState == false) {
      return Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(cameraController!)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Container(
                width: 400,
                height: 400,
                color: const Color.fromARGB(52, 253, 224, 224),
                child: Stack(
                  children: [
                    const RiveAnimation.asset("assets/scan.riv"),
                    // Coin supérieur gauche
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 30.0,
                        height: 20.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 4.0, color: Colors.white),
                            left: BorderSide(width: 4.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // Coin supérieur droit
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 30.0,
                        height: 20.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 4.0, color: Colors.white),
                            right: BorderSide(width: 4.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // Coin inférieur gauche
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 30.0,
                        height: 20.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 4.0, color: Colors.white),
                            left: BorderSide(width: 4.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // Coin inférieur droit
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 30.0,
                        height: 20.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 4.0, color: Colors.white),
                            right: BorderSide(width: 4.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ]);
    }
    return const GenericForm();
  }
}
