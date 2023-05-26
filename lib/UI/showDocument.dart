// ignore_for_file: camel_case_types, must_be_immutable, unrelated_type_equality_checks, override_on_non_overriding_member, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:aldoc/UI/Home.dart';
import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/UI/local_notification.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:aldoc/provider/filesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_screenshot_widget/share_screenshot_widget.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class showDocument extends StatefulWidget {
  String? userId;
  String? userToken;
  String? taskId;
  showDocument(
      {super.key,
      required this.userToken,
      required this.userId,
      required this.taskId});

  @override
  State<showDocument> createState() => _showDocumentState();
}

class _showDocumentState extends State<showDocument> {
  String? extractResultResponse;
  String? imagePath;
  Map<String, dynamic>? data1;
  String? p;
  String? getResponse;
  RequestClass requestClass = RequestClass();
  late final local_notification service;
  Future<void> readDocument(
      String? taskId, String? userToken, String? id) async {
    requestClass.userConnectedExtractResult(taskId, userToken).whenComplete(
      () async {
        extractResultResponse = requestClass.extractResultResponseBody();
        if (extractResultResponse != null &&
            requestClass.extractResultResponseStatus() == 200) {
          data1 = await jsonDecode(extractResultResponse!);
          p = data1!["document"]["Preprocessed_file_id"].toString();
          print("p:$p");
          requestClass
              .getImageConnectedUserRequest(p, id, userToken)
              .whenComplete(
            () {
              getResponse = requestClass.getUserConnectedImageResponseBody();
              if (getResponse != null &&
                  requestClass.postConnectedResponseStatus() != 500) {
                setState(() {
                  imagePath = getResponse!;
                  print(imagePath);
                });

                setState(() {
                  load = true;
                });
              }
            },
          );
        }
      },
    ); //646f7f56e522e46f7453472b
  }

  int? deleteStatus;
  Future<void> deleteDocument(String? taskId, String? token) async {
    Uri url = Uri.parse(
        "https://aldoc.dev.algobrain.ai/bff//commontaskmanager/tasks_status?task_status=Deleted");

    if (taskId != null) {
      var requestBody = {
        'tasks_ids': [taskId.toString()],
      };
      var request = await http.put(url,
          body: jsonEncode(requestBody),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
      deleteStatus = request.statusCode;
      debugPrint(request.body);
    }
  }

  @override
  void initState() {
    service = local_notification();
    service.intialize();
    super.initState();
    readDocument(widget.taskId, widget.userToken, widget.userId);
  }

  bool? load = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    readJsonUserConnected();
    return Scaffold(
        backgroundColor: const Color(0xffF8FBFA),
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListTile(
              leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ));
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xff41B072),
                  size: 32,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // IconButton(
                  //     splashRadius: 0.1,
                  //     onPressed: () {
                  //       buttonFavoritePressed = !buttonFavoritePressed;
                  //     },
                  //     icon: buttonFavoritePressed
                  //         ? const Icon(
                  //             Icons.star_rate,
                  //             size: 23,
                  //             color: Color.fromARGB(255, 36, 119, 91),
                  //           )
                  //         : const RiveAnimation.asset(
                  //             "assets/iconswhite.riv",
                  //             artboard: "LIKE/STAR",
                  //           )),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: FormField(
                                builder: (state) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xffF3F3F3),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _language.tShowDocumentDelete(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
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
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
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
                                                  right: 10, top: 30),
                                              child: Container(
                                                width: 90,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
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
                                                      print(
                                                          "taskId:${widget.taskId}");
                                                      print(
                                                          "token:${widget.userToken}");
                                                      if (widget.taskId !=
                                                              null &&
                                                          widget.userToken !=
                                                              null) {
                                                        setState(() {
                                                          loading = true;
                                                          state.didChange(
                                                              loading);
                                                        });
                                                        deleteDocument(
                                                                widget.taskId!,
                                                                widget
                                                                    .userToken)
                                                            .whenComplete(
                                                          () {
                                                            if (deleteStatus ==
                                                                200) {
                                                              Fluttertoast.showToast(
                                                                  msg: _language
                                                                      .tDeleteSuccesMsg(),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey);
                                                              Navigator
                                                                  .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const Home(),
                                                                      ));
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: _language
                                                                      .tErrorMsg(),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey);
                                                              setState(() {
                                                                loading = false;
                                                                state.didChange(
                                                                    loading);
                                                              });
                                                            }
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: loading
                                                        ? LoadingAnimationWidget
                                                            .inkDrop(
                                                                color: Colors
                                                                    .white,
                                                                size: 30)
                                                        : Text(
                                                            _language
                                                                .tbouttonshowDocSave(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          )),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xff41B072),
                      )),
                ],
              ),
            ),
          ),
        ),
        body: load != null && load == true && imagePath != null
            ? formView()
            : Column(
                children: [
                  Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: Colors.black, size: 30))
                ],
              ));
  }

  Map<String, dynamic>? data;
  String? response;
  final Map<String, dynamic> _result = {};
  final Map<String, dynamic> _result2 = {};
  List<String>? keys;
  List<String>? values;
  List<String>? keys2;
  List<dynamic>? values2;
  final Language _language = Language();
  Future<void> readJsonUserConnected() async {
    final filesProv = Provider.of<filesProvider>(context);
    final camProv = Provider.of<cameraProvider>(context);

    try {
      response = extractResultResponse;
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

  Widget formImage() {
    return Padding(
        padding: const EdgeInsets.only(top: 65, right: 25, left: 25),
        child: Image.file(
          File(
            imagePath!,
          ),
          height: 230,
          // fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width,
        ));
  }

  bool buttonFavoritePressed = false;
  bool buttonSharePressed = false;
  String? screenshotPath;
  final ScreenshotController _screenshotController = ScreenshotController();
  final GlobalKey _widgetScreenshotKey = GlobalKey();
  Widget formView() {
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
                const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xff222833)),
            child: Stack(children: [
              if (imagePath != null) formImage(),
              Padding(
                padding: const EdgeInsets.only(
                    top: 320, bottom: 100, left: 22, right: 10),
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
                      onPressed: () {},
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

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
