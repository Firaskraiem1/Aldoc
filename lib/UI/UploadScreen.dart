// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:aldoc/UI/GenericForm.dart';
import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:aldoc/provider/filesProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Language _language = Language();
  bool? loginState;
  String? userId;
  String? taskId;
  String? token;
  @override
  void initState() {
    super.initState();
    setState(
      () => _language.getLanguage(),
    );
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

  bool idCardSelected = false;
  bool businessCardSelected = false;
  bool passportSelected = false;
  bool invoiceSelected = false;
  String? fileUplodedPath;

  String? p;
  String? getResponse;
  Map<String, dynamic>? data;
  Map<String, dynamic>? data1;
  String? postResponse;
  String? extractResultResponse;
  ///////////////// fin /////////////////
  Widget body() {
    final camProv = Provider.of<cameraProvider>(context);
    final filesProv = Provider.of<filesProvider>(context);
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
                  Text(
                    _language.tUploadText(),
                    style: const TextStyle(
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
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AlertDialog(
                        backgroundColor: const Color(0xffF3F3F3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _language.tUploadChooseTypeFile(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormField(
                                    builder: (state) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (passportSelected ||
                                                  businessCardSelected ||
                                                  invoiceSelected) {
                                                state.didChange(false);
                                              } else {
                                                idCardSelected =
                                                    !idCardSelected;
                                                state.didChange(idCardSelected);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: idCardSelected
                                                  ? const Border(
                                                      bottom: BorderSide(
                                                          color: Color(
                                                              0xff41B072)),
                                                      top: BorderSide(
                                                          color: Color(
                                                              0xff41B072)),
                                                      left: BorderSide(
                                                          color: Color(
                                                              0xff41B072)),
                                                      right: BorderSide(
                                                          color: Color(
                                                              0xff41B072)))
                                                  : null,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10)),
                                              color: const Color(0xffFFFFFF),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(_language
                                                    .tHomeFilterIdDocument())
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  FormField(
                                    builder: (state) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (idCardSelected ||
                                                  businessCardSelected ||
                                                  invoiceSelected) {
                                                state.didChange(false);
                                              } else {
                                                passportSelected =
                                                    !passportSelected;
                                                state.didChange(
                                                    passportSelected);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: passportSelected
                                                    ? const Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        top: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        left: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        right: BorderSide(
                                                            color: Color(
                                                                0xff41B072)))
                                                    : null,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10)),
                                                color: const Color(0xffFFFFFF)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(_language
                                                    .tHomeFilterPassport())
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  FormField(
                                    builder: (state) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (passportSelected ||
                                                  idCardSelected ||
                                                  invoiceSelected) {
                                                state.didChange(false);
                                              } else {
                                                businessCardSelected =
                                                    !businessCardSelected;
                                                state.didChange(
                                                    businessCardSelected);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: businessCardSelected
                                                    ? const Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        top: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        left: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        right: BorderSide(
                                                            color: Color(
                                                                0xff41B072)))
                                                    : null,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10)),
                                                color: const Color(0xffFFFFFF)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(_language
                                                    .tHomeFilterBusinessCard())
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  FormField(
                                    builder: (state) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (passportSelected ||
                                                  idCardSelected ||
                                                  businessCardSelected) {
                                                state.didChange(false);
                                              } else {
                                                invoiceSelected =
                                                    !invoiceSelected;
                                                state
                                                    .didChange(invoiceSelected);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: invoiceSelected
                                                    ? const Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        top: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        left: BorderSide(
                                                            color: Color(
                                                                0xff41B072)),
                                                        right: BorderSide(
                                                            color: Color(
                                                                0xff41B072)))
                                                    : null,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10)),
                                                color: const Color(0xffFFFFFF)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(_language
                                                    .tHomeFilterInvoice())
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 38, bottom: 15),
                                child: Container(
                                  width: 80,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Color(0xffFFFFFF)),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        _language.tProfilButtonCancel(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 17, left: 40, bottom: 15),
                                child: Container(
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Color(0xff41B072)),
                                  child: TextButton(
                                      onPressed: () async {
                                        filesProv.setResponse("");
                                        filesProv.setResponseState(false);
                                        var connectivityResult =
                                            await Connectivity()
                                                .checkConnectivity();
                                        if (connectivityResult ==
                                                ConnectivityResult.mobile ||
                                            connectivityResult ==
                                                ConnectivityResult.wifi) {
                                          if (idCardSelected == true ||
                                              businessCardSelected == true ||
                                              invoiceSelected == true ||
                                              passportSelected == true) {
                                            Navigator.pop(context);
                                            openFiles().whenComplete(
                                              () async {
                                                if (upload_file != null) {
                                                  CroppedFile? croppedFile =
                                                      await ImageCropper()
                                                          .cropImage(
                                                    sourcePath:
                                                        upload_file!.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .square,
                                                      CropAspectRatioPreset
                                                          .ratio3x2,
                                                      CropAspectRatioPreset
                                                          .original,
                                                      CropAspectRatioPreset
                                                          .ratio4x3,
                                                      CropAspectRatioPreset
                                                          .ratio16x9
                                                    ],
                                                    uiSettings: [
                                                      AndroidUiSettings(
                                                          activeControlsWidgetColor:
                                                              const Color(
                                                                  0xff41B072),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffF8FBFA),
                                                          toolbarTitle:
                                                              _language.tCrop(),
                                                          toolbarColor:
                                                              const Color(
                                                                  0xffF8FBFA),
                                                          toolbarWidgetColor:
                                                              Colors.black,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .original,
                                                          lockAspectRatio:
                                                              false),
                                                    ],
                                                  );
                                                  if (croppedFile != null &&
                                                      (loginState == false ||
                                                          loginState == null)) {
                                                    List<int> imageBytes =
                                                        await croppedFile
                                                            .readAsBytes();
                                                    camProv.setUploadPath(
                                                        croppedFile.path
                                                            .toString());
                                                    // post request //
                                                    if (idCardSelected) {
                                                      requestClass
                                                          .extractPostRequest(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              "idDocument")
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                              null) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            p = data![
                                                                    "Preprocessed_file_id"]
                                                                .toString();
                                                            requestClass
                                                                .getImageRequest(
                                                                    p)
                                                                .whenComplete(
                                                              () {
                                                                getResponse =
                                                                    requestClass
                                                                        .getResponseBody();
                                                                if (getResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .postResponseStatus() !=
                                                                        500) {
                                                                  camProv.setUploadPath(
                                                                      getResponse!);
                                                                  filesProv
                                                                      .setResponse(
                                                                          postResponse);
                                                                  filesProv
                                                                      .setResponseState(
                                                                          true);
                                                                  filesProv.setResponseStatus(
                                                                      requestClass
                                                                          .postResponseStatus());
                                                                  setState(() {
                                                                    businessCardSelected =
                                                                        idCardSelected =
                                                                            invoiceSelected =
                                                                                passportSelected = false;
                                                                  });
                                                                  debugPrint(
                                                                      "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                }
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    } else if (passportSelected) {
                                                      requestClass
                                                          .extractPostRequest(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              "passport")
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                              null) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            p = data![
                                                                    "Preprocessed_file_id"]
                                                                .toString();
                                                            requestClass
                                                                .getImageRequest(
                                                                    p)
                                                                .whenComplete(
                                                              () {
                                                                getResponse =
                                                                    requestClass
                                                                        .getResponseBody();
                                                                if (getResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .postResponseStatus() !=
                                                                        500) {
                                                                  camProv.setUploadPath(
                                                                      getResponse!);
                                                                  filesProv
                                                                      .setResponse(
                                                                          postResponse);
                                                                  filesProv
                                                                      .setResponseState(
                                                                          true);
                                                                  filesProv.setResponseStatus(
                                                                      requestClass
                                                                          .postResponseStatus());
                                                                  setState(() {
                                                                    businessCardSelected =
                                                                        idCardSelected =
                                                                            invoiceSelected =
                                                                                passportSelected = false;
                                                                  });
                                                                  debugPrint(
                                                                      "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                }
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    } else if (businessCardSelected) {
                                                      requestClass
                                                          .extractPostRequest(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              "businessCard")
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                              null) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            p = data![
                                                                    "Preprocessed_file_id"]
                                                                .toString();
                                                            requestClass
                                                                .getImageRequest(
                                                                    p)
                                                                .whenComplete(
                                                              () {
                                                                getResponse =
                                                                    requestClass
                                                                        .getResponseBody();
                                                                if (getResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .postResponseStatus() !=
                                                                        500) {
                                                                  camProv.setUploadPath(
                                                                      getResponse!);
                                                                  filesProv
                                                                      .setResponse(
                                                                          postResponse);
                                                                  filesProv
                                                                      .setResponseState(
                                                                          true);
                                                                  filesProv.setResponseStatus(
                                                                      requestClass
                                                                          .postResponseStatus());
                                                                  setState(() {
                                                                    businessCardSelected =
                                                                        idCardSelected =
                                                                            invoiceSelected =
                                                                                passportSelected = false;
                                                                  });
                                                                  debugPrint(
                                                                      "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                }
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    } else {
                                                      requestClass
                                                          .extractPostRequest(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              "invoice")
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                              null) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            p = data![
                                                                    "Preprocessed_file_id"]
                                                                .toString();
                                                            requestClass
                                                                .getImageRequest(
                                                                    p)
                                                                .whenComplete(
                                                              () {
                                                                getResponse =
                                                                    requestClass
                                                                        .getResponseBody();
                                                                if (getResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .postResponseStatus() !=
                                                                        500) {
                                                                  camProv.setUploadPath(
                                                                      getResponse!);
                                                                  filesProv
                                                                      .setResponse(
                                                                          postResponse);
                                                                  filesProv
                                                                      .setResponseState(
                                                                          true);
                                                                  filesProv.setResponseStatus(
                                                                      requestClass
                                                                          .postResponseStatus());
                                                                  setState(() {
                                                                    businessCardSelected =
                                                                        idCardSelected =
                                                                            invoiceSelected =
                                                                                passportSelected = false;
                                                                  });
                                                                  debugPrint(
                                                                      "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                }
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    }
                                                    debugPrint(
                                                        "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");

                                                    setState(() {
                                                      camProv
                                                          .removeAppBar(true);
                                                      camProv.setGenericState(
                                                          true);
                                                    });
                                                  } else if (croppedFile !=
                                                          null &&
                                                      loginState == true) {
                                                    List<int> imageBytes =
                                                        await croppedFile
                                                            .readAsBytes();
                                                    camProv.setUploadPath(
                                                        croppedFile.path
                                                            .toString());
                                                    // post request //
                                                    if (idCardSelected) {
                                                      debugPrint(
                                                          "UserID: $userId");
                                                      requestClass
                                                          .extractPostRequestConnectedUser(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              userId,
                                                              "idDocument",
                                                              token)
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postConnectdResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postConnectedResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                                  null &&
                                                              requestClass
                                                                      .postConnectedResponseStatus() ==
                                                                  200) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            var duration =
                                                                const Duration(
                                                                    seconds:
                                                                        15);

                                                            sleep(duration);
                                                            taskId =
                                                                data!["task_id"]
                                                                    .toString();
                                                            debugPrint(
                                                                "taskId:$taskId");

                                                            debugPrint(
                                                                "token :$token");

                                                            requestClass
                                                                .userConnectedExtractResult(
                                                                    taskId,
                                                                    token)
                                                                .whenComplete(
                                                              () async {
                                                                extractResultResponse =
                                                                    requestClass
                                                                        .extractResultResponseBody();
                                                                if (extractResultResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .extractResultResponseStatus() ==
                                                                        200) {
                                                                  data1 = await jsonDecode(
                                                                      extractResultResponse!);
                                                                  p = data1!["document"]
                                                                          [
                                                                          "Preprocessed_file_id"]
                                                                      .toString();
                                                                  requestClass
                                                                      .getImageConnectedUserRequest(
                                                                          p,
                                                                          userId,
                                                                          token)
                                                                      .whenComplete(
                                                                    () {
                                                                      getResponse =
                                                                          requestClass
                                                                              .getUserConnectedImageResponseBody();
                                                                      if (getResponse !=
                                                                              null &&
                                                                          requestClass.postConnectedResponseStatus() !=
                                                                              500) {
                                                                        camProv.setUploadPath(
                                                                            getResponse!);
                                                                        filesProv
                                                                            .setResponse(extractResultResponse);
                                                                        filesProv
                                                                            .setResponseState(true);
                                                                        filesProv
                                                                            .setResponseStatus(requestClass.postConnectedResponseStatus());
                                                                        setState(
                                                                            () {
                                                                          businessCardSelected =
                                                                              idCardSelected = invoiceSelected = passportSelected = false;
                                                                        });
                                                                        debugPrint(
                                                                            "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          } else if (requestClass
                                                                  .postConnectedResponseStatus() ==
                                                              401) {
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const LoginPage(),
                                                                    ));
                                                          }
                                                        },
                                                      );
                                                    } else if (passportSelected) {
                                                      requestClass
                                                          .extractPostRequestConnectedUser(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              userId,
                                                              "passport",
                                                              token)
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postConnectdResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postConnectedResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                                  null &&
                                                              requestClass
                                                                      .postConnectedResponseStatus() ==
                                                                  200) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            var duration =
                                                                const Duration(
                                                                    seconds:
                                                                        15);

                                                            sleep(duration);
                                                            taskId =
                                                                data!["task_id"]
                                                                    .toString();
                                                            requestClass
                                                                .userConnectedExtractResult(
                                                                    taskId,
                                                                    token)
                                                                .whenComplete(
                                                              () async {
                                                                extractResultResponse =
                                                                    requestClass
                                                                        .extractResultResponseBody();
                                                                if (extractResultResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .extractResultResponseStatus() ==
                                                                        200) {
                                                                  data1 = await jsonDecode(
                                                                      extractResultResponse!);
                                                                  p = data1!["document"]
                                                                          [
                                                                          "Preprocessed_file_id"]
                                                                      .toString();
                                                                  requestClass
                                                                      .getImageConnectedUserRequest(
                                                                          p,
                                                                          userId,
                                                                          token)
                                                                      .whenComplete(
                                                                    () {
                                                                      getResponse =
                                                                          requestClass
                                                                              .getUserConnectedImageResponseBody();
                                                                      if (getResponse !=
                                                                              null &&
                                                                          requestClass.postConnectedResponseStatus() !=
                                                                              500) {
                                                                        camProv.setUploadPath(
                                                                            getResponse!);
                                                                        filesProv
                                                                            .setResponse(extractResultResponse);
                                                                        filesProv
                                                                            .setResponseState(true);
                                                                        filesProv
                                                                            .setResponseStatus(requestClass.postConnectedResponseStatus());
                                                                        setState(
                                                                            () {
                                                                          businessCardSelected =
                                                                              idCardSelected = invoiceSelected = passportSelected = false;
                                                                        });
                                                                        debugPrint(
                                                                            "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          } else if (requestClass
                                                                  .postConnectedResponseStatus() ==
                                                              401) {
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const LoginPage(),
                                                                    ));
                                                          }
                                                        },
                                                      );
                                                    } else if (businessCardSelected) {
                                                      requestClass
                                                          .extractPostRequestConnectedUser(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              userId,
                                                              "businessCard",
                                                              token)
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postConnectdResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postConnectedResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                                  null &&
                                                              requestClass
                                                                      .postConnectedResponseStatus() ==
                                                                  200) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            var duration =
                                                                const Duration(
                                                                    seconds:
                                                                        15);
                                                            sleep(duration);
                                                            taskId =
                                                                data!["task_id"]
                                                                    .toString();
                                                            requestClass
                                                                .userConnectedExtractResult(
                                                                    taskId,
                                                                    token)
                                                                .whenComplete(
                                                              () async {
                                                                extractResultResponse =
                                                                    requestClass
                                                                        .extractResultResponseBody();
                                                                if (extractResultResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .extractResultResponseStatus() ==
                                                                        200) {
                                                                  data1 = await jsonDecode(
                                                                      extractResultResponse!);
                                                                  p = data1!["document"]
                                                                          [
                                                                          "Preprocessed_file_id"]
                                                                      .toString();
                                                                  requestClass
                                                                      .getImageConnectedUserRequest(
                                                                          p,
                                                                          userId,
                                                                          token)
                                                                      .whenComplete(
                                                                    () {
                                                                      getResponse =
                                                                          requestClass
                                                                              .getUserConnectedImageResponseBody();
                                                                      if (getResponse !=
                                                                              null &&
                                                                          requestClass.postConnectedResponseStatus() !=
                                                                              500) {
                                                                        camProv.setUploadPath(
                                                                            getResponse!);
                                                                        filesProv
                                                                            .setResponse(extractResultResponse);
                                                                        filesProv
                                                                            .setResponseState(true);
                                                                        filesProv
                                                                            .setResponseStatus(requestClass.postConnectedResponseStatus());
                                                                        setState(
                                                                            () {
                                                                          businessCardSelected =
                                                                              idCardSelected = invoiceSelected = passportSelected = false;
                                                                        });
                                                                        debugPrint(
                                                                            "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          } else if (requestClass
                                                                  .postConnectedResponseStatus() ==
                                                              401) {
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const LoginPage(),
                                                                    ));
                                                          }
                                                        },
                                                      );
                                                    } else {
                                                      requestClass
                                                          .extractPostRequestConnectedUser(
                                                              imageBytes,
                                                              croppedFile.path
                                                                  .toString(),
                                                              userId,
                                                              "invoice",
                                                              token)
                                                          .then(
                                                        (value) async {
                                                          postResponse =
                                                              requestClass
                                                                  .postConnectdResponseBody();
                                                          filesProv
                                                              .setResponseStatus(
                                                                  requestClass
                                                                      .postConnectedResponseStatus());
                                                          debugPrint(
                                                              postResponse);
                                                          if (postResponse !=
                                                                  null &&
                                                              requestClass
                                                                      .postConnectedResponseStatus() ==
                                                                  200) {
                                                            data = await jsonDecode(
                                                                postResponse!);
                                                            var duration =
                                                                const Duration(
                                                                    seconds:
                                                                        15);

                                                            sleep(duration);
                                                            taskId =
                                                                data!["task_id"]
                                                                    .toString();
                                                            requestClass
                                                                .userConnectedExtractResult(
                                                                    taskId,
                                                                    token)
                                                                .whenComplete(
                                                              () async {
                                                                extractResultResponse =
                                                                    requestClass
                                                                        .extractResultResponseBody();
                                                                if (extractResultResponse !=
                                                                        null &&
                                                                    requestClass
                                                                            .extractResultResponseStatus() ==
                                                                        200) {
                                                                  data1 = await jsonDecode(
                                                                      extractResultResponse!);
                                                                  p = data1!["document"]
                                                                          [
                                                                          "Preprocessed_file_id"]
                                                                      .toString();
                                                                  requestClass
                                                                      .getImageConnectedUserRequest(
                                                                          p,
                                                                          userId,
                                                                          token)
                                                                      .whenComplete(
                                                                    () {
                                                                      getResponse =
                                                                          requestClass
                                                                              .getUserConnectedImageResponseBody();
                                                                      if (getResponse !=
                                                                              null &&
                                                                          requestClass.postConnectedResponseStatus() !=
                                                                              500) {
                                                                        camProv.setUploadPath(
                                                                            getResponse!);
                                                                        filesProv
                                                                            .setResponse(extractResultResponse);
                                                                        filesProv
                                                                            .setResponseState(true);
                                                                        filesProv
                                                                            .setResponseStatus(requestClass.postConnectedResponseStatus());
                                                                        setState(
                                                                            () {
                                                                          businessCardSelected =
                                                                              idCardSelected = invoiceSelected = passportSelected = false;
                                                                        });
                                                                        debugPrint(
                                                                            "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          } else if (requestClass
                                                                  .postConnectedResponseStatus() ==
                                                              401) {
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const LoginPage(),
                                                                    ));
                                                          }
                                                        },
                                                      );
                                                    }
                                                    debugPrint(
                                                        "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");

                                                    setState(() {
                                                      camProv
                                                          .removeAppBar(true);
                                                      camProv.setGenericState(
                                                          true);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      camProv.setGenericState(
                                                          false);
                                                      camProv
                                                          .removeAppBar(false);
                                                    });
                                                  }
                                                }
                                              },
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: _language
                                                    .tUploadErrorSelect(),
                                                backgroundColor: Colors.grey);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: _language.tCaptureError(),
                                              backgroundColor: Colors.grey);
                                        }
                                      },
                                      child: Text(
                                        _language.tProfilButtonSave(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
                setState(() {
                  camProv.setCurrentState("uploadFile");
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  FilePickerResult? resultFile;
// method to choose file
  Future<void> openFiles() async {
    try {
      resultFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["png", "pdf", "tiff", "jpeg"]);
      if (resultFile != null) {
        file = resultFile!.files.first;
        upload_file = File(file!.path.toString());
      } else {}
    } on Exception {
      Fluttertoast.showToast(
          msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
    }
  }
}
