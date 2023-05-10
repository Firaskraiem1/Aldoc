// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_local_variable, override_on_non_overriding_member, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:aldoc/UI/CameraScreen.dart';
import 'package:aldoc/UI/UploadScreen.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/provider/authProvider.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:aldoc/provider/filesProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rive/rive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  ////variables
  bool _FloatButtonPressed = false;
  bool _FloatButtonIdPressed = false;
  bool _FloatButtonPassPressed = false;
  bool _FloatButtonCardPressed = false;
  bool _FloatButtonInvoicePressed = false;
  String _currentState = "";
  late String _textBussButton;
  late String _textPassButton;
  late String _textIdButton;
  late String _textInvoiceButton;
  Alignment _alignement1 = Alignment.centerLeft;
  Alignment _alignement2 = Alignment.topCenter;
  Alignment _alignement3 = Alignment.centerRight;

////
////methodes

  @override
  void initState() {
    super.initState();
    _textBussButton = "";
    _textPassButton = "";
    _textIdButton = "";
    _textInvoiceButton = "";
    _currentState = "home";
    _alignement1 = Alignment.bottomCenter;
    _alignement2 = Alignment.bottomCenter;
    _alignement3 = Alignment.bottomCenter;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

// home screen methodes and  variables
  bool checkboxValue1 = false;
  bool checkboxAllFiles1 = false;
  bool checkboxValue2 = false;
  bool checkboxAllFiles2 = false;
  bool checkboxValue3 = false;
  bool checkboxAllFiles3 = false;
  bool checkboxValue4 = false;
  bool checkboxAllFiles4 = false;
  final creationTime = DateTime.now().minute;
  var time;
  Future<void> fetchData() async {
    setState(() {
      time = DateTime.now().minute - creationTime;
    });
  }

  final RefreshController _refreshControllerAllFiles =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerFavoriteFilles =
      RefreshController(initialRefresh: false);
  void _onRefreshFavoriteFiles() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshControllerFavoriteFilles.refreshCompleted();
  }

  void _onLoadingFavoriteFiles() async {
    // monitor network fetch
    await Future.delayed(
      const Duration(milliseconds: 1000),
      () {},
    );
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshControllerFavoriteFilles.loadComplete();
  }

  void _onLoadingAllFiles() async {
    // monitor network fetch
    await Future.delayed(
      const Duration(milliseconds: 1000),
      () {},
    );
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshControllerAllFiles.loadComplete();
  }

  void _onRefreshAllFiles() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshControllerAllFiles.refreshCompleted();
  }

///////////////////////////////////
////////
  bool imageSelected = false;
  PlatformFile? image;
  File? upload_image;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> uploadImage() async {
    try {
      FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["png", "pdf", "tiff", "jpeg"]);

      if (resultFile != null) {
        ///////////////////////
        setState(() {
          imageSelected = true;
        });
        ///////////////////////
        image = resultFile.files.first;
        upload_image = File(image!.path.toString());
      } else {}
    } catch (e) {
      print(e);
    }
  }

  TabController? _tabController;
  /////
  @override
  Widget build(BuildContext context) {
    final camProv = Provider.of<cameraProvider>(context);
    String? currentState = camProv.getCurrentState();
    bool removeAppBar = camProv.getRemoveAppBar();
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: _currentState == "scanId" ||
              _currentState == "scanPass" ||
              _currentState == "scanCard" ||
              _currentState == "scanInvoice"
          ? true
          : false,
      //////////////////////////////////////////////////////////////////////////
      // appBar
      appBar: appBarWidget(),
      //Fin appBar
      //////////////////////////////////////////////////////////////////////////
      //drawer
      drawer: _currentState == "home" || _currentState == "uploadFile"
          ? ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: Drawer(
                //Color(0xff41B072)
                backgroundColor: const Color(0xffF8FBFA),
                child: ListView(children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/aldoc.png"))),
                    child: null,
                  ),
                  TextButton.icon(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.transparent;
                          },
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.login,
                          color: Colors.black,
                        ),
                      ),
                      label: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.black),
                      )),
                  TextButton.icon(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.transparent;
                          },
                        ),
                      ),
                      onPressed: () {},
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 18),
                        child: Icon(
                          Icons.info,
                          color: Colors.black,
                        ),
                      ),
                      label: const Text(
                        "about",
                        style: TextStyle(color: Colors.black),
                      ))
                ]),
              ),
            )
          : null,
      //fin drawer
      //////////////////////////////////////////////////////////////////////////
      // float action button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 35),
        child: _FloatButtonPressed ||
                _FloatButtonIdPressed ||
                _FloatButtonCardPressed ||
                _FloatButtonPassPressed ||
                _FloatButtonInvoicePressed
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent),
                //padding container de stack
                padding: const EdgeInsets.only(top: 0),
                //conatiner of float action button
                width: 300,
                height: 200, // width and height of container (3 buttons )
                // color of container (3 buttons )
                child: BackdropFilter(
                    // color blur(flou)
                    // if pressed= true  => color blur
                    filter: _FloatButtonPressed &&
                            (_currentState == "home" ||
                                _currentState == "uploadFile")
                        ? ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5)
                        : ImageFilter.blur(),
                    //fin
                    // widget stack button
                    child: homeFloatButton()))
            : homeFloatButton(),
      ),
      //fin float action button
      //////////////////////////////////////////////////////////////////////////
      //Bootom appBar
      bottomNavigationBar: _currentState != "scanId" &&
                  _currentState != "scanPass" &&
                  _currentState != "scanCard" &&
                  _currentState != "scanInvoice" ||
              removeAppBar == true
          ? bottomNavigationBar
          : null,
      //Fin bootom appBar
      //////////////////////////////////////////////////////////////////////////
      body: body(),
      //////////////////////////////////////////////////////////////////////////
      // background color scaffold screen
      backgroundColor: const Color(0xffF8FBFA),
    );
  }

///////////////////////////// widgets ////////////////////////////
  ///
  PreferredSizeWidget appBarWidget() {
    final authProv = Provider.of<authProvider>(context);
    final camProv = Provider.of<cameraProvider>(context);
    String? currentState = camProv.getCurrentState();
    bool loginState = authProv.getLoginState();
    if (_currentState != "scanId" &&
        _currentState != "scanCard" &&
        _currentState != "scanPass" &&
        _currentState != "scanInvoice" &&
        currentState != "uploadFile" &&
        loginState == false) {
      return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: ListTile(
            leading: IconButton(
              padding: const EdgeInsets.only(top: 43),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              icon: Image.asset("assets/drawer.png"),
            ),
          ),
        ),
      );
    } else if (_currentState != "scanId" &&
        _currentState != "scanCard" &&
        _currentState != "scanPass" &&
        _currentState != "scanInvoice" &&
        currentState != "uploadFile" &&
        loginState == true) {
      return loginAppBar();
    }
    return cameraAppbar();
  }

  Widget get bottomNavigationBar {
    final camProv = Provider.of<cameraProvider>(context);
    final filesProv = Provider.of<filesProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 7, right: 15, left: 15),
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 5),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: BottomAppBar(
                // padding bottom appbar
                padding: const EdgeInsets.only(left: 37, right: 37),
                // height of appBar height:
                color:
                    // _currentState == "scanId" ||
                    //         _currentState == "scanPass" ||
                    //         _currentState == "scanCard"
                    //     ? const Color(0xffBB9E7C)
                    const Color(0xffF8FBFA), //color of app bar
                //Row bottom appBar
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // home icon
                        IconButton(
                          splashRadius: 0.1,
                          padding: const EdgeInsets.only(
                              top: 17,
                              bottom: 17,
                              right: 30), //  padding of icon button
                          onPressed: _FloatButtonPressed &&
                                  _currentState == "home"
                              ? () {}
                              : () {
                                  setState(() {
                                    filesProv.setFavoriteState(false);
                                    camProv.removeAppBar(false);
                                    camProv.setCurrentState("");
                                    camProv.setGenericState(false);
                                    _currentState = "home";
                                    _FloatButtonPressed =
                                        _FloatButtonCardPressed =
                                            _FloatButtonPassPressed =
                                                _FloatButtonIdPressed =
                                                    _FloatButtonInvoicePressed =
                                                        false;
                                    _textBussButton = _textPassButton =
                                        _textIdButton = _textInvoiceButton = "";
                                    _alignement1 = _alignement2 =
                                        _alignement3 = Alignment.bottomCenter;
                                  });
                                },
                          icon: Image.asset(
                            "assets/home.png",
                          ),
                          color: const Color(0xffF8FBFA),
                        ),
                      ],
                    ),
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(
                    //           left: 25, right: 25, top: 40), // padding of text
                    //       child: Text(
                    //         _textBottomBar,
                    //         style: const TextStyle(color: Colors.white),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          splashRadius: 0.1,
                          padding: const EdgeInsets.only(
                              top: 17,
                              bottom: 17,
                              left: 30), // padding of Icon button
                          onPressed: () {
                            setState(() {
                              _FloatButtonPressed = _FloatButtonCardPressed =
                                  _FloatButtonPassPressed =
                                      _FloatButtonIdPressed =
                                          _FloatButtonInvoicePressed = false;
                              _textBussButton = _textPassButton =
                                  _textIdButton = _textInvoiceButton = "";
                              _alignement1 = _alignement2 =
                                  _alignement3 = Alignment.bottomCenter;
                              camProv.setGenericState(false);
                              _currentState = "uploadFile";
                            });
                          },
                          icon: Image.asset("assets/upload.png"),
                          color: const Color(0xffF8FBFA),
                        ),
                      ],
                    ),
                  ],
                )
                // fin row
                ),
          )),
    );
  }

  PreferredSizeWidget cameraAppbar() {
    final camProv = Provider.of<cameraProvider>(context);
    bool removeAppBar = camProv.getRemoveAppBar();
    bool stateFlash = camProv.getFlashState();
    if (removeAppBar == false && _currentState != "uploadFile") {
      return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 100),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListTile(
            leading: IconButton(
                onPressed: () {
                  if (camProv.getFlashState() == true) {
                    camProv.flashState(false);
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ));
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                )),
            trailing: IconButton(
              onPressed: stateFlash
                  ? () {
                      setState(() {
                        camProv.flashState(false);
                      });
                    }
                  : () {
                      setState(() {
                        camProv.flashState(true);
                      });
                    },
              icon: stateFlash
                  ? const Icon(
                      Icons.flash_on,
                      size: 30,
                      color: Color(0xffF8FBFA),
                    )
                  : const Icon(
                      Icons.flash_off,
                      size: 30,
                      color: Color(0xffF8FBFA),
                    ),
            ),
          ),
        ),
      );
    }
    return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 100),
        child: const SizedBox());
  }

// method for user profile (update username)
  String updatedText = "userName";
  void updateText(String t) {
    setState(() {
      updatedText = t;
    });
  }

  PreferredSizeWidget loginAppBar() {
    final authProv = Provider.of<authProvider>(context);
    final TextEditingController _usernameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 20),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  onPressed: () {},
                  icon: const RiveAnimation.asset(
                    "assets/icons.riv",
                    artboard: "BELL",
                  )),
              const SizedBox(
                width: 15,
              ),
              CircleAvatar(
                //size
                radius: 26.5,
                backgroundImage:
                    image != null ? FileImage(upload_image!) : null,
                foregroundImage: image == null
                    ? const AssetImage("assets/profilImag.png")
                    : null,
                foregroundColor: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xffF8FBFA),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: ScrollConfiguration(
                                behavior: MyScrollBehavior(),
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: CircleAvatar(
                                          radius: 70,
                                          backgroundImage: image != null
                                              ? FileImage(upload_image!)
                                              : null,
                                          foregroundImage: image == null
                                              ? const AssetImage(
                                                  "assets/profilImag.png")
                                              : null,
                                          foregroundColor: Colors.transparent,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 40),
                                        child: Center(
                                            child: Text(
                                          updatedText,
                                          style: const TextStyle(fontSize: 18),
                                        )),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  return Colors.transparent;
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              uploadImage().then(
                                                (value) {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ),
                                            label: const Text(
                                              "Edit photo",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  return Colors.transparent;
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              //edit username show dialog
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 10, sigmaY: 10),
                                                    child: AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: const [
                                                              Text(
                                                                "Enter username",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                          Form(
                                                              key: _formKey,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child:
                                                                      TextFormField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      filled:
                                                                          true,
                                                                      contentPadding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              20,
                                                                              10,
                                                                              20,
                                                                              10),
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              100.0),
                                                                          borderSide:
                                                                              const BorderSide(color: Colors.grey)),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              100.0),
                                                                          borderSide:
                                                                              BorderSide(color: Colors.grey.shade400)),
                                                                      errorBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              100.0),
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.red,
                                                                              width: 2.0)),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              100.0),
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.red,
                                                                              width: 2.0)),
                                                                    ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .name,
                                                                    onChanged:
                                                                        updateText,
                                                                    controller:
                                                                        _usernameController,
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return "Enter username";
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              )),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            40,
                                                                        top:
                                                                            15),
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "Cancel",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            5,
                                                                        left:
                                                                            40,
                                                                        top:
                                                                            15),
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (_formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            setState(() {
                                                                              // _usernameController.text =
                                                                              //     "";
                                                                              Navigator.of(context).pop(updatedText);
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "Save",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit_note,
                                              color: Colors.black,
                                            ),
                                            label: const Text(
                                              "Edit username",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  return Colors.transparent;
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              authProv.setLoginState(false);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Home(),
                                                  ));
                                            },
                                            icon: const Icon(
                                              Icons.logout,
                                              color: Colors.black,
                                            ),
                                            label: const Text(
                                              "LogOut",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      },
                    );
                  },
                ),
              ),
            ]),
          ),
        ]));
  }

  Widget body() {
    final camProv = Provider.of<cameraProvider>(context);
    if (_currentState == "home") {
      return homeScreen();
    } else if (_currentState == "uploadFile") {
      return const UploadScreen();
    } else if (_currentState == "scanId" ||
        _currentState == "scanCard" ||
        _currentState == "scanPass" ||
        _currentState == "scanInvoice") {
      return const CameraScreen();
    }
    return homeScreen();
  }

  Widget? homeFloatButton() {
    if (_currentState == "scanId") {
      return stackIdButton();
    } else if (_currentState == "scanPass") {
      return stackPassButton();
    } else if (_currentState == "scanCard") {
      return stackCardButton();
    } else if (_currentState == "scanInvoice") {
      return stackInvoiceButton();
    } else if (_currentState == "uploadFile") {
      return stackScanButton();
    }
    return stackScanButton();
  }

  Widget stackScanButton() {
    final camProv = Provider.of<cameraProvider>(context);
    return Stack(
      children: [
        //align (button 1)
        Padding(
          padding: EdgeInsets.only(left: _FloatButtonPressed ? 5 : 0),
          child: Align(
            alignment: _alignement1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text buss card
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textBussButton,
                    style: TextStyle(
                        color: _currentState == "home" ||
                                _currentState == "uploadFile" &&
                                    camProv.getGenericState() == false
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //fin padding
                // container button 1
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanCard1",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("businessCard");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/bussinessCard.png",
                    ),
                  ),
                ),
                // fin conatiner button 1
              ],
            ),
          ),
        ),
        //fin  align (button 1)
        //align (button 2)
        Padding(
          padding: EdgeInsets.only(right: _FloatButtonPressed ? 85 : 0),
          child: Align(
            alignment: _alignement2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text passport
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textPassButton,
                    style: TextStyle(
                        color: _currentState == "home" ||
                                _currentState == "uploadFile" &&
                                    camProv.getGenericState() == false
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 2
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanPass1",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setInvoiceCamera(false);
                        camProv.setPassportCamera(true);
                        camProv.setImagePath("");
                        camProv.setCurrentState("passport");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/passportCard.png",
                      width: 90,
                      height: 33,
                    ),
                  ),
                ),
                // fin container button 2
              ],
            ),
          ),
        ),
        //fin align (button 2)
        // align(button3)
        Padding(
          padding: EdgeInsets.only(left: _FloatButtonPressed ? 85 : 0),
          child: Align(
            alignment: _alignement2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text invoice
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textInvoiceButton,
                    style: TextStyle(
                        color: _currentState == "home" ||
                                _currentState == "uploadFile" &&
                                    camProv.getGenericState() == false
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 2
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanInvoice1",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(true);
                        camProv.setImagePath("");
                        camProv.setCurrentState("invoice");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/invoice.png",
                      width: 90,
                      height: 58,
                    ),
                  ),
                ),
                // fin container button 2
              ],
            ),
          ),
        ),
        // fin align (button3)
        //align (button 4)
        Padding(
          padding: EdgeInsets.only(right: _FloatButtonPressed ? 5 : 0),
          child: Align(
            alignment: _alignement3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //padding text id doc
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textIdButton,
                    style: TextStyle(
                        color: _currentState == "home" ||
                                _currentState == "uploadFile" &&
                                    camProv.getGenericState() == false
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanId1",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("idDocument");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/idCard.png",
                      width: 90,
                      height: 25,
                    ),
                  ),
                ),
                //fin conatiner button
              ],
            ),
          ),
        ),
        // fin align button 4
        //float button align
        Align(
          alignment: Alignment.bottomCenter,
          //padding of folat button
          child: Padding(
            padding: _FloatButtonPressed
                ? const EdgeInsets.only(bottom: 20)
                : const EdgeInsets.all(0),
            child: Container(
              decoration: const BoxDecoration(),
              // with and height of float button
              width: _FloatButtonPressed ? 50 : 65,
              height: _FloatButtonPressed ? 50 : 65,
              //fin
              child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "btnScanFile1",
                  // color click
                  splashColor: Colors.transparent,
                  //Fin
                  shape: const CircleBorder(
                      side: BorderSide(color: Colors.white, width: 2.5)),
                  backgroundColor: const Color(0xff41B072),
                  onPressed: () {
                    setState(() {
                      _FloatButtonPressed = !_FloatButtonPressed;
                      if (_FloatButtonPressed) {
                        _textBussButton = "business card";
                        _textPassButton = "Passport";
                        _textIdButton = "id document";
                        _textInvoiceButton = "Invoice";
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  },
                  // icon
                  child: _FloatButtonPressed
                      ? const Icon(
                          Icons.close,
                          size: 40,
                        )
                      : const Icon(
                          Icons.crop_free,
                          size: 40,
                        )
                  // fin
                  ),
            ),
          ),
          //fin padding
        ),
        // fin float  button align
      ],
    );
  }

  Widget stackIdButton() {
    final camProv = Provider.of<cameraProvider>(context);
    return Stack(
      children: [
        //align (button 1)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonIdPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonIdPressed && camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement1,
            //column button 1
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text buss card
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textBussButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //fin padding
                // container button 1
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanCard2",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("businessCard");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/bussinessCard.png",
                    ),
                  ),
                ),
                // fin conatiner button 1
              ],
            ),
            //fin column
          ),
        ),
        //fin  align (button 1)
        //align (button 2)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonIdPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonIdPressed && camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            //column button 2
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text passport
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textPassButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 2
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanPass2",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(true);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("passport");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/passportCard.png",
                      width: 90,
                      height: 33,
                    ),
                  ),
                ),
                // fin container button 2
              ],
            ),
            //fin column
          ),
        ),
        //fin align (button 2)
        // align(button 3)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonIdPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonIdPressed && camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            //column button 3
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text invoice
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textInvoiceButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 2
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanInvoice2",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(true);
                        camProv.setCurrentState("invoice");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/invoice.png",
                      width: 90,
                      height: 58,
                    ),
                  ),
                ),
                // fin container button 3
              ],
            ),
            //fin column
          ),
        ),
        // fin align(button3)
        //align (button 4)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonIdPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonIdPressed && camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement3,
            //column button 3
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //padding text id doc
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textIdButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanId2",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("idDocument");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        _FloatButtonIdPressed = !_FloatButtonIdPressed;
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/idCard.png",
                      width: 90,
                      height: 25,
                    ),
                  ),
                ),
                //fin conatiner button
              ],
            ),
            //fin  column
          ),
        ),
        // fin align button 4
        //float button align
        Align(
          alignment: Alignment.bottomCenter,
          //padding of folat button
          child: Padding(
            padding: _FloatButtonIdPressed &&
                        camProv.getGenericState() == false ||
                    _FloatButtonIdPressed && camProv.getGenericState() == true
                ? const EdgeInsets.only(bottom: 20)
                : const EdgeInsets.all(0),
            child: Container(
              // with and height of float button
              width: _FloatButtonIdPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonIdPressed && camProv.getGenericState() == true
                  ? 50
                  : 65,
              height: _FloatButtonIdPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonIdPressed && camProv.getGenericState() == true
                  ? 50
                  : 65,
              //fin
              child: FloatingActionButton(
                elevation: 0,
                heroTag: "btnScanFile2",
                // color click
                splashColor: Colors.transparent,
                //Fin
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 2.5)),
                backgroundColor: const Color(0xff41B072),
                onPressed: () async {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    _FloatButtonPressed = false;
                    _FloatButtonPassPressed = false;
                    _FloatButtonCardPressed = false;
                    _FloatButtonInvoicePressed = false;
                    _FloatButtonIdPressed = !_FloatButtonIdPressed;
                    setState(() {
                      if (_FloatButtonIdPressed &&
                          camProv.getGenericState() == false) {
                        camProv.cameraState(true);
                        camProv.setUploadPath("");
                        camProv.setGenericState(true);
                        _FloatButtonIdPressed = false;
                      } else if (_FloatButtonIdPressed &&
                          camProv.getGenericState() == true) {
                        _textBussButton = "business card";
                        _textPassButton = "Passport";
                        _textIdButton = "id document";
                        _textInvoiceButton = "Invoice";
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed to connect to host",
                        backgroundColor: Colors.grey);
                  }
                },
                // icon
                child: _FloatButtonIdPressed &&
                            camProv.getGenericState() == false ||
                        _FloatButtonIdPressed &&
                            camProv.getGenericState() == true
                    ? const Icon(
                        Icons.close,
                        size: 40,
                      )
                    : Image.asset(
                        "assets/idCard.png",
                        width: 90,
                        height: 25,
                      ),
                // fin
              ),
            ),
          ),
          //fin padding
        ),
        // fin float  button align
      ],
    );
  }

  Widget stackPassButton() {
    final camProv = Provider.of<cameraProvider>(context);
    return Stack(
      children: [
        //align (button 1)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonPassPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonPassPressed &&
                          camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement1,
            //column button 1
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text buss card
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textBussButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //fin padding
                // container button 1
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanCard3",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("businessCard");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/bussinessCard.png",
                    ),
                  ),
                ),
                // fin conatiner button 1
              ],
            ),
            //fin column
          ),
        ),
        //fin  align (button 1)
        //align (button 2)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonPassPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonPassPressed &&
                          camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            //column button 2
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text passport
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textPassButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 2
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanPass3",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(true);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("passport");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        // _textBottomBar = "Scan Pass";
                        _FloatButtonPassPressed = !_FloatButtonPassPressed;
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/passportCard.png",
                      width: 90,
                      height: 33,
                    ),
                  ),
                ),
                // fin container button 2
              ],
            ),
            //fin column
          ),
        ),
        //fin align (button 2)
        // align (button 3)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonPassPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonPassPressed &&
                          camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text invoice
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textInvoiceButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 3
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanInvoice3",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(true);
                        camProv.setImagePath("");
                        camProv.setCurrentState("invoice");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/invoice.png",
                      width: 90,
                      height: 58,
                    ),
                  ),
                ),
                // fin container button 3
              ],
            ),
          ),
        ),
        // fin align (button 3)
        //align (button 4)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonPassPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonPassPressed &&
                          camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement3,
            //column button 4
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //padding text id doc
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textIdButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanId3",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("idDocument");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/idCard.png",
                      width: 90,
                      height: 23,
                    ),
                  ),
                ),
                //fin conatiner button
              ],
            ),
            //fin  column
          ),
        ),
        // fin align button 4
        //float button align
        Align(
          alignment: Alignment.bottomCenter,
          //padding of folat button
          child: Padding(
            padding: _FloatButtonPassPressed &&
                        camProv.getGenericState() == false ||
                    _FloatButtonPassPressed && camProv.getGenericState() == true
                ? const EdgeInsets.only(bottom: 20)
                : const EdgeInsets.all(0),
            child: Container(
              // with and height of float button
              width: _FloatButtonPassPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonPassPressed &&
                          camProv.getGenericState() == true
                  ? 50
                  : 65,
              height: _FloatButtonPassPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonPassPressed &&
                          camProv.getGenericState() == true
                  ? 50
                  : 65,
              //fin
              child: FloatingActionButton(
                elevation: 0,
                heroTag: "btnScanFile3",
                // color click
                splashColor: Colors.transparent,
                //Fin
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 2.5)),
                backgroundColor: const Color(0xff41B072),
                onPressed: () async {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    _FloatButtonPressed = false;
                    _FloatButtonIdPressed = false;
                    _FloatButtonCardPressed = false;
                    _FloatButtonInvoicePressed = false;
                    _FloatButtonPassPressed = !_FloatButtonPassPressed;
                    setState(() {
                      if (_FloatButtonPassPressed &&
                          camProv.getGenericState() == false) {
                        camProv.cameraState(true);
                        camProv.setUploadPath("");
                        camProv.setGenericState(true);
                        _FloatButtonPassPressed = false;
                      } else if (_FloatButtonPassPressed &&
                          camProv.getGenericState() == true) {
                        _textBussButton = "business card";
                        _textPassButton = "Passport";
                        _textIdButton = "id document";
                        _textInvoiceButton = "Invoice";
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed to connect to host",
                        backgroundColor: Colors.grey);
                  }
                },
                // icon
                child: _FloatButtonPassPressed &&
                            camProv.getGenericState() == false ||
                        _FloatButtonPassPressed &&
                            camProv.getGenericState() == true
                    ? const Icon(
                        Icons.close,
                        size: 40,
                      )
                    : Image.asset(
                        "assets/passportCard.png",
                        width: 90,
                        height: 33,
                      ),
                // fin
              ),
            ),
          ),
          //fin padding
        ),
        // fin float  button align
      ],
    );
  }

  Widget stackCardButton() {
    final camProv = Provider.of<cameraProvider>(context);
    return Stack(
      children: [
        //align (button 1)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonCardPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonCardPressed &&
                          camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement1,
            //column button 1
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text buss card
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textBussButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //fin padding
                // container button 1
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanCard4",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("businessCard");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        _FloatButtonCardPressed = !_FloatButtonCardPressed;
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/bussinessCard.png",
                    ),
                  ),
                ),
                // fin conatiner button 1
              ],
            ),
            //fin column
          ),
        ),
        //fin  align (button 1)
        //align (button 2)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonCardPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonCardPressed &&
                          camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            //column button 2
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text passport
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textPassButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 2
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanPass4",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(true);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("passport");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/passportCard.png",
                      width: 90,
                      height: 33,
                    ),
                  ),
                ),
                // fin container button 2
              ],
            ),
            //fin column
          ),
        ),
        //fin align (button 2)
        // align (button 3)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonCardPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonCardPressed &&
                          camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text invoice
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textInvoiceButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 3
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanInvoice4",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setInvoiceCamera(true);
                        camProv.setPassportCamera(false);
                        camProv.setImagePath("");
                        camProv.setCurrentState("invoice");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/invoice.png",
                      width: 90,
                      height: 58,
                    ),
                  ),
                ),
                // fin container button 3
              ],
            ),
          ),
        ),
        // fin align (button 3)
        //align (button 4)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonCardPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonCardPressed &&
                          camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement3,
            //column button 4
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //padding text id doc
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textIdButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanId4",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setPassportCamera(false);
                        camProv.setCurrentState("idDocument");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/idCard.png",
                      width: 90,
                      height: 23,
                    ),
                  ),
                ),
                //fin conatiner button 4
              ],
            ),
            //fin  column
          ),
        ),
        // fin align button 4
        //float button align
        Align(
          alignment: Alignment.bottomCenter,
          //padding of folat button
          child: Padding(
            padding: _FloatButtonCardPressed &&
                        camProv.getGenericState() == false ||
                    _FloatButtonCardPressed && camProv.getGenericState() == true
                ? const EdgeInsets.only(bottom: 20)
                : const EdgeInsets.all(0),
            child: Container(
              // with and height of float button
              width: _FloatButtonCardPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonCardPressed &&
                          camProv.getGenericState() == true
                  ? 50
                  : 65,
              height: _FloatButtonCardPressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonCardPressed &&
                          camProv.getGenericState() == true
                  ? 50
                  : 65,
              //fin
              child: FloatingActionButton(
                elevation: 0,
                heroTag: "btnScanFile4",
                // color click
                splashColor: Colors.transparent,
                //Fin
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 2.5)),
                backgroundColor: const Color(0xff41B072),
                onPressed: () async {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    _FloatButtonPressed = false;
                    _FloatButtonIdPressed = false;
                    _FloatButtonPassPressed = false;
                    _FloatButtonInvoicePressed = false;
                    _FloatButtonCardPressed = !_FloatButtonCardPressed;
                    setState(() {
                      if (_FloatButtonCardPressed &&
                          camProv.getGenericState() == false) {
                        camProv.setUploadPath("");
                        camProv.cameraState(true);
                        camProv.setGenericState(true);
                        _FloatButtonCardPressed = false;
                      } else if (_FloatButtonCardPressed &&
                          camProv.getGenericState() == true) {
                        _textBussButton = "business card";
                        _textPassButton = "Passport";
                        _textIdButton = "id document";
                        _textInvoiceButton = "Invoice";
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed to connect to host",
                        backgroundColor: Colors.grey);
                  }
                },
                // icon
                child: _FloatButtonCardPressed &&
                            camProv.getGenericState() == false ||
                        _FloatButtonCardPressed &&
                            camProv.getGenericState() == true
                    ? const Icon(
                        Icons.close,
                        size: 40,
                      )
                    : Image.asset(
                        "assets/bussinessCard.png",
                      ),
                // fin
              ),
            ),
          ),
          //fin padding
        ),
        // fin float  button align
      ],
    );
  }

  Widget stackInvoiceButton() {
    final camProv = Provider.of<cameraProvider>(context);
    return Stack(
      children: [
        //align (button 1)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement1,
            //column button 1
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text buss card
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textBussButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //fin padding
                // container button 1
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanCard5",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("businessCard");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/bussinessCard.png",
                    ),
                  ),
                ),
                // fin conatiner button 1
              ],
            ),
            //fin column
          ),
        ),
        //fin  align (button 1)
        //align (button 2)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            //column button 2
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text passport
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textPassButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 2
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanPass5",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setPassportCamera(true);
                        camProv.setInvoiceCamera(false);
                        camProv.setCurrentState("passport");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/passportCard.png",
                      width: 90,
                      height: 33,
                    ),
                  ),
                ),
                // fin container button 2
              ],
            ),
            //fin column
          ),
        ),
        //fin align (button 2)
        // align (button 3)
        Padding(
          padding: EdgeInsets.only(
              left: _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true
                  ? 85
                  : 0),
          child: Align(
            alignment: _alignement2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // padding text invoice
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textInvoiceButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button 3
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanInvoice5",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setInvoiceCamera(true);
                        camProv.setPassportCamera(false);
                        camProv.setCurrentState("invoice");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        _FloatButtonInvoicePressed =
                            !_FloatButtonInvoicePressed;
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/invoice.png",
                      width: 90,
                      height: 58,
                    ),
                  ),
                ),
                // fin container button 3
              ],
            ),
          ),
        ),
        // fin align (button 3)
        //align (button 4)
        Padding(
          padding: EdgeInsets.only(
              right: _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true
                  ? 10
                  : 0),
          child: Align(
            alignment: _alignement3,
            //column button 4
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //padding text id doc
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    _textIdButton,
                    style: TextStyle(
                        color: _currentState == "scanId" ||
                                _currentState == "scanPass" ||
                                _currentState == "scanCard" ||
                                _currentState == "scanInvoice"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // fin padding
                // conatiner button
                Container(
                  width: 65,
                  height: 65,
                  child: FloatingActionButton(
                    heroTag: "btnScanId5",
                    // color click
                    splashColor: Colors.transparent,
                    //
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2.5)),
                    backgroundColor: const Color(0xff41B072),
                    onPressed: () {
                      setState(() {
                        camProv.setGenericState(false);
                        camProv.setInvoiceCamera(false);
                        camProv.setPassportCamera(false);
                        camProv.setCurrentState("idDocument");
                        camProv.setImagePath("");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      });
                    },
                    child: Image.asset(
                      "assets/idCard.png",
                      width: 90,
                      height: 23,
                    ),
                  ),
                ),
                //fin conatiner button 4
              ],
            ),
            //fin  column
          ),
        ),
        // fin align button 4
        //float button align
        Align(
          alignment: Alignment.bottomCenter,
          //padding of folat button
          child: Padding(
            padding: _FloatButtonInvoicePressed &&
                        camProv.getGenericState() == false ||
                    _FloatButtonInvoicePressed &&
                        camProv.getGenericState() == true
                ? const EdgeInsets.only(bottom: 20)
                : const EdgeInsets.all(0),
            child: Container(
              // with and height of float button
              width: _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true
                  ? 50
                  : 65,
              height: _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == false ||
                      _FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true
                  ? 50
                  : 65,
              //fin
              child: FloatingActionButton(
                elevation: 0,
                heroTag: "btnScanFile5",
                // color click
                splashColor: Colors.transparent,
                //Fin
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 2.5)),
                backgroundColor: const Color(0xff41B072),
                onPressed: () async {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    _FloatButtonPressed = false;
                    _FloatButtonIdPressed = false;
                    _FloatButtonPassPressed = false;
                    _FloatButtonCardPressed = false;
                    _FloatButtonInvoicePressed = !_FloatButtonInvoicePressed;
                    setState(() {
                      if (_FloatButtonInvoicePressed &&
                          camProv.getGenericState() == false) {
                        camProv.setUploadPath("");
                        camProv.cameraState(true);
                        camProv.setGenericState(true);
                        _FloatButtonInvoicePressed = false;
                      } else if (_FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true) {
                        _textBussButton = "business card";
                        _textPassButton = "Passport";
                        _textIdButton = "id document";
                        _textInvoiceButton = "Invoice";
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _textBussButton = _textPassButton =
                            _textIdButton = _textInvoiceButton = "";
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed to connect to host",
                        backgroundColor: Colors.grey);
                  }
                },
                // icon
                child: _FloatButtonInvoicePressed &&
                            camProv.getGenericState() == false ||
                        _FloatButtonInvoicePressed &&
                            camProv.getGenericState() == true
                    ? const Icon(
                        Icons.close,
                        size: 40,
                      )
                    : Image.asset(
                        "assets/invoice.png",
                        width: 90,
                        height: 58,
                      ),
                // fin
              ),
            ),
          ),
          //fin padding
        ),
        // fin float  button align
      ],
    );
  }

  Widget homeScreen() {
    final filesProv = Provider.of<filesProvider>(context);
    final camProv = Provider.of<cameraProvider>(context);
    String? savedName = filesProv.getSaveName();
    String? ImageUploadedPath = camProv.getPathUploadImage();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          width: 375,
          height: 812,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                  indicatorColor: Colors.transparent,
                  controller: _tabController,
                  labelColor: const Color(0xff41B072),
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: 43,
                        width: 140,
                        decoration: const BoxDecoration(
                            color: Color(0xff41B072),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Tab(
                          child: Text(
                            "Favorite files",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        height: 43,
                        width: 140,
                        foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: const Border(
                                bottom: BorderSide(color: Color(0xff41B072)),
                                top: BorderSide(color: Color(0xff41B072)),
                                left: BorderSide(color: Color(0xff41B072)),
                                right: BorderSide(color: Color(0xff41B072)))),
                        child: const Tab(
                          child: Text(
                            "All files",
                            style: TextStyle(color: Color(0xff41B072)),
                          ),
                        ),
                      ),
                    )
                  ]),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyScrollBehavior(),
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: [
                      SliverFillRemaining(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            //favorite file
                            Stack(children: [
                              Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "All Result()",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff4A4A4A),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isDismissible: false,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xffF8FBFA),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  child: ScrollConfiguration(
                                                    behavior:
                                                        MyScrollBehavior(),
                                                    child:
                                                        SingleChildScrollView(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ListTile(
                                                            leading: IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            title: const Center(
                                                              child: Text(
                                                                "Filter",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            trailing:
                                                                TextButton(
                                                              style: const ButtonStyle(
                                                                  splashFactory:
                                                                      NoSplash
                                                                          .splashFactory),
                                                              child: const Text(
                                                                "Clear all",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  checkboxValue1 =
                                                                      checkboxValue2 =
                                                                          checkboxValue3 =
                                                                              checkboxValue4 = false;
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Row(
                                                            children: const [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            15,
                                                                        bottom:
                                                                            5,
                                                                        top:
                                                                            20),
                                                                child: Text(
                                                                  "Document type",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxValue1,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxValue1 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Id document"),
                                                                ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxValue2,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxValue2 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Business card"),
                                                                ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxValue3,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxValue3 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Passport"),
                                                                ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxValue4,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxValue4 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Invoice"),
                                                                ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.expand_more,
                                        color: Color(0xff4A4A4A),
                                      ),
                                      style: const ButtonStyle(
                                          overlayColor:
                                              MaterialStatePropertyAll(
                                                  Colors.transparent)),
                                      label: const Text(
                                        "Filtred by",
                                        style: TextStyle(
                                          color: Color(0xff4A4A4A),
                                          fontSize: 10,
                                        ),
                                      ),
                                    )
                                  ]),
                              Padding(
                                padding: const EdgeInsets.only(top: 35),
                                // refresh indicator
                                child: SmartRefresher(
                                  header: const WaterDropMaterialHeader(
                                    backgroundColor: Color(0xff41B072),
                                    color: Colors.white,
                                  ),
                                  controller: _refreshControllerFavoriteFilles,
                                  onRefresh: () {
                                    fetchData();
                                    _onRefreshFavoriteFiles();
                                  },
                                  onLoading: _onLoadingFavoriteFiles,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    itemCount: 15,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 36, right: 37, top: 10),
                                        child: InkWell(
                                          overlayColor:
                                              const MaterialStatePropertyAll(
                                                  Colors.transparent),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      const Color(0xffF8FBFA),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: []),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black,
                                                      // blurRadius: 1,
                                                      spreadRadius: 0.5)
                                                ],
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15),
                                                    topLeft:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15)),
                                                color: Color(0xffFFFFFF)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                IconButton(
                                                    splashRadius: 0.1,
                                                    onPressed: () {},
                                                    icon: Image.asset(
                                                      "assets/FileHomeIcon.png",
                                                      width: 16.46,
                                                      height: 20.25,
                                                    )),
                                                // if (savedName != null)
                                                Expanded(
                                                  child: ListTile(
                                                    title: Text(
                                                      " savedName",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff4A4A4A),
                                                      ),
                                                    ),
                                                    subtitle: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text("type"),
                                                          time == 0
                                                              ? const Text(
                                                                  "now")
                                                              : Text(
                                                                  "$time m ago")
                                                        ]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ]),
                            // all files
                            Stack(children: [
                              Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "All Result()",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff4A4A4A),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isDismissible: false,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xffF8FBFA),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  child: ScrollConfiguration(
                                                    behavior:
                                                        MyScrollBehavior(),
                                                    child:
                                                        SingleChildScrollView(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ListTile(
                                                            leading: IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            title: const Center(
                                                              child: Text(
                                                                "Filter",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            trailing:
                                                                TextButton(
                                                              style: const ButtonStyle(
                                                                  splashFactory:
                                                                      NoSplash
                                                                          .splashFactory),
                                                              child: const Text(
                                                                "Clear all",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  checkboxAllFiles1 =
                                                                      checkboxAllFiles2 =
                                                                          checkboxAllFiles3 =
                                                                              checkboxAllFiles4 = false;
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Row(
                                                            children: const [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            15,
                                                                        bottom:
                                                                            5,
                                                                        top:
                                                                            20),
                                                                child: Text(
                                                                  "Document type",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxAllFiles1,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxAllFiles1 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Id document"),
                                                                ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxAllFiles2,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxAllFiles2 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Business card"),
                                                                ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxAllFiles3,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxAllFiles3 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Passport"),
                                                                ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: Row(
                                                                children: [
                                                                  FormField(
                                                                    builder:
                                                                        (state) {
                                                                      return Checkbox(
                                                                        activeColor:
                                                                            const Color(0xff41B072),
                                                                        value:
                                                                            checkboxAllFiles4,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            checkboxAllFiles4 =
                                                                                value!;
                                                                            state.didChange(value);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                      "Invoice"),
                                                                ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.expand_more,
                                        color: Color(0xff4A4A4A),
                                      ),
                                      style: const ButtonStyle(
                                          overlayColor:
                                              MaterialStatePropertyAll(
                                                  Colors.transparent)),
                                      label: const Text(
                                        "Filtred by",
                                        style: TextStyle(
                                          color: Color(0xff4A4A4A),
                                          fontSize: 10,
                                        ),
                                      ),
                                    )
                                  ]),
                              Padding(
                                padding: const EdgeInsets.only(top: 35),
                                // refresh indicator
                                child: SmartRefresher(
                                  header: const WaterDropMaterialHeader(
                                    backgroundColor: Color(0xff41B072),
                                    color: Colors.white,
                                  ),
                                  controller: _refreshControllerAllFiles,
                                  onLoading: _onLoadingAllFiles,
                                  onRefresh: _onRefreshAllFiles,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 36, right: 37, top: 10),
                                        child: InkWell(
                                          overlayColor:
                                              const MaterialStatePropertyAll(
                                                  Colors.transparent),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      const Color(0xffF8FBFA),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: []),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black,
                                                      spreadRadius: 0.5)
                                                ],
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                color: Color(0xffFFFFFF)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                IconButton(
                                                    splashRadius: 0.1,
                                                    onPressed: () {},
                                                    icon: Image.asset(
                                                      "assets/FileHomeIcon.png",
                                                      width: 16.46,
                                                      height: 20.25,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SCROLL GLOW EFFECT
class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
