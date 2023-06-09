// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_local_variable, override_on_non_overriding_member, prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:aldoc/UI/CameraScreen.dart';
import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/UI/UploadScreen.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/UI/showDocument.dart';
import 'package:aldoc/provider/Language.dart';

import 'package:aldoc/provider/cameraProvider.dart';
import 'package:aldoc/provider/filesProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  List<dynamic>? favoriteProductList;
  Home({super.key, required this.favoriteProductList});

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
  Alignment _alignement1 = Alignment.centerLeft;
  Alignment _alignement2 = Alignment.topCenter;
  Alignment _alignement3 = Alignment.centerRight;
  final Language _language = Language();
  String? userId;
  String? token;
  String? firstName;
  String? lastName;
  String? email;
  String? organization;
  String? password;
  String? apiKey;
  bool? loginState;
  String? username;
  String? imageProfilPath;

////
////methodes

  @override
  void initState() {
    super.initState();
    setState(
      () => _language.getLanguage(),
    );
    SharedPreferences.getInstance().then(
      (value) {
        setState(() {
          token = value.getString("token");
          firstName = value.getString("firstName");
          lastName = value.getString("lastName");
          loginState = value.getBool("loginState");
          username = value.getString("username");
          imageProfilPath = value.getString("imageProfilPath");
          userId = value.getString("userId");
        });
      },
    ).whenComplete(
      () {
        readProducts(5, "");
        lastIndex = 5;
      },
    );
    _loading1 = _loading2 = false;
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
  bool showLanguageDemoPage = false;
  bool showLanguageProfilPage = false;
  RequestClass requestClass = RequestClass();

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        imageProfilPath = upload_image!.path;
        prefs.setString("imageProfilPath", upload_image!.path);
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
      //  _currentState == "home" ||
      //         _currentState == "uploadFile" &&
      drawer: loginState == false || loginState == null
          ? ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: Drawer(
                //Color(0xff41B072)
                backgroundColor: const Color(0xffF8FBFA),
                child: ListView(
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/aldoc.png"))),
                        child: null,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ));
                        },
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Icon(
                            Icons.login,
                            color: Colors.black,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerLogin(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            showLanguageDemoPage = !showLanguageDemoPage;
                          });
                        },
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: showLanguageDemoPage
                              ? const Icon(
                                  Icons.arrow_drop_up_sharp,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.black,
                                ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerLanguage(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      showLanguageDemoPage
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50),
                                    child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return Colors.transparent;
                                            },
                                          ),
                                        ),
                                        onPressed: () async {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          pref.setString('language', "AR");
                                          _language.setLanguage("AR");
                                          setState(() {
                                            showLanguageDemoPage = false;
                                          });
                                        },
                                        child: const Text(
                                          "AR",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50),
                                    child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return Colors.transparent;
                                            },
                                          ),
                                        ),
                                        onPressed: () async {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          pref.setString('language', "FR");
                                          _language.setLanguage("FR");
                                          setState(() {
                                            showLanguageDemoPage = false;
                                          });
                                        },
                                        child: const Text(
                                          "FR",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50),
                                    child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return Colors.transparent;
                                            },
                                          ),
                                        ),
                                        onPressed: () async {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          pref.setString('language', "EN");
                                          _language.setLanguage("EN");
                                          setState(() {
                                            showLanguageDemoPage = false;
                                          });
                                        },
                                        child: const Text(
                                          "EN",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ),
                                ])
                          : const SizedBox(),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _currentState = "UnderConstruction";
                          });
                        },
                        leading: const Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Icon(
                              Icons.edit_note,
                              color: Colors.black,
                            )),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerContact(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Icon(
                            Icons.info,
                            color: Colors.black,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerAbout(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
              ),
            )
          : ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: Drawer(
                //Color(0xff41B072)
                backgroundColor: const Color(0xffF8FBFA),
                child: ListView(
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/aldoc.png"))),
                        child: null,
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _currentState = "Analytics";
                          });
                        },
                        leading: const Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Icon(
                              Icons.analytics,
                              color: Colors.black,
                            )),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerAnalytics(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _currentState = "UnderConstruction";
                          });
                        },
                        leading: const Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Icon(
                              Icons.notifications,
                              color: Colors.black,
                            )),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerNotifications(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _currentState = "UnderConstruction";
                          });
                        },
                        leading: const Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.black,
                            )),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerPayment(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _currentState = "UnderConstruction";
                          });
                        },
                        leading: const Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Icon(
                              Icons.edit_note,
                              color: Colors.black,
                            )),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            _language.tDrawerContact(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
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
    final camProv = Provider.of<cameraProvider>(context);
    String? currentState = camProv.getCurrentState();
    // bool loginState = authProv.getLoginState();
    if (_currentState != "scanId" &&
            _currentState != "scanCard" &&
            _currentState != "scanPass" &&
            _currentState != "scanInvoice" &&
            currentState != "uploadFile" &&
            loginState == false ||
        loginState == null) {
      return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListTile(
            leading: IconButton(
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
                                    // _textBussButton = _textPassButton =
                                    //     _textIdButton = _textInvoiceButton = "";
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
                              // _textBussButton = _textPassButton =
                              //     _textIdButton = _textInvoiceButton = "";

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
    String? currentState = camProv.getCurrentState();
    if (removeAppBar == false && currentState != "uploadFile") {
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
                        builder: (context) => Home(favoriteProductList: []),
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
  String updatedText = "";
  void updateText(String t) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      updatedText = t;
      username = updatedText;
      prefs.setString("username", updatedText);
    });
  }

  getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    firstName = prefs.getString("firstName");
    lastName = prefs.getString("lastName");
    email = prefs.getString("email");
    organization = prefs.getString("organization");
    password = prefs.getString("password");
    apiKey = prefs.getString("apiKey");
  }

  setInfo(String userId, String? token, String? f, String? l, String? e,
      String? o, bool? state, String? p, String? apikey) async {
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", userId);
      prefs.setString("token", token);
      prefs.setString("firstName", f!);
      prefs.setString("lastName", l!);
      prefs.setString("email", e!);
      prefs.setString("organization", o!);
      prefs.setBool("loginState", state!);
      prefs.setString("password", p!);
      prefs.setString("apiKey", apikey!);
    }
  }

  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _newFirstName = TextEditingController();
  final TextEditingController _newLastName = TextEditingController();
  Map<String, dynamic>? input;
  Map<String, dynamic>? transformedData;
  String? jsonString;
  String? encrypt;
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool iSobscureOldPassword = true;
  bool iSobscureNewPassword = true;
  bool iSobscureConfirmPassword = true;
  bool editFirstName = false;
  bool editLastName = false;

  PreferredSizeWidget loginAppBar() {
    final TextEditingController _usernameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final _formKey1 = GlobalKey<FormState>();
    final _formKeyFirstName = GlobalKey<FormState>();
    final _formKeyLastName = GlobalKey<FormState>();
    getSharedPref();
    return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 10),
              child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: Image.asset("assets/drawer.png"),
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 20),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              showLanguageProfilPage
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  showLanguageProfilPage = false;
                                  _language.setLanguage("EN");
                                });
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setString('language', "EN");
                              },
                              child: const Text("EN")),
                        ),
                        const Text("|"),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  showLanguageProfilPage = false;
                                  _language.setLanguage("FR");
                                });
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setString('language', "FR");
                              },
                              child: const Text("FR")),
                        ),
                        const Text("|"),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 10),
                          child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  showLanguageProfilPage = false;
                                  _language.setLanguage("AR");
                                });
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setString('language', "AR");
                              },
                              child: const Text("AR")),
                        ),
                        const Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        )
                      ],
                    )
                  : const SizedBox(),
              IconButton(
                  onPressed: () {
                    setState(() {
                      showLanguageProfilPage = !showLanguageProfilPage;
                    });
                  },
                  icon: const Icon(Icons.language)),
              const SizedBox(
                width: 20,
              ),
              CircleAvatar(
                //size
                radius: 26.5,
                backgroundImage:
                    imageProfilPath != "" && imageProfilPath != null
                        ? FileImage(File(imageProfilPath!))
                        : null,
                foregroundImage:
                    imageProfilPath == "" || imageProfilPath == null
                        ? const AssetImage("assets/profilImag.png")
                        : null,
                foregroundColor: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return FormField(
                          builder: (state1) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xffF8FBFA),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  child: ScrollConfiguration(
                                    behavior: MyScrollBehavior(),
                                    child: SingleChildScrollView(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundImage:
                                                  imageProfilPath != "" &&
                                                          imageProfilPath !=
                                                              null
                                                      ? FileImage(File(
                                                          imageProfilPath!))
                                                      : null,
                                              foregroundImage: imageProfilPath ==
                                                          "" ||
                                                      imageProfilPath == null
                                                  ? const AssetImage(
                                                      "assets/profilImag.png")
                                                  : null,
                                              foregroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, bottom: 40),
                                            child: Center(
                                                child: Text(
                                              username == ""
                                                  ? firstName.toString()
                                                  : username.toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            )),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                _language.getLanguage() == "AR"
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  onTap: () {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffF3F3F3),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            content:
                                                                ScrollConfiguration(
                                                              behavior:
                                                                  MyScrollBehavior(),
                                                              child: SingleChildScrollView(
                                                                  child:
                                                                      FormField(
                                                                builder:
                                                                    (state) {
                                                                  return Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            _language.tProfilUserInformation(),
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 20),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            ListTile(
                                                                              leading: const Icon(Icons.person),
                                                                              title: Text(_language.tRegisterFirstName()),
                                                                              subtitle: editFirstName
                                                                                  ? Form(
                                                                                      key: _formKeyFirstName,
                                                                                      child: Theme(
                                                                                        data: ThemeData(
                                                                                          inputDecorationTheme: const InputDecorationTheme(
                                                                                            focusedBorder: UnderlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        child: TextFormField(
                                                                                          textAlign: _language.getLanguage() == "AR" ? TextAlign.end : TextAlign.start,
                                                                                          controller: _newFirstName,
                                                                                        ),
                                                                                      ))
                                                                                  : Text(firstName!),
                                                                              trailing: IconButton(
                                                                                  onPressed: () {
                                                                                    editFirstName = !editFirstName;
                                                                                    state.didChange(editFirstName);
                                                                                  },
                                                                                  icon: const Icon(Icons.edit)),
                                                                            ),
                                                                            ListTile(
                                                                                leading: const Icon(Icons.person),
                                                                                title: Text(_language.tRegisterLastName()),
                                                                                subtitle: editLastName
                                                                                    ? Form(
                                                                                        key: _formKeyLastName,
                                                                                        child: Theme(
                                                                                          data: ThemeData(
                                                                                            inputDecorationTheme: const InputDecorationTheme(
                                                                                              focusedBorder: UnderlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Colors.black,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          child: TextFormField(
                                                                                            textAlign: _language.getLanguage() == "AR" ? TextAlign.end : TextAlign.start,
                                                                                            controller: _newLastName,
                                                                                          ),
                                                                                        ))
                                                                                    : Text(lastName!),
                                                                                trailing: IconButton(
                                                                                    onPressed: () {
                                                                                      editLastName = !editLastName;
                                                                                      state.didChange(editLastName);
                                                                                    },
                                                                                    icon: const Icon(Icons.edit))),
                                                                            ListTile(
                                                                              leading: const Icon(Icons.email),
                                                                              title: Text(_language.tLoginEmail()),
                                                                              subtitle: Text(email!),
                                                                            ),
                                                                            ListTile(
                                                                              leading: const Icon(Icons.corporate_fare),
                                                                              title: Text(_language.tRegisterOrganization()),
                                                                              subtitle: Text(organization!),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          editFirstName || editLastName
                                                                              ? Padding(
                                                                                  padding: const EdgeInsets.only(left: 10, right: 40, top: 20),
                                                                                  child: Container(
                                                                                    width: 80,
                                                                                    height: 45,
                                                                                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), color: Color(0xffFFFFFF)),
                                                                                    child: TextButton(
                                                                                        onPressed: () {
                                                                                          editFirstName = editLastName = false;
                                                                                          state.didChange(editFirstName);
                                                                                          state.didChange(editLastName);
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          _language.tProfilButtonCancel(),
                                                                                          style: const TextStyle(color: Colors.black),
                                                                                        )),
                                                                                  ),
                                                                                )
                                                                              : const SizedBox(),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 10, top: 20),
                                                                            child:
                                                                                Container(
                                                                              width: 90,
                                                                              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), color: Color(0xff41B072)),
                                                                              child: TextButton(
                                                                                  onPressed: () async {
                                                                                    var connectivityResult = await Connectivity().checkConnectivity();
                                                                                    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                                                                                      if (editFirstName && editLastName) {
                                                                                        setState(() {
                                                                                          _isLoading1 = true;
                                                                                          state.didChange(_isLoading1);
                                                                                        });
                                                                                        requestClass.updateUserInformations(token, password!, email, _newFirstName.text, _newLastName.text, organization, userId, apiKey).whenComplete(
                                                                                          () {
                                                                                            if (requestClass.updateUserInfoResponseStatus() == 200) {
                                                                                              requestClass.getUserInformations(token, userId).whenComplete(
                                                                                                () {
                                                                                                  setInfo(userId!, token, _newFirstName.text, _newLastName.text, requestClass.getEmail(), requestClass.getOrganization(), true, requestClass.getPassword(), requestClass.getApiKey());
                                                                                                  if (requestClass.userInfoStatus() == 200) {
                                                                                                    setState(() {
                                                                                                      _isLoading1 = false;
                                                                                                      state.didChange(_isLoading1);
                                                                                                    });
                                                                                                    Navigator.pop(context);
                                                                                                    editFirstName = editLastName = false;
                                                                                                    state.didChange(editFirstName);
                                                                                                    state.didChange(editLastName);
                                                                                                    Fluttertoast.showToast(msg: _language.tUpdateInfoSuccesMsg(), backgroundColor: Colors.grey);
                                                                                                  } else {
                                                                                                    setState(() {
                                                                                                      _isLoading1 = false;
                                                                                                    });
                                                                                                    state.didChange(_isLoading1);
                                                                                                    Fluttertoast.showToast(msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
                                                                                                  }
                                                                                                },
                                                                                              );
                                                                                            } else {
                                                                                              setState(() {
                                                                                                _isLoading1 = false;
                                                                                              });
                                                                                              state.didChange(_isLoading1);
                                                                                            }
                                                                                          },
                                                                                        );
                                                                                      } else if (editFirstName) {
                                                                                        setState(() {
                                                                                          _isLoading1 = true;
                                                                                          state.didChange(_isLoading1);
                                                                                        });
                                                                                        requestClass.updateUserInformations(token, password!, email, _newFirstName.text, lastName, organization, userId, apiKey).whenComplete(
                                                                                          () {
                                                                                            if (requestClass.updateUserInfoResponseStatus() == 200) {
                                                                                              requestClass.getUserInformations(token, userId).whenComplete(
                                                                                                () {
                                                                                                  setInfo(userId!, token, _newFirstName.text, lastName, requestClass.getEmail(), requestClass.getOrganization(), true, requestClass.getPassword(), requestClass.getApiKey());
                                                                                                  if (requestClass.userInfoStatus() == 200) {
                                                                                                    setState(() {
                                                                                                      _isLoading1 = false;
                                                                                                      state.didChange(_isLoading1);
                                                                                                    });
                                                                                                    Navigator.pop(context);
                                                                                                    editFirstName = editLastName = false;
                                                                                                    state.didChange(editFirstName);
                                                                                                    state.didChange(editLastName);
                                                                                                    firstName = _newFirstName.text;
                                                                                                    state1.didChange(firstName);
                                                                                                    Fluttertoast.showToast(msg: _language.tUpdateInfoSuccesMsg(), backgroundColor: Colors.grey);
                                                                                                  } else {
                                                                                                    setState(() {
                                                                                                      _isLoading1 = false;
                                                                                                    });
                                                                                                    state.didChange(_isLoading1);
                                                                                                    Fluttertoast.showToast(msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
                                                                                                  }
                                                                                                },
                                                                                              );
                                                                                            } else {
                                                                                              setState(() {
                                                                                                _isLoading1 = false;
                                                                                              });
                                                                                              state.didChange(_isLoading1);
                                                                                            }
                                                                                          },
                                                                                        );
                                                                                      } else if (editLastName) {
                                                                                        setState(() {
                                                                                          _isLoading1 = true;
                                                                                          state.didChange(_isLoading1);
                                                                                        });
                                                                                        requestClass.updateUserInformations(token, password!, email, firstName, _newLastName.text, organization, userId, apiKey).whenComplete(
                                                                                          () {
                                                                                            if (requestClass.updateUserInfoResponseStatus() == 200) {
                                                                                              requestClass.getUserInformations(token, userId).whenComplete(
                                                                                                () {
                                                                                                  setInfo(userId!, token, firstName, _newLastName.text, requestClass.getEmail(), requestClass.getOrganization(), true, requestClass.getPassword(), requestClass.getApiKey());
                                                                                                  if (requestClass.userInfoStatus() == 200) {
                                                                                                    setState(() {
                                                                                                      _isLoading1 = false;
                                                                                                      state.didChange(_isLoading1);
                                                                                                    });
                                                                                                    Navigator.pop(context);
                                                                                                    editFirstName = editLastName = false;
                                                                                                    state.didChange(editFirstName);
                                                                                                    state.didChange(editLastName);
                                                                                                    Fluttertoast.showToast(msg: _language.tUpdateInfoSuccesMsg(), backgroundColor: Colors.grey);
                                                                                                  } else {
                                                                                                    setState(() {
                                                                                                      _isLoading1 = false;
                                                                                                    });
                                                                                                    state.didChange(_isLoading1);
                                                                                                    Fluttertoast.showToast(msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
                                                                                                  }
                                                                                                },
                                                                                              );
                                                                                            } else {
                                                                                              setState(() {
                                                                                                _isLoading1 = false;
                                                                                              });
                                                                                              state.didChange(_isLoading1);
                                                                                            }
                                                                                          },
                                                                                        );
                                                                                      } else {
                                                                                        setState(() {
                                                                                          _isLoading = false;
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      }
                                                                                    } else {
                                                                                      Fluttertoast.showToast(msg: _language.tCaptureError(), backgroundColor: Colors.grey);
                                                                                    }
                                                                                  },
                                                                                  child: _isLoading1
                                                                                      ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 20)
                                                                                      : Text(
                                                                                          _language.tProfilButtonSave(),
                                                                                          style: const TextStyle(color: Colors.white),
                                                                                        )),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              )),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  trailing: _language
                                                              .getLanguage() ==
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.manage_accounts,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  leading: _language
                                                              .getLanguage() !=
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.manage_accounts,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  title: Align(
                                                    alignment: _language
                                                                .getLanguage() ==
                                                            "AR"
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Text(
                                                      _language
                                                          .tProfilUserInformation(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                _language.getLanguage() == "AR"
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  onTap: () {
                                                    uploadImage().then(
                                                      (value) {
                                                        state1.didChange(
                                                            imageProfilPath);
                                                      },
                                                    );
                                                  },
                                                  trailing: _language
                                                              .getLanguage() ==
                                                          "AR"
                                                      ? const Icon(
                                                          Icons
                                                              .add_photo_alternate,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  leading: _language
                                                              .getLanguage() !=
                                                          "AR"
                                                      ? const Icon(
                                                          Icons
                                                              .add_photo_alternate,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  title: Align(
                                                    alignment: _language
                                                                .getLanguage() ==
                                                            "AR"
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Text(
                                                      _language
                                                          .tProfilEditPhoto(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                _language.getLanguage() == "AR"
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  onTap: () {
                                                    //edit username show dialog
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffF3F3F3),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      _language
                                                                          .tProfilEnterUserName(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  ],
                                                                ),
                                                                Form(
                                                                    key:
                                                                        _formKey,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              25,
                                                                          right:
                                                                              10,
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          TextFormField(
                                                                        textAlign: _language.getLanguage() ==
                                                                                "AR"
                                                                            ? TextAlign.right
                                                                            : TextAlign.left,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          fillColor:
                                                                              Colors.white,
                                                                          filled:
                                                                              true,
                                                                          contentPadding: const EdgeInsets.fromLTRB(
                                                                              20,
                                                                              10,
                                                                              20,
                                                                              10),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: const BorderSide(color: Colors.grey)),
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.grey.shade400)),
                                                                          errorBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                          focusedErrorBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                        ),
                                                                        keyboardType:
                                                                            TextInputType.name,
                                                                        onChanged:
                                                                            updateText,
                                                                        controller:
                                                                            _usernameController,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return _language.tProfilEnterUserName();
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                    )),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              40,
                                                                          top:
                                                                              20),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            80,
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
                                                                              style: const TextStyle(color: Colors.black),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              20),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            90,
                                                                        decoration: const BoxDecoration(
                                                                            borderRadius: BorderRadius.only(
                                                                                topRight: Radius.circular(10),
                                                                                topLeft: Radius.circular(10),
                                                                                bottomLeft: Radius.circular(10),
                                                                                bottomRight: Radius.circular(10)),
                                                                            color: Color(0xff41B072)),
                                                                        child: TextButton(
                                                                            onPressed: () async {
                                                                              if (_formKey.currentState!.validate()) {
                                                                                setState(() {
                                                                                  Navigator.of(context).pop(updatedText);
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Text(
                                                                              _language.tProfilButtonSave(),
                                                                              style: const TextStyle(color: Colors.white),
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
                                                  },
                                                  trailing: _language
                                                              .getLanguage() ==
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  leading: _language
                                                              .getLanguage() !=
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  title: Align(
                                                    alignment: _language
                                                                .getLanguage() ==
                                                            "AR"
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Text(
                                                      _language
                                                          .tProfilEditUsername(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                _language.getLanguage() == "AR"
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  onTap: () async {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 10,
                                                                  sigmaY: 10),
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffF3F3F3),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            content:
                                                                ScrollConfiguration(
                                                              behavior:
                                                                  MyScrollBehavior(),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                          _language
                                                                              .tProfilchangeYourPassword(),
                                                                          style:
                                                                              const TextStyle(fontWeight: FontWeight.bold),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Form(
                                                                        key:
                                                                            _formKey1,
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.only(top: 25, right: 10, left: 10),
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Align(
                                                                                  alignment: _language.getLanguage() == "AR" ? Alignment.centerRight : Alignment.centerLeft,
                                                                                  child: Text(_language.tProfilOldPassword()),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  child: TextFormField(
                                                                                    textAlign: _language.getLanguage() == "AR" ? TextAlign.right : TextAlign.left,
                                                                                    controller: _oldPassword,
                                                                                    obscureText: iSobscureOldPassword,
                                                                                    decoration: InputDecoration(
                                                                                      fillColor: Colors.white,
                                                                                      filled: true,
                                                                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                                                                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                                    ),
                                                                                    onChanged: (value) {},
                                                                                    validator: (value) {
                                                                                      if (value!.isEmpty) {
                                                                                        return _language.tProfilOldPassword();
                                                                                      }
                                                                                      return null;
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: _language.getLanguage() == "AR" ? Alignment.centerRight : Alignment.centerLeft,
                                                                                  child: Text(_language.tProfilNewPassword()),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  child: TextFormField(
                                                                                    textAlign: _language.getLanguage() == "AR" ? TextAlign.right : TextAlign.left,
                                                                                    controller: _newPassword,
                                                                                    obscureText: true,
                                                                                    decoration: InputDecoration(
                                                                                      fillColor: Colors.white,
                                                                                      filled: true,
                                                                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                                                                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                                    ),
                                                                                    onChanged: (value) {},
                                                                                    validator: (value) {
                                                                                      if (value!.isEmpty) {
                                                                                        return _language.tProfilNewPassword();
                                                                                      }
                                                                                      return null;
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: _language.getLanguage() == "AR" ? Alignment.centerRight : Alignment.centerLeft,
                                                                                  child: Text(_language.tProfilConfirmNewPassword()),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                                  child: TextFormField(
                                                                                    textAlign: _language.getLanguage() == "AR" ? TextAlign.right : TextAlign.left,
                                                                                    controller: _confirmPassword,
                                                                                    obscureText: true,
                                                                                    decoration: InputDecoration(
                                                                                      fillColor: Colors.white,
                                                                                      filled: true,
                                                                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                                                                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                                                                    ),
                                                                                    onChanged: (value) {},
                                                                                    validator: (value) {
                                                                                      if (value!.isEmpty) {
                                                                                        return _language.tProfilConfirmNewPassword();
                                                                                      } else if (_confirmPassword.text != _newPassword.text) {
                                                                                        return _language.tRegisterConfirmPasswordErrorMessage();
                                                                                      }
                                                                                      return null;
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ))),
                                                                    FormField(
                                                                      builder:
                                                                          (state) {
                                                                        return Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 40, top: 20),
                                                                              child: Container(
                                                                                width: 80,
                                                                                height: 45,
                                                                                decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), color: Color(0xffFFFFFF)),
                                                                                child: TextButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                      setState(() {
                                                                                        _newPassword.text = _oldPassword.text = _confirmPassword.text = "";
                                                                                      });
                                                                                    },
                                                                                    child: Text(
                                                                                      _language.tProfilButtonCancel(),
                                                                                      style: const TextStyle(color: Colors.black),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 10, top: 20),
                                                                              child: Container(
                                                                                width: 90,
                                                                                height: 45,
                                                                                decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), color: Color(0xff41B072)),
                                                                                child: _isLoading
                                                                                    ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 20)
                                                                                    : TextButton(
                                                                                        onPressed: () async {
                                                                                          var connectivityResult = await Connectivity().checkConnectivity();
                                                                                          if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                                                                                            if (_formKey1.currentState!.validate()) {
                                                                                              setState(() {
                                                                                                _isLoading = true;
                                                                                                state.didChange(_isLoading);
                                                                                              });
                                                                                              input = ({
                                                                                                'old_password': _oldPassword.text.toString(),
                                                                                                'new_password': _newPassword.text.toString(),
                                                                                              });
                                                                                              transformedData = {};
                                                                                              input!.forEach((key, value) {
                                                                                                transformedData![key] = value.toString();
                                                                                              });
                                                                                              jsonString = jsonEncode(transformedData);
                                                                                              encrypt = requestClass.encryptRegisterInput(jsonString);
                                                                                              requestClass.updatePasswordRequest(token, userId, encrypt).whenComplete(
                                                                                                () {
                                                                                                  if (requestClass.updatePwdResponseStatus() == 200) {
                                                                                                    Fluttertoast.showToast(msg: _language.tProfilUpdatePwdSuccesMsg(), backgroundColor: Colors.grey);
                                                                                                    Navigator.of(context).pop();
                                                                                                    setState(() {
                                                                                                      _isLoading = false;
                                                                                                      _oldPassword.text = _newPassword.text = _confirmPassword.text = "";
                                                                                                      state.didChange(_isLoading);
                                                                                                    });
                                                                                                  } else {
                                                                                                    setState(() {
                                                                                                      _isLoading = false;
                                                                                                      state.didChange(_isLoading);
                                                                                                    });
                                                                                                    Fluttertoast.showToast(msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
                                                                                                  }
                                                                                                },
                                                                                              );
                                                                                            } else {
                                                                                              setState(() {
                                                                                                _isLoading = false;
                                                                                                state.didChange(_isLoading);
                                                                                              });
                                                                                            }
                                                                                          } else {
                                                                                            Fluttertoast.showToast(msg: _language.tCaptureError(), backgroundColor: Colors.grey);
                                                                                          }
                                                                                        },
                                                                                        child: Text(
                                                                                          _language.tProfilButtonSave(),
                                                                                          style: const TextStyle(color: Colors.white),
                                                                                        )),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  trailing: _language
                                                              .getLanguage() ==
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.password,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  leading: _language
                                                              .getLanguage() !=
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.password,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  title: Align(
                                                    alignment: _language
                                                                .getLanguage() ==
                                                            "AR"
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Text(
                                                      _language
                                                          .tProfilEditPassword(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                _language.getLanguage() == "AR"
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  onTap: () async {
                                                    // authProv.setLoginState(false);
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.setString(
                                                        "token", "");
                                                    prefs.setString(
                                                        "firstName", "");
                                                    prefs.setString(
                                                        "lastName", "");
                                                    prefs.setString(
                                                        "email", "");
                                                    prefs.setString(
                                                        "organization", "");
                                                    prefs.setBool(
                                                        "loginState", false);
                                                    prefs.setString(
                                                        "username", "");
                                                    prefs.setString(
                                                        "imageProfilPath", "");
                                                    tasksId.clear();
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Home(
                                                                  favoriteProductList: []),
                                                        ));
                                                  },
                                                  trailing: _language
                                                              .getLanguage() ==
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.logout,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  leading: _language
                                                              .getLanguage() !=
                                                          "AR"
                                                      ? const Icon(
                                                          Icons.logout,
                                                          color: Colors.black,
                                                        )
                                                      : null,
                                                  title: Align(
                                                    alignment: _language
                                                                .getLanguage() ==
                                                            "AR"
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Text(
                                                      _language.tProfilLogout(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          },
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

  Widget? body() {
    final camProv = Provider.of<cameraProvider>(context);
    if (_currentState == "home" && loginState == true) {
      return homeScreen();
    } else if (_currentState == "uploadFile") {
      return const UploadScreen();
    } else if (_currentState == "scanId" ||
        _currentState == "scanCard" ||
        _currentState == "scanPass" ||
        _currentState == "scanInvoice") {
      return const CameraScreen();
    } else if (_currentState == "Analytics") {
      return Analytics();
    } else if (_currentState == "UnderConstruction") {
      return UnderConstruction();
    }

    return demoPage();
  }

  Widget demoPage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "     DOCUMENT DIGITIZATION \nAND INFORMATION EXTRACTION",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Image.asset(
            "assets/ocr_demo.png",
            width: 250,
            height: 150,
          ),
          const SizedBox(
              height: 200,
              width: 200,
              child: RiveAnimation.asset("assets/uparrows.riv"))
        ],
      ),
    );
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
    final filesProv = Provider.of<filesProvider>(context);
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
                    _FloatButtonPressed
                        ? _language.tHomeFilterBusinessCard()
                        : "",
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
                SizedBox(
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
                        camProv.setImagePath("");
                        // filesProv.setResponse("");
                        camProv.setCurrentState("businessCard");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonPressed ? _language.tHomeFilterPassport() : "",
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
                SizedBox(
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
                        // filesProv.setResponse("");
                        camProv.setCurrentState("passport");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonPressed ? _language.tHomeFilterInvoice() : "",
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
                SizedBox(
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
                        // filesProv.setResponse("");
                        camProv.setCurrentState("invoice");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonPressed
                        ? _language.tHomeFilterIdDocument()
                        : "",
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
                SizedBox(
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
                        camProv.setImagePath("");
                        // filesProv.setResponse("");
                        camProv.setCurrentState("idDocument");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
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
    final filesProv = Provider.of<filesProvider>(context);
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
                    _FloatButtonIdPressed
                        ? _language.tHomeFilterBusinessCard()
                        : "",
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
                SizedBox(
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
                        // filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonIdPressed
                        ? _language.tHomeFilterPassport()
                        : "",
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
                SizedBox(
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
                        //  filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonIdPressed ? _language.tHomeFilterInvoice() : "",
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
                SizedBox(
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
                        //   filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonIdPressed
                        ? _language.tHomeFilterIdDocument()
                        : "",
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
                SizedBox(
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
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
            child: SizedBox(
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
                        filesProv.setResponse("");
                        filesProv.setResponseState(false);
                        _FloatButtonIdPressed = false;
                      } else if (_FloatButtonIdPressed &&
                          camProv.getGenericState() == true) {
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: _language.tCaptureError(),
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
    final filesProv = Provider.of<filesProvider>(context);
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
                    _FloatButtonPassPressed
                        ? _language.tHomeFilterBusinessCard()
                        : "",
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
                        //   filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonPassPressed
                        ? _language.tHomeFilterPassport()
                        : "",
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
                        // filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        // _textBottomBar = "Scan Pass";
                        _FloatButtonPassPressed = !_FloatButtonPassPressed;
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonPassPressed
                        ? _language.tHomeFilterInvoice()
                        : "",
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
                        //   filesProv.setResponse("");
                        camProv.setCurrentState("invoice");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonPassPressed
                        ? _language.tHomeFilterIdDocument()
                        : "",
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
                        //  filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                        filesProv.setResponseState(false);
                        filesProv.setResponse("");
                        camProv.setGenericState(true);
                        _FloatButtonPassPressed = false;
                      } else if (_FloatButtonPassPressed &&
                          camProv.getGenericState() == true) {
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: _language.tCaptureError(),
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
    final filesProv = Provider.of<filesProvider>(context);
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
                    _FloatButtonCardPressed
                        ? _language.tHomeFilterBusinessCard()
                        : "",
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
                        //     filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        _FloatButtonCardPressed = !_FloatButtonCardPressed;
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonCardPressed
                        ? _language.tHomeFilterPassport()
                        : "",
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
                        //  filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonCardPressed
                        ? _language.tHomeFilterInvoice()
                        : "",
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
                        //filesProv.setResponse("");
                        camProv.setCurrentState("invoice");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonCardPressed
                        ? _language.tHomeFilterIdDocument()
                        : "",
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
                        //  filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                        filesProv.setResponse("");
                        filesProv.setResponseState(false);
                        _FloatButtonCardPressed = false;
                      } else if (_FloatButtonCardPressed &&
                          camProv.getGenericState() == true) {
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: _language.tCaptureError(),
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
    final filesProv = Provider.of<filesProvider>(context);
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
                    _FloatButtonInvoicePressed
                        ? _language.tHomeFilterBusinessCard()
                        : "",
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
                        // filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanCard";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonInvoicePressed
                        ? _language.tHomeFilterPassport()
                        : "",
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
                        //   filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanPass";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonInvoicePressed
                        ? _language.tHomeFilterInvoice()
                        : "",
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
                        //     filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanInvoice";
                        _FloatButtonInvoicePressed =
                            !_FloatButtonInvoicePressed;
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                    _FloatButtonInvoicePressed
                        ? _language.tHomeFilterIdDocument()
                        : "",
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
                        // filesProv.setResponse("");
                        camProv.removeAppBar(false);
                        _currentState = "scanId";
                        // _textBussButton = _textPassButton =
                        //     _textIdButton = _textInvoiceButton = "";
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
                        filesProv.setResponse("");
                        filesProv.setResponseState(false);
                        camProv.setGenericState(true);
                        _FloatButtonInvoicePressed = false;
                      } else if (_FloatButtonInvoicePressed &&
                          camProv.getGenericState() == true) {
                        _alignement1 = Alignment.centerLeft;
                        _alignement2 = Alignment.topCenter;
                        _alignement3 = Alignment.centerRight;
                      } else {
                        _alignement1 = _alignement2 =
                            _alignement3 = Alignment.bottomCenter;
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: _language.tCaptureError(),
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

  String? productsResponse;
  Map<String, dynamic>? productsData;
  List<dynamic>? productList;

  int? productCount;

  readproductsConnectedUser() {
    try {
      productsResponse = requestClass.getProductsResponseBody();
      if (productsResponse != null &&
          productsResponse != "" &&
          requestClass.getProductsStatus() != 401) {
        productsData = jsonDecode(productsResponse!);
        productList = productsData!['product_list'];
        productCount = productsData!['product_count'];
      }
    } on Exception {
      Fluttertoast.showToast(
          msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
    }
  }

  Map<String, dynamic>? data;

  String? postResponse;
  String? extractResultResponse;
  String? imagePath;
  Map<String, dynamic>? data1;
  String? p;
  String? getResponse;
  Future<void> readDocument(
      String? taskId, String? userToken, String? id) async {
    requestClass.userConnectedExtractResult(taskId, userToken).whenComplete(
      () async {
        extractResultResponse = requestClass.extractResultResponseBody();
        if (extractResultResponse != null &&
            requestClass.extractResultResponseStatus() == 200) {
          data1 = await jsonDecode(extractResultResponse!);
          p = data1!["document"]["Preprocessed_file_id"].toString();
          requestClass
              .getImageConnectedUserRequest(p, id, userToken)
              .whenComplete(
            () {
              getResponse = requestClass.getUserConnectedImageResponseBody();
              if (getResponse != null &&
                  requestClass.postConnectedResponseStatus() != 500) {
                // camProv.setImagePath(getResponse!);
                // filesProv.setResponse(extractResultResponse);
                // filesProv.setResponseState(true);
                // filesProv.setResponseStatus(
                //     requestClass.postConnectedResponseStatus());
                imagePath = getResponse!;
                // debugPrint(
                //     "${camProv.getPathUploadImage()}+${filesProv.getResponse()}+ ${filesProv.getResponseState()}");
              }
            },
          );
        }
      },
    );
  }

  readProducts(int? pages, String? skillId) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      requestClass.getProducts(token, userId, pages, skillId).whenComplete(
        () async {
          if (requestClass.productsResponseBody != null &&
              requestClass.productStatus == 200) {
            await readproductsConnectedUser();
          } else if (requestClass.productStatus == 401) {
            Fluttertoast.showToast(
                msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
          }
        },
      ).whenComplete(() {
        setState(() {
          _loading1 = true;
          _loading2 = true;
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: _language.tCaptureError(), backgroundColor: Colors.grey);
    }
  }

  bool _loading1 = false;
  bool _loading2 = false;
  int? lastIndex;
  String? skillId;
  List<String> tasksId = [];

  Widget homeScreen() {
    final filesProv = Provider.of<filesProvider>(context);
    final camProv = Provider.of<cameraProvider>(context);
    String? savedName = filesProv.getSaveName();
    String? ImageUploadedPath = camProv.getPathUploadImage();

    List<dynamic>? favoritesDocuments = filesProv.getFavoriteList();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
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
                        child: Tab(
                          child: Text(
                            _language.tHomeFavoriteFiles(),
                            style: const TextStyle(color: Colors.white),
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
                        child: Tab(
                          child: Text(
                            _language.tHomeAllFiles(),
                            style: const TextStyle(color: Color(0xff41B072)),
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
                                    Text(
                                      "${_language.tHomeAllResult()}(${favoritesDocuments!.length})",
                                      style: const TextStyle(
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
                                                            title: Center(
                                                              child: Text(
                                                                _language
                                                                    .tHomeFilter(),
                                                                style: const TextStyle(
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
                                                              child: Text(
                                                                _language
                                                                    .tHomeFilterClearAll(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                                                            mainAxisAlignment: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? MainAxisAlignment
                                                                    .end
                                                                : MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15,
                                                                        bottom:
                                                                            5,
                                                                        top: 20,
                                                                        right:
                                                                            15),
                                                                child: Text(
                                                                  _language
                                                                      .tHomeFilterDocumentType(),
                                                                  style: const TextStyle(
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
                                                              left: 7,
                                                            ),
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterIdDocument()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue1,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue1 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue1,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue1 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterIdDocument()),
                                                                      ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 7,
                                                            ),
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterBusinessCard()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue2,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue2 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue2,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue2 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterBusinessCard()),
                                                                      ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 7,
                                                            ),
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterPassport()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue3,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue3 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue3,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue3 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterPassport()),
                                                                      ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterInvoice()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue4,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue4 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxValue4,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  checkboxValue4 = value!;
                                                                                  state.didChange(value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterInvoice()),
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
                                      label: Text(
                                        _language.tHomeFiltredBy(),
                                        style: const TextStyle(
                                            color: Color(0xff4A4A4A),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
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
                                    _onRefreshFavoriteFiles();
                                  },
                                  onLoading: _onLoadingFavoriteFiles,
                                  child: _loading1 && favoritesDocuments != null
                                      ? ListView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 40),
                                          itemCount:
                                              favoritesDocuments.isNotEmpty
                                                  ? favoritesDocuments.length
                                                  : 1,
                                          itemBuilder: (context, index) {
                                            if (favoritesDocuments.isNotEmpty) {
                                              var product =
                                                  favoritesDocuments[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 36,
                                                    right: 37,
                                                    top: 10),
                                                child: InkWell(
                                                  overlayColor:
                                                      const MaterialStatePropertyAll(
                                                          Colors.transparent),
                                                  onTap: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              showDocument(
                                                            index: null,
                                                            favoriteState: true,
                                                            userId: userId,
                                                            taskId:
                                                                favoritesDocuments[
                                                                        index]
                                                                    ['task_id'],
                                                            userToken: token,
                                                            dateCreation:
                                                                favoritesDocuments[
                                                                        index][
                                                                    'created_at'],
                                                            fileName:
                                                                favoritesDocuments[
                                                                        index][
                                                                    'file_name'],
                                                            fileSize:
                                                                favoritesDocuments[
                                                                        index][
                                                                    'file_size'],
                                                          ),
                                                        ));
                                                  },
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.black,
                                                              // blurRadius: 1,
                                                              spreadRadius: 0.5)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        15),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        15)),
                                                        color:
                                                            Color(0xffFFFFFF)),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        IconButton(
                                                            splashRadius: 0.1,
                                                            onPressed: () {},
                                                            icon: Image.asset(
                                                              "assets/FileHomeIcon.png",
                                                              width: 16.46,
                                                              height: 20.25,
                                                            )),
                                                        Expanded(
                                                          child: ListTile(
                                                            title: Text(
                                                              product[
                                                                  'file_name'],
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xff4A4A4A),
                                                              ),
                                                            ),
                                                            subtitle: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "document\nSize:${product['file_size']}"),
                                                                  Text(
                                                                      "${product['created_at']}\n  Transcribed"),
                                                                ]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30),
                                                child: ListTile(
                                                    title: Center(
                                                  child: Text(_language
                                                      .tHomeNofilesToDisplayMsg()),
                                                )),
                                              );
                                            }
                                          },
                                        )
                                      : LoadingAnimationWidget.hexagonDots(
                                          color: Colors.black, size: 40),
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
                                    Text(
                                      "${_language.tHomeAllResult()}(${lastIndex!})",
                                      style: const TextStyle(
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
                                                            title: Center(
                                                              child: Text(
                                                                _language
                                                                    .tHomeFilter(),
                                                                style: const TextStyle(
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
                                                              child: Text(
                                                                _language
                                                                    .tHomeFilterClearAll(),
                                                                style: const TextStyle(
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
                                                                  tasksId
                                                                      .clear();
                                                                  _loading2 =
                                                                      false;
                                                                  skillId = "";
                                                                  lastIndex = 5;
                                                                  Navigator.pop(
                                                                      context);
                                                                  readProducts(
                                                                      lastIndex!,
                                                                      "");
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? MainAxisAlignment
                                                                    .end
                                                                : MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15,
                                                                        bottom:
                                                                            5,
                                                                        top: 20,
                                                                        right:
                                                                            15),
                                                                child: Text(
                                                                  _language
                                                                      .tHomeFilterDocumentType(),
                                                                  style: const TextStyle(
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
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterIdDocument()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles1,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles2 || checkboxAllFiles3 || checkboxAllFiles4) {
                                                                                    checkboxAllFiles1 = false;
                                                                                    state.didChange(checkboxAllFiles1);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles1 = !checkboxAllFiles1;
                                                                                    state.didChange(checkboxAllFiles1);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Identity_Card_Arabic_Medium_DTR_document_0.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles1,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles2 || checkboxAllFiles3 || checkboxAllFiles4) {
                                                                                    checkboxAllFiles1 = false;
                                                                                    state.didChange(checkboxAllFiles1);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles1 = !checkboxAllFiles1;
                                                                                    state.didChange(checkboxAllFiles1);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Identity_Card_Arabic_Medium_DTR_document_0.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterIdDocument()),
                                                                      ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterBusinessCard()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles2,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles1 || checkboxAllFiles3 || checkboxAllFiles4) {
                                                                                    checkboxAllFiles2 = false;
                                                                                    state.didChange(checkboxAllFiles2);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles2 = !checkboxAllFiles2;
                                                                                    state.didChange(checkboxAllFiles2);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Business_Card_Multilingual_Medium_DTR_document_1.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles2,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles1 || checkboxAllFiles3 || checkboxAllFiles4) {
                                                                                    checkboxAllFiles2 = false;
                                                                                    state.didChange(checkboxAllFiles2);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles2 = !checkboxAllFiles2;
                                                                                    state.didChange(checkboxAllFiles2);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Business_Card_Multilingual_Medium_DTR_document_1.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterBusinessCard()),
                                                                      ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterPassport()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles3,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles1 || checkboxAllFiles2 || checkboxAllFiles4) {
                                                                                    checkboxAllFiles3 = false;
                                                                                    state.didChange(checkboxAllFiles3);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles3 = !checkboxAllFiles3;
                                                                                    state.didChange(checkboxAllFiles3);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Libyan_Passport_Arabic_English_Medium_DTR_document_0.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles3,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles1 || checkboxAllFiles2 || checkboxAllFiles4) {
                                                                                    checkboxAllFiles3 = false;
                                                                                    state.didChange(checkboxAllFiles3);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles3 = !checkboxAllFiles3;
                                                                                    state.didChange(checkboxAllFiles3);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Libyan_Passport_Arabic_English_Medium_DTR_document_0.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterPassport()),
                                                                      ]),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 7),
                                                            child: _language
                                                                        .getLanguage() ==
                                                                    "AR"
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                        Text(_language
                                                                            .tHomeFilterInvoice()),
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles4,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles1 || checkboxAllFiles2 || checkboxAllFiles3) {
                                                                                    checkboxAllFiles4 = false;
                                                                                    state.didChange(checkboxAllFiles4);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles4 = !checkboxAllFiles4;
                                                                                    state.didChange(checkboxAllFiles4);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Invoice_French_Medium_DTR_document_0.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ])
                                                                : Row(
                                                                    children: [
                                                                        FormField(
                                                                          builder:
                                                                              (state) {
                                                                            return Checkbox(
                                                                              activeColor: const Color(0xff41B072),
                                                                              value: checkboxAllFiles4,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  if (checkboxAllFiles1 || checkboxAllFiles2 || checkboxAllFiles3) {
                                                                                    checkboxAllFiles4 = false;
                                                                                    state.didChange(checkboxAllFiles4);
                                                                                    setState(() {
                                                                                      _loading2 = false;
                                                                                      skillId = "";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                  } else {
                                                                                    checkboxAllFiles4 = !checkboxAllFiles4;
                                                                                    state.didChange(checkboxAllFiles4);
                                                                                    setState(() {
                                                                                      tasksId.clear();
                                                                                      _loading2 = false;
                                                                                      skillId = "Invoice_French_Medium_DTR_document_0.1";
                                                                                      lastIndex = 5;
                                                                                    });
                                                                                    readProducts(lastIndex, skillId);
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Text(_language
                                                                            .tHomeFilterInvoice()),
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
                                      label: Text(
                                        _language.tHomeFiltredBy(),
                                        style: const TextStyle(
                                            color: Color(0xff4A4A4A),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
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
                                  onRefresh: () {
                                    _onRefreshAllFiles();
                                    print("length:${productCount!}");
                                    if (productCount! > 5) {
                                      if (productCount! % 5 == 0 &&
                                          lastIndex! < productCount!) {
                                        setState(() {
                                          lastIndex = lastIndex! + 5;
                                        });
                                        print(lastIndex);
                                      } else {
                                        var reste = productCount! % 5;
                                        print("reste:$reste");
                                        if (lastIndex! <
                                            productCount! - reste) {
                                          setState(() {
                                            lastIndex = lastIndex! + 5;
                                          });
                                        } else {
                                          if (lastIndex != productCount!) {
                                            setState(() {
                                              lastIndex = lastIndex! + reste;
                                            });
                                          }
                                        }
                                      }
                                    } else {
                                      lastIndex = productCount;
                                    }
                                    if (skillId == "" || skillId == null) {
                                      print("lastIndex:$lastIndex");
                                      readProducts(lastIndex!, "");
                                    } else {
                                      readProducts(lastIndex!, skillId);
                                    }
                                  },
                                  child: _loading2 && productList != null
                                      ? ListView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 60),
                                          itemCount: productList!.isNotEmpty
                                              ? productList!.length
                                              : 1,
                                          itemBuilder: (context, index) {
                                            if (productList!.isNotEmpty) {
                                              var product = productList![index];
                                              if (!tasksId
                                                  .contains(product['id'])) {
                                                tasksId.add(product['id']);
                                              }
                                              // print(tasksId.length);
                                              // print(tasksId);

                                              String dateTimeString =
                                                  product['created_at'];
                                              DateTime dateTime =
                                                  DateTime.parse(
                                                      dateTimeString);
                                              String formattedDate =
                                                  '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 36,
                                                    right: 37,
                                                    top: 10),
                                                child: InkWell(
                                                  overlayColor:
                                                      const MaterialStatePropertyAll(
                                                          Colors.transparent),
                                                  onTap: () async {
                                                    print(
                                                        'taskId:${tasksId[index]}');
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              showDocument(
                                                            index: index,
                                                            favoriteState:
                                                                false,
                                                            userId: userId,
                                                            taskId:
                                                                tasksId[index],
                                                            userToken: token,
                                                            dateCreation:
                                                                formattedDate,
                                                            fileName: product[
                                                                'file_name'],
                                                            fileSize: product[
                                                                'file_size'],
                                                          ),
                                                        ));
                                                  },
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.black,
                                                              spreadRadius: 0.5)
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        color:
                                                            Color(0xffFFFFFF)),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        IconButton(
                                                            splashRadius: 0.1,
                                                            onPressed: () {},
                                                            icon: Image.asset(
                                                              "assets/FileHomeIcon.png",
                                                              width: 16.46,
                                                              height: 20.25,
                                                            )),
                                                        Expanded(
                                                          child: ListTile(
                                                            title: Text(
                                                              product[
                                                                  'file_name'],
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xff4A4A4A),
                                                              ),
                                                            ),
                                                            subtitle: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "${product['task_model_type']}\nSize:${product['file_size']}"),
                                                                  Text(
                                                                      "$formattedDate\n  ${product['status']}"),
                                                                ]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30),
                                                child: ListTile(
                                                    title: Center(
                                                  child: Text(_language
                                                      .tHomeNofilesToDisplayMsg()),
                                                )),
                                              );
                                            }
                                          },
                                        )
                                      : LoadingAnimationWidget.hexagonDots(
                                          color: Colors.black, size: 40),
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

  Widget Analytics() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width - 30,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Color(0xffF3F3F3)),
              child: ListTile(
                title: Align(
                    alignment: _language.getLanguage() == "AR"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(_language.tDrawerAnalyticsText1())),
                subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: _language.getLanguage() == "AR"
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "350",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              size: 20,
                              color: Color(0xff41B072),
                            ),
                            const Text(
                              " 3.48 %  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff41B072)),
                            ),
                            Text(
                              _language.tDrawerAnalyticsText2(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ]),
                trailing: _language.getLanguage() != "AR"
                    ? const Icon(Icons.bar_chart,
                        size: 35, color: Color(0xffF5365C))
                    : null,
                leading: _language.getLanguage() == "AR"
                    ? const Icon(Icons.bar_chart,
                        size: 35, color: Color(0xffF5365C))
                    : null,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Color(0xffF3F3F3)),
                child: ListTile(
                  title: Align(
                      alignment: _language.getLanguage() == "AR"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(_language.tDrawerAnalyticsText3())),
                  subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: _language.getLanguage() == "AR"
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "2300",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_downward,
                                size: 20,
                                color: Color(0xff41B072),
                              ),
                              const Text(
                                " 3.48 %  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff41B072)),
                              ),
                              Text(
                                _language.tDrawerAnalyticsText4(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ]),
                  trailing: _language.getLanguage() != "AR"
                      ? const Icon(
                          Icons.pie_chart,
                          size: 35,
                          color: Color(0xffFB6340),
                        )
                      : null,
                  leading: _language.getLanguage() == "AR"
                      ? const Icon(
                          Icons.pie_chart,
                          size: 35,
                          color: Color(0xffFB6340),
                        )
                      : null,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Color(0xffF3F3F3)),
                child: ListTile(
                  title: Align(
                      alignment: _language.getLanguage() == "AR"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(_language.tDrawerAnalyticsText5())),
                  subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: _language.getLanguage() == "AR"
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "924",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_upward,
                                size: 20,
                                color: Color(0xff41B072),
                              ),
                              const Text(
                                " 1.10 %  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff41B072)),
                              ),
                              Text(
                                _language.tDrawerAnalyticsText6(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ]),
                  trailing: _language.getLanguage() != "AR"
                      ? const Icon(
                          Icons.groups_2,
                          size: 35,
                          color: Color(0xffFFD600),
                        )
                      : null,
                  leading: _language.getLanguage() == "AR"
                      ? const Icon(
                          Icons.groups_2,
                          size: 35,
                          color: Color(0xffFFD600),
                        )
                      : null,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Color(0xffF3F3F3)),
                child: ListTile(
                  title: Align(
                      alignment: _language.getLanguage() == "AR"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(_language.tDrawerAnalyticsText7())),
                  subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: _language.getLanguage() == "AR"
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "49,65%",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_upward,
                                size: 20,
                                color: Color(0xff41B072),
                              ),
                              const Text(
                                " 12 %  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff41B072)),
                              ),
                              Text(
                                _language.tDrawerAnalyticsText2(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ]),
                  trailing: _language.getLanguage() != "AR"
                      ? const Icon(
                          Icons.percent,
                          size: 35,
                          color: Color(0xff11CDEF),
                        )
                      : null,
                  leading: _language.getLanguage() == "AR"
                      ? const Icon(
                          Icons.percent,
                          size: 35,
                          color: Color(0xff11CDEF),
                        )
                      : null,
                )),
          ),
        ]),
      ),
    );
  }

  Widget UnderConstruction() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "assets/under-construction.png",
          width: 200,
        ),
        Text(
          _language.tUnderConstructionText(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ]),
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
