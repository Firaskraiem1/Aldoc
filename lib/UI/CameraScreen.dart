import 'dart:convert';
import 'dart:io';

import 'package:aldoc/UI/GenericForm.dart';
import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:aldoc/provider/filesProvider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Language _language = Language();
  // image croped Path (ronger)
  String? cropPath;
  bool? loginState;
  String? userId;
  String? taskId;
  String? token;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (value) {
        setState(() {
          loginState = value.getBool("loginState");
          userId = value.getString("userId");
          token = value.getString("token");
        });
      },
    );
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

  String? p;
  String? getResponse;
  Map<String, dynamic>? data;
  Map<String, dynamic>? data1;
  String? postResponse;
  String? extractResultResponse;
  @override
  Widget build(BuildContext context) {
    final camProv = Provider.of<cameraProvider>(context);
    final filesProv = Provider.of<filesProvider>(context);
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
                  toolbarTitle: _language.tCrop(),
                  toolbarColor: const Color(0xffF8FBFA),
                  toolbarWidgetColor: Colors.black,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
            ],
          );
          if (croppedFile != null &&
              (loginState == null || loginState == false)) {
            cropPath = croppedFile.path;
            if (cropPath != null) {
              List<int> imageBytes = await croppedFile.readAsBytes();
              camProv.setImagePath(croppedFile.path.toString());
              // post request //
              requestClass
                  .extractPostRequest(imageBytes, croppedFile.path.toString(),
                      camProv.getCurrentState())
                  .then(
                (value) async {
                  postResponse = requestClass.postResponseBody();
                  filesProv
                      .setResponseStatus(requestClass.postResponseStatus());
                  if (postResponse != null) {
                    data = await jsonDecode(postResponse!);
                    p = data!["Preprocessed_file_id"].toString();
                    requestClass.getImageRequest(p).whenComplete(
                      () {
                        getResponse = requestClass.getResponseBody();
                        if (getResponse != null &&
                            requestClass.postResponseStatus() != 500) {
                          camProv.setImagePath(getResponse!);
                          filesProv.setResponse(postResponse);
                          filesProv.setResponseState(true);
                        }
                      },
                    );
                  }
                },
              );
              camProv.removeAppBar(true);
            }
          } else if (croppedFile != null && loginState == true) {
            cropPath = croppedFile.path;
            if (cropPath != null) {
              List<int> imageBytes = await croppedFile.readAsBytes();
              camProv.setImagePath(croppedFile.path.toString());
              requestClass
                  .extractPostRequestConnectedUser(
                      imageBytes,
                      croppedFile.path.toString(),
                      userId,
                      camProv.getCurrentState(),
                      token)
                  .then(
                (value) async {
                  postResponse = requestClass.postConnectdResponseBody();
                  filesProv.setResponseStatus(
                      requestClass.postConnectedResponseStatus());
                  debugPrint(postResponse);
                  if (postResponse != null &&
                      requestClass.postConnectedResponseStatus() == 200) {
                    data = await jsonDecode(postResponse!);
                    var duration = const Duration(seconds: 15);

                    sleep(duration);
                    taskId = data!["task_id"].toString();
                    debugPrint("taskId:$taskId");
                    debugPrint("token :$token");
                    requestClass
                        .userConnectedExtractResult(taskId, token)
                        .whenComplete(
                      () async {
                        extractResultResponse =
                            requestClass.extractResultResponseBody();
                        if (extractResultResponse != null &&
                            requestClass.extractResultResponseStatus() == 200) {
                          data1 = await jsonDecode(extractResultResponse!);
                          p = data1!["document"]["Preprocessed_file_id"]
                              .toString();
                          requestClass
                              .getImageConnectedUserRequest(p, userId, token)
                              .whenComplete(
                            () {
                              getResponse = requestClass
                                  .getUserConnectedImageResponseBody();
                              if (getResponse != null &&
                                  requestClass.postConnectedResponseStatus() !=
                                      500) {
                                camProv.setImagePath(getResponse!);
                                filesProv.setResponse(extractResultResponse);
                                filesProv.setResponseState(true);
                                filesProv.setResponseStatus(
                                    requestClass.postConnectedResponseStatus());

                                debugPrint(
                                    "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                              }
                            },
                          );
                        }
                      },
                    );
                  } else if (requestClass.postConnectedResponseStatus() ==
                      401) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  }
                },
              );
              camProv.removeAppBar(true);
            }
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
                  toolbarTitle: _language.tCrop(),
                  toolbarColor: const Color(0xffF8FBFA),
                  toolbarWidgetColor: Colors.black,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
            ],
          );
          if (croppedFile != null &&
              (loginState == null || loginState == false)) {
            cropPath = croppedFile.path;
            if (cropPath != null) {
              List<int> imageBytes = await croppedFile.readAsBytes();
              camProv.setImagePath(croppedFile.path.toString());
              // post request //
              requestClass
                  .extractPostRequest(imageBytes, croppedFile.path.toString(),
                      camProv.getCurrentState())
                  .then(
                (value) async {
                  postResponse = requestClass.postResponseBody();
                  filesProv
                      .setResponseStatus(requestClass.postResponseStatus());
                  if (postResponse != null) {
                    data = await jsonDecode(postResponse!);
                    p = data!["Preprocessed_file_id"].toString();
                    requestClass.getImageRequest(p).whenComplete(
                      () {
                        getResponse = requestClass.getResponseBody();
                        if (getResponse != null &&
                            requestClass.postResponseStatus() != 500) {
                          camProv.setImagePath(getResponse!);
                          filesProv.setResponse(postResponse);
                          filesProv.setResponseState(true);
                          debugPrint(
                              "${camProv.getPathImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                        }
                      },
                    );
                  }
                },
              );
              camProv.removeAppBar(true);
            }
          } else if (croppedFile != null && loginState == true) {
            cropPath = croppedFile.path;
            if (cropPath != null) {
              List<int> imageBytes = await croppedFile.readAsBytes();
              camProv.setImagePath(croppedFile.path.toString());
              requestClass
                  .extractPostRequestConnectedUser(
                      imageBytes,
                      croppedFile.path.toString(),
                      userId,
                      camProv.getCurrentState(),
                      token)
                  .then(
                (value) async {
                  postResponse = requestClass.postConnectdResponseBody();
                  filesProv.setResponseStatus(
                      requestClass.postConnectedResponseStatus());
                  debugPrint(postResponse);
                  if (postResponse != null &&
                      requestClass.postConnectedResponseStatus() == 200) {
                    data = await jsonDecode(postResponse!);
                    var duration = const Duration(seconds: 15);

                    sleep(duration);
                    taskId = data!["task_id"].toString();
                    debugPrint("taskId:$taskId");
                    debugPrint("token :$token");
                    requestClass
                        .userConnectedExtractResult(taskId, token)
                        .whenComplete(
                      () async {
                        extractResultResponse =
                            requestClass.extractResultResponseBody();
                        if (extractResultResponse != null &&
                            requestClass.extractResultResponseStatus() == 200) {
                          data1 = await jsonDecode(extractResultResponse!);
                          p = data1!["document"]["Preprocessed_file_id"]
                              .toString();
                          requestClass
                              .getImageConnectedUserRequest(p, userId, token)
                              .whenComplete(
                            () {
                              getResponse = requestClass
                                  .getUserConnectedImageResponseBody();
                              if (getResponse != null &&
                                  requestClass.postConnectedResponseStatus() !=
                                      500) {
                                camProv.setImagePath(getResponse!);
                                filesProv.setResponse(extractResultResponse);
                                filesProv.setResponseState(true);
                                filesProv.setResponseStatus(
                                    requestClass.postConnectedResponseStatus());

                                debugPrint(
                                    "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                              }
                            },
                          );
                        }
                      },
                    );
                  } else if (requestClass.postConnectedResponseStatus() ==
                      401) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  }
                },
              );
              camProv.removeAppBar(true);
            }
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
                height: 280,
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
