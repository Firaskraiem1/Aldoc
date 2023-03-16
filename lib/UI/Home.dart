import 'dart:ui';
import 'package:aldoc/UI/CameraScreen.dart';
import 'package:aldoc/UI/UploadScreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

////variables
// ignore: non_constant_identifier_names
bool _FloatButtonPressed = false;
String _currentState = "";
late String _textBussButton;
late String _textPassButton;
late String _textIdButton;
late String _textBottomBar;

class _HomeState extends State<Home> {
////declaration
  Alignment _alignement1 = Alignment.centerLeft;
  Alignment _alignement2 = Alignment.topCenter;
  Alignment _alignement3 = Alignment.centerRight;
////
////methodes
  @override
  void initState() {
    super.initState();
    _textBottomBar = "Scan file";
    _textBussButton = "";
    _textPassButton = "";
    _textIdButton = "";

    _alignement1 = Alignment.bottomCenter;
    _alignement2 = Alignment.bottomCenter;
    _alignement3 = Alignment.bottomCenter;
  }

////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
//////////////////////////////////////////////////////////////////////////
      // appBar
      appBar: _currentState != "scanId"
          ? AppBar(
              backgroundColor: const Color(0xff151719),
              leading: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.sort_outlined)),
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.notifications)),
                CircleAvatar(
                  backgroundImage: const AssetImage("assets/profil.jpg"),
                  backgroundColor: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      showMenu(
                          context: context,
                          //position
                          position: const RelativeRect.fromLTRB(1, 88, 0, 0),
                          items: [
                            const PopupMenuItem(
                                child: ListTile(
                              leading: Icon(Icons.login),
                              title: Text("Login"),
                            )),
                            const PopupMenuItem(
                                child: ListTile(
                              leading: Icon(Icons.info),
                              title: Text("about"),
                            )),
                          ]);
                    },
                  ),
                ),
              ],
            )
          : cameraAppbar(),
      //Fin appBar
//////////////////////////////////////////////////////////////////////////
      // float action button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(

          //padding container de stack
          padding: const EdgeInsets.only(bottom: 30),
          //conatiner of float action button
          width: 250,
          height: 220, // width and height of container (3 buttons )
          color: Colors.transparent, // color of container (3 buttons )
          child: BackdropFilter(
              // color blur(flou)
              // if pressed= true  => color blur
              filter: _FloatButtonPressed && _currentState == "home"
                  ? ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5)
                  : ImageFilter.blur(),
              //fin
              // widget stack button
              child: stackButton())),
      //fin float action button
//////////////////////////////////////////////////////////////////////////
      // Bootom appBar
      bottomNavigationBar: BottomAppBar(

          // padding bottom appbar
          padding: const EdgeInsets.only(left: 37, right: 37),
          // height of appBar height:

          color: const Color(0xff151719), //color of app bar
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
                    splashRadius: 50.0,
                    padding: const EdgeInsets.only(
                        top: 20), //  padding of icon button
                    onPressed: () {
                      setState(() {
                        _textBottomBar = "Scan file";
                        _currentState = "home";
                      });
                    },
                    icon: const Icon(Icons.home_filled),
                    color: Colors.white,
                  ),
                  // text
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10), // padding of text
                    child: Text("Home", style: TextStyle(color: Colors.white)),
                  )
                  //
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, top: 40), // padding of text
                    child: Text(
                      _textBottomBar,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    splashRadius: 50.0,
                    padding: const EdgeInsets.only(
                        top: 20), // padding of Icon button
                    onPressed: () {
                      setState(() {
                        _currentState = "uploadFile";
                        _textBottomBar = "Scan file";
                      });
                    },
                    icon: const Icon(
                      Icons.file_upload,
                    ),
                    color: _currentState == "uploadFile"
                        ? Colors.green
                        : Colors.white,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10), // padding of text
                    child: Text(
                      "Upload file ",
                      style: TextStyle(
                          color: _currentState == "uploadFile"
                              ? Colors.green
                              : Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )
          // fin row
          ),
      //Fin bootom appBar
//////////////////////////////////////////////////////////////////////////

      body: body(),

//////////////////////////////////////////////////////////////////////////
// background color scaffold screen
      backgroundColor: const Color(0xff151719),
    );
  }

///////////////////////////// widgets//////////////////////////
  Widget body() {
    if (_currentState == "home") {
      return homeScreen();
    } else if (_currentState == "uploadFile") {
      return const UploadScreen();
    } else if (_currentState == "scanId") {
      return const CameraScreen();
    }
    return homeScreen();
  }

  Widget stackButton() {
    return Stack(
      children: [
        //align (button 1)
        Align(
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
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              //fin padding
              // container button 1
              Container(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  // color click
                  splashColor: Colors.transparent,
                  //
                  shape: const CircleBorder(
                      side: BorderSide(color: Colors.white, width: 3)),
                  backgroundColor: const Color(0xff41B072),
                  onPressed: () {
                    setState(() {
                      _currentState = "scanCard";
                      _textBottomBar = "Scan card";
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              // fin conatiner button 1
            ],
          ),
          //fin column
        ),
        //fin  align (button 1)
        //align (button 2)
        Align(
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
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              // fin padding
              // conatiner button 2
              Container(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  // color click
                  splashColor: Colors.transparent,
                  //
                  shape: const CircleBorder(
                      side: BorderSide(color: Colors.white, width: 3)),
                  backgroundColor: const Color(0xff41B072),
                  onPressed: () {
                    setState(() {
                      _currentState = "scanPass";
                      _textBottomBar = "Scan pass";
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              // fin container button 2
            ],
          ),
          //fin column
        ),
        //fin align (button 2)
        //align (button 3)
        Align(
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
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              // fin padding
              // conatiner button
              Container(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  // color click
                  splashColor: Colors.transparent,
                  //
                  shape: const CircleBorder(
                      side: BorderSide(color: Colors.white, width: 3)),
                  backgroundColor: const Color(0xff41B072),
                  onPressed: () {
                    setState(() {
                      _textBottomBar = "Scan id";
                      _currentState = "scanId";
                    });
                    setState(() {
                      _textBussButton = _textPassButton = _textIdButton = "";
                      _alignement1 =
                          _alignement2 = _alignement3 = Alignment.bottomCenter;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              //fin conatiner button
            ],
          ),
          //fin  column
        ),
        // fin align button 3
        //float button align
        Align(
          alignment: Alignment.bottomCenter,
          //padding of folat button
          child: Padding(
            padding: paddingFloatButton(),
            child: Container(
              // with and height of float button
              width: sizeFloatButton(50, 70),
              height: sizeFloatButton(50, 70),
              //fin
              child: FloatingActionButton(
                // color click
                splashColor: Colors.transparent,
                //Fin
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 3)),
                backgroundColor: const Color(0xff41B072),
                onPressed: () {
                  setState(() {
                    _FloatButtonPressed = !_FloatButtonPressed;
                    if (_FloatButtonPressed) {
                      _textBussButton = "busisness Card";
                      _textPassButton = "Passport";
                      _textIdButton = "id document";

                      _alignement1 = Alignment.centerLeft;
                      _alignement2 = Alignment.topCenter;
                      _alignement3 = Alignment.centerRight;
                    } else {
                      _textBussButton = _textPassButton = _textIdButton = "";
                      _alignement1 =
                          _alignement2 = _alignement3 = Alignment.bottomCenter;
                    }
                  }
                      //fin action
                      );
                  // if (_currentState == "scanId" ||
                  //     _currentState == "scanPass" ||
                  //     _currentState == "scanCard") {
                  //   _FloatButtonPressed = false;
                  // } else {
                  //   _FloatButtonPressed = !_FloatButtonPressed;
                  // }
                  //action
                },
                // icon
                child: floatIcon(),

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

  EdgeInsets paddingFloatButton() {
    switch (_FloatButtonPressed) {
      case true:
        {
          if (_currentState == "scanId" ||
              _currentState == "scanPass" ||
              _currentState == "scanCard") {
            return const EdgeInsets.all(0);
          } else {
            return const EdgeInsets.only(bottom: 20);
          }
        }
      default:
        return const EdgeInsets.all(0);
    }
  }

  double sizeFloatButton(double v1, double v2) {
    switch (_FloatButtonPressed) {
      case true:
        {
          if (_currentState == "scanId" ||
              _currentState == "scanPass" ||
              _currentState == "scanCard") {
            return v2;
          } else {
            return v1;
          }
        }
      default:
        return v2;
    }
  }

  Widget floatIcon() {
    switch (_FloatButtonPressed) {
      case true:
        {
          if (_currentState == "scanId") {
            return const Icon(Icons.add, size: 40);
          } else if (_currentState == "scanPass") {
            return const Icon(Icons.add, size: 40);
          } else if (_currentState == "scanCard") {
            return const Icon(Icons.add, size: 40);
          } else if (_currentState == "uploadFile") {
            if (_FloatButtonPressed) {
              return const Icon(Icons.close, size: 40);
            }
            return const Icon(Icons.crop_free, size: 40);
          } else {
            return const Icon(Icons.close, size: 40);
          }
        }
      default:
        return const Icon(Icons.crop_free, size: 40);
    }
  }

  Widget homeScreen() {
    return SingleChildScrollView(
      //padding container
      child: Padding(
        padding: const EdgeInsets.only(top: 23, left: 36, right: 37, bottom: 0),
        // center container
        child: Center(
          child: Container(
            width: 302,
            height: 789,
            child: Column(
              children: const [
                //padding image aldoc.png
                Padding(
                  padding:
                      EdgeInsets.only(top: 123.82, right: 77.49, left: 78.49),
                  child: Image(
                    height: 60.18,
                    width: 146.03,
                    image: AssetImage("assets/aldoc.png"),
                  ),
                ),
                //Fin
                //padding image Text1.png
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 7, left: 9),
                  child: Image(
                    height: 52,
                    width: 286,
                    image: AssetImage("assets/Text1.png"),
                  ),
                ),
                //Fin
                // //padding image Text2.png
                // Padding(
                //   padding: EdgeInsets.only(top: 41, right: 2, left: 7),
                //   child: Image(
                //     height: 114,
                //     width: 293,
                //     image: AssetImage("assets/Text2.png"),
                //   ),
                // ),
                // //Fin
                //padding image ocr.png
                Padding(
                  padding: EdgeInsets.only(
                      top: 35, right: 40.2, left: 61.2, bottom: 48.82),
                  child: Image(
                    height: 202.45,
                    width: 200.6,
                    image: AssetImage("assets/ocr.png"),
                  ),
                ),
                //Fin
              ],
            ),
          ),
        ),
        //fin
      ),
    );
  }

  PreferredSizeWidget cameraAppbar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 100),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 50, left: 8, right: 8),
        child: Stack(children: [
          AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff969390),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: const AssetImage("assets/profil.jpg"),
              backgroundColor: Colors.white,
              child: GestureDetector(
                onTap: () {
                  showMenu(
                      context: context,
                      //position
                      position: const RelativeRect.fromLTRB(0, 77, 0, 0),
                      items: [
                        const PopupMenuItem(
                            child: ListTile(
                          leading: Icon(Icons.login),
                          title: Text("Login"),
                        )),
                        const PopupMenuItem(
                            child: ListTile(
                          leading: Icon(Icons.info),
                          title: Text("about"),
                        )),
                      ]);
                },
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.flash_on),
                padding: const EdgeInsets.only(right: 40),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_circle_down),
                  padding: const EdgeInsets.only(right: 40)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.auto_awesome),
                  padding: const EdgeInsets.only(right: 40)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            ],
          ),
        ]),
      ),
    );
  }
}
