// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unused_local_variable, depend_on_referenced_packages, unused_element, use_build_context_synchronously, prefer_final_fields, override_on_non_overriding_member, unrelated_type_equality_checks
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:aldoc/UI/local_notification.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:aldoc/provider/filesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_screenshot_widget/share_screenshot_widget.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class GenericForm extends StatefulWidget {
  const GenericForm({super.key});
  @override
  State<GenericForm> createState() => _GenericFormState();
}

class _GenericFormState extends State<GenericForm> {
  final Map<String, dynamic> _result = {};
  final Map<String, dynamic> _result2 = {};
  List<String>? keys;
  List<String>? values;
  List<String>? keys2;
  List<dynamic>? values2;
  bool buttonFavoritePressed = false;
  bool buttonSharePressed = false;
  String? screenshotPath;
  // /////////////////////:
  final GlobalKey _widgetScreenshotKey = GlobalKey();
  late final local_notification service;
  ScreenshotController _screenshotController = ScreenshotController();
  bool loading = false;
  Map<String, dynamic>? data;
  String? response;
  Language _language = Language();
  bool? loginState;

  ///methodes
  Future<void> readJsonDemo() async {
    final filesProv = Provider.of<filesProvider>(context);
    final camProv = Provider.of<cameraProvider>(context);

    try {
      response = filesProv.getResponse();
      if (response != null && response != "") {
        data = await jsonDecode(response!);
        if (data != null &&
            data != "" &&
            filesProv.getResponseStatus() != 500) {
          if (data!["data"]["ocr_results"] != null &&
              data!["data"]["ocr_results"] != "") {
            data!["data"]["ocr_results"].forEach(
              (key, value) {
                setState(() {
                  _result[key] = value;
                });
                keys = _result.keys.toList();
                values = _result.values.cast<String>().toList();
              },
            );
          }
          if (data!["data"]["detection_score"] != null &&
              data!["data"]["detection_score"] != "") {
            data!["data"]["detection_score"].forEach(
              (key, value) {
                setState(() {
                  _result2[key] = value * 100;
                });
                keys2 = _result2.keys.toList();
                values2 = _result2.values.toList();
              },
            );
          }
        }
      }
    } on Exception {
      Fluttertoast.showToast(
          msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
    }
  }

  Future<void> readJsonUserConnected() async {
    final filesProv = Provider.of<filesProvider>(context);
    final camProv = Provider.of<cameraProvider>(context);

    try {
      response = filesProv.getResponse();
      if (response != null && response != "") {
        data = await jsonDecode(response!);
        if (data != null &&
            data != "" &&
            filesProv.getResponseStatus() != 500) {
          if (data!["document"]["data"]["ocr_results"] != null &&
              data!["document"]["data"]["ocr_results"] != "") {
            data!["document"]["data"]["ocr_results"].forEach(
              (key, value) {
                setState(() {
                  _result[key] = value;
                });
                keys = _result.keys.toList();
                values = _result.values.cast<String>().toList();
              },
            );
          }
          if (data!["document"]["data"]["detection_score"] != null &&
              data!["document"]["data"]["detection_score"] != "") {
            data!["document"]["data"]["detection_score"].forEach(
              (key, value) {
                setState(() {
                  _result2[key] = value * 100;
                });
                keys2 = _result2.keys.toList();
                values2 = _result2.values.toList();
              },
            );
          }
        }
      }
    } on Exception {
      Fluttertoast.showToast(
          msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
    }
  }

  Future<void> saveScreenshotToPdf() async {
    // Capture the screenshot
    final Uint8List? screenshotData = await _screenshotController.capture();
    // Create a new PDF document
    final pdf = pw.Document();
    // Add an image of the screenshot to the document
    final image = pw.MemoryImage(screenshotData!);
    pdf.addPage(pw.Page(build: (context) {
      return pw.Center(child: pw.Image(image));
    }));

    // Save the document to a file
    final directory = await getApplicationDocumentsDirectory();
    final file =
        File('${directory.path}/Extracted Information${DateTime.now()}.pdf');
    final bytes = await pdf.save();
    await file.writeAsBytes(bytes);
    FolderFileSaver.saveFileToFolderExt(file.path);
  }

  @override
  void initState() {
    service = local_notification();
    service.intialize();
    super.initState();
    setState(
      () => _language.getLanguage(),
    );
    SharedPreferences.getInstance().then(
      (value) {
        setState(() {
          loginState = value.getBool("loginState");
        });
      },
    );
    // loadingAnimation();
    // readJson();
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

  @override
  Widget build(BuildContext context) {
    final camProv = Provider.of<cameraProvider>(context);
    final filesProv = Provider.of<filesProvider>(context);
    String? ImageUploadedPath = camProv.getPathUploadImage();
    String? currentState = camProv.getCurrentState();
    if (loginState == true) {
      readJsonUserConnected();
    } else {
      readJsonDemo();
    }
    return Scaffold(
      backgroundColor: const Color(0xffF8FBFA),
      body: filesProv.getResponseState() == true
          ? formView()
          : Stack(
              children: [
                // && currentState == "uploadFile"
                ImageUploadedPath != null && currentState == "uploadFile"
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 8, right: 4),
                        child: Image.file(
                          File(camProv.getPathUploadImage().toString()),
                          height: 170,
                          width: 275,
                        ),
                      ))
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 8, right: 4),
                        child: Image.file(
                          File(camProv.getPathImage().toString()),
                          height: 170,
                          width: 275,
                        ),
                      )),
                const Center(child: RiveAnimation.asset("assets/ocr_card.riv")),
              ],
            ),
    );
  }

  Widget formImage() {
    final camProv = Provider.of<cameraProvider>(context);
    String? ImagePath = camProv.getPathImage();
    String? ImageUploadedPath = camProv.getPathUploadImage();
    String? currentState = camProv.getCurrentState();
    if (ImagePath != null && currentState != "uploadFile") {
      return Padding(
          padding: const EdgeInsets.only(top: 65, right: 25, left: 25),
          child: Image.file(
            File(
              ImagePath,
            ),
            height: 230,
            // fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
          ));
    } else if (ImageUploadedPath != null && currentState == "uploadFile") {
      //&& currentState == "uploadFile"
      return Padding(
        padding: const EdgeInsets.only(top: 65, right: 25, left: 25),
        child:
            // ImageUploadedPath.split(".").last == 'pdf'
            //     ? Padding(
            //         padding: const EdgeInsets.only(bottom: 350),
            //         child: PDFView(
            //           filePath: ImageUploadedPath,
            //           fitEachPage: true,
            //           pageSnap: false,
            //         ),
            //       )
            //     :
            Image.file(
          File(
            ImageUploadedPath,
          ),
          height: 230,
          // fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width,
        ),
      );
    }
    return Container();
  }

  int currentProgress = 0;
  void updateProgress() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentProgress < 100) {
        currentProgress += 10;

        service.showNotification(
            id: 0,
            title: _language.tGenericFormDownloadNotification(),
            body: "",
            p: currentProgress,
            showProgress: true);
      } else {
        timer.cancel();
        service.showNotification(
            id: 0,
            title: _language.tGenericFormDownloadCompletedNotification(),
            body: "",
            p: 0,
            showProgress: false);
        // service.onDidReceivedLocalNotifications(
        //     0, "test", "", "Download Completed");
      }
    });
  }

  Widget formView() {
    final camProv = Provider.of<cameraProvider>(context);
    String? ImagePath = camProv.getPathImage();
    String? ImageUploaded = camProv.getPathUploadImage();
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _saveName = TextEditingController();
    final filesProv = Provider.of<filesProvider>(context);
    String? savedName = filesProv.getSaveName();

    return Align(
      alignment: Alignment.bottomCenter,
      child: ShareScreenshotAsImage(
        globalKey: _widgetScreenshotKey,
        child: Screenshot(
          controller: _screenshotController,
          child: Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, top: 34, bottom: 37),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xff222833)),
            child: Stack(children: [
              formImage(),
              Padding(
                padding: EdgeInsets.only(
                    top: ImageUploaded != null &&
                            ImageUploaded.split(".").last == 'pdf'
                        ? 400
                        : 320,
                    bottom: 100,
                    left: 22,
                    right: 10),
                child: ScrollConfiguration(
                  behavior: MyScrollBehavior(),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 80,
                            mainAxisSpacing: 5,
                            crossAxisCount: 2,
                            crossAxisSpacing: 1),
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    itemCount: _result.length,
                    itemBuilder: (context, index) {
                      return Stack(children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${keys![index]} :",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Row(
                                children: [
                                  values2 != null
                                      ? champContainer(values![index],
                                          values2![index].toInt())
                                      : champContainer(values![index], null)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]);
                    },
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 45,
                  child: IconButton(
                      splashRadius: 0.1,
                      onPressed: () {
                        setState(() {
                          buttonFavoritePressed = !buttonFavoritePressed;
                        });
                        // saver screenshot
                        if (buttonFavoritePressed == true &&
                            savedName != null &&
                            _saveName.text == "") {
                          setState(() {
                            savedName = "";
                            buttonFavoritePressed = false;
                          });
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: AlertDialog(
                                  backgroundColor: const Color(0xffF3F3F3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _language.tGenericFormFileName(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Form(
                                          key: _formKey,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, right: 10, left: 10),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .grey)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey
                                                                .shade400)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.red,
                                                            width: 2.0)),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    Colors.red,
                                                                width: 2.0)),
                                              ),
                                              controller: _saveName,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return _language
                                                      .tGenericFormFileNameMsgError1();
                                                } else if (value == savedName) {
                                                  return _language
                                                      .tGenericFormFileNameMsgError2();
                                                }
                                                return null;
                                              },
                                            ),
                                          )),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 40, top: 20),
                                            child: Container(
                                              width: 80,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight: Radius
                                                              .circular(10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Color(0xffFFFFFF)),
                                              child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      buttonFavoritePressed =
                                                          false;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    _language
                                                        .tProfilButtonCancel(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10, top: 20),
                                            child: Container(
                                              width: 100,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight: Radius
                                                              .circular(10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Color(0xff41B072)),
                                              child: TextButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      if (_saveName.text !=
                                                              savedName ||
                                                          savedName == null) {
                                                        setState(() {
                                                          filesProv.setSaveName(
                                                              _saveName.text);
                                                          filesProv
                                                              .setFavoriteState(
                                                                  true);
                                                          Navigator.pop(
                                                              context);
                                                          Fluttertoast.showToast(
                                                              msg: _language
                                                                  .tGenericFormSaveMsg(),
                                                              backgroundColor:
                                                                  Colors.grey);
                                                          buttonFavoritePressed =
                                                              true;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    _language
                                                        .tProfilButtonSave(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      icon: buttonFavoritePressed &&
                                  savedName != null &&
                                  filesProv.getFavoriteState() == true ||
                              !buttonFavoritePressed &&
                                  savedName != null &&
                                  _saveName.text == "" &&
                                  filesProv.getFavoriteState() == true
                          ? const Icon(
                              Icons.star_rate,
                              size: 23,
                              color: Color(0xffF8FBFA),
                            )
                          : const RiveAnimation.asset(
                              "assets/iconswhite.riv",
                              artboard: "LIKE/STAR",
                            ))),
              Positioned(
                  top: 0,
                  right: 10,
                  child: IconButton(
                    splashRadius: 0.1,
                    onPressed: () {
                      buttonSharePressed = !buttonSharePressed;
                      showMenu(
                          color: const Color(0xffF8FBFA),
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          position: const RelativeRect.fromLTRB(150, 75, 35, 0),
                          items: [
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () async {
                                saveScreenshotToPdf();
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    updateProgress();
                                  },
                                );
                              },
                              leading: const Icon(
                                Icons.file_download_outlined,
                                color: Colors.black,
                              ),
                              title: Text(
                                _language.tGenericFormDownloadFileText(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                shareWidgets(globalKey: _widgetScreenshotKey);
                              },
                              leading: const Icon(
                                Icons.ios_share_rounded,
                                color: Colors.black,
                              ),
                              title: Text(
                                _language.tGenericFormShareText(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                          ]);
                    },
                    icon: const Icon(
                      Icons.share,
                      size: 20,
                    ),
                    color: Colors.white,
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  Widget champContainer(String? t, int? t2) {
    return Container(
        width: 160,
        // constraints: const BoxConstraints(maxWidth: double.infinity),
        decoration: BoxDecoration(
            color: const Color(0xffF8FBFA),
            borderRadius: BorderRadius.circular(7)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 10, left: 10, right: 90),
                    child: Text(t!, style: const TextStyle(fontSize: 13)),
                  ),
                ]),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffF8FBFA),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: t));
                        },
                        icon: const Icon(
                          Icons.content_copy,
                          size: 17,
                        )),
                    if (t2 != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${t2.toString()}%",
                            style: const TextStyle(fontSize: 13),
                          ),
                          const Icon(
                            size: 19,
                            Icons.check_circle,
                            color: Color(0xff41B072),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

//  scroll glow effect
class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
