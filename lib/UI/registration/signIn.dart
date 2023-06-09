// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, override_on_non_overriding_member

import 'dart:convert';

import 'package:aldoc/UI/Home.dart';
import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/forget_password.dart';
import 'package:aldoc/UI/registration/header_widget.dart';
import 'package:aldoc/UI/registration/signUp.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _headerHeight = 300; //250
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool iSobscurePassword = true;
  final Language _language = Language();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  RequestClass requestClass = RequestClass();
  Map<String, dynamic>? input;
  Map<String, dynamic>? transformedData;
  String? jsonString;
  String? encrypt;
  String? loginResponseToken;
  String? loginResponseRefreshToken;
  final prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    setState(
      () => _language.getLanguage(),
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

  setInfo(
      String userId,
      String? token,
      String? refresh_token,
      String? f,
      String? l,
      String? e,
      String? o,
      bool? state,
      String? p,
      String? apikey) async {
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", userId);
      prefs.setString("token", token);
      prefs.setString("refresh_token", refresh_token!);
      prefs.setString("firstName", f!);
      prefs.setString("lastName", l!);
      prefs.setString("email", e!);
      prefs.setString("organization", o!);
      prefs.setBool("loginState", state!);
      prefs.setString("password", p!);
      prefs.setString("apiKey", apikey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authProv = Provider.of<authProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF8FBFA),
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
              ),
              SafeArea(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Column(
                      children: [
                        Text(
                          _language.tLoginHello(),
                          style: const TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _language.tLoginMessage(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30.0),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return _language.tLoginEmailMessage();
                                      } else if (!RegExp(
                                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                          .hasMatch(val)) {
                                        return _language
                                            .tLoginEmailErrorMessage();
                                      }
                                      return null;
                                    },
                                    controller: _email,
                                    textAlign: _language.getLanguage() == "AR"
                                        ? TextAlign.end
                                        : TextAlign.start,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            _language.tLoginEmail(),
                                            Icons.email),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return _language
                                            .tLoginPasswordMessage();
                                      }
                                      return null;
                                    },
                                    controller: _password,
                                    textAlign: _language.getLanguage() == "AR"
                                        ? TextAlign.end
                                        : TextAlign.start,
                                    obscureText: iSobscurePassword,
                                    decoration: InputDecoration(
                                      suffixIconColor: Colors.grey,
                                      suffixIcon:
                                          _language.getLanguage() != "AR"
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      iSobscurePassword =
                                                          !iSobscurePassword;
                                                    });
                                                  },
                                                  icon: iSobscurePassword
                                                      ? const Icon(
                                                          Icons.key_off,
                                                          color: Colors.grey,
                                                        )
                                                      : const Icon(
                                                          Icons.key,
                                                          color: Colors.grey,
                                                        ))
                                              : null,
                                      prefixIcon:
                                          _language.getLanguage() == "AR"
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      iSobscurePassword =
                                                          !iSobscurePassword;
                                                    });
                                                  },
                                                  icon: iSobscurePassword
                                                      ? const Icon(
                                                          Icons.key_off,
                                                          color: Colors.grey,
                                                        )
                                                      : const Icon(
                                                          Icons.key,
                                                          color: Colors.grey,
                                                        ))
                                              : null,
                                      hintText: _language.tLoginPassword(),
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade400)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordPage(),
                                          ));
                                    },
                                    child: Text(
                                      _language.tLoginForgotPassword(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 175,
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: _isLoading == true
                                        ? LoadingAnimationWidget.inkDrop(
                                            color: Colors.white, size: 30)
                                        : Text(
                                            _language
                                                .tLoginButton()
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                    onPressed: () async {
                                      var connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();
                                      if (connectivityResult ==
                                              ConnectivityResult.mobile ||
                                          connectivityResult ==
                                              ConnectivityResult.wifi) {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          input = ({
                                            'password':
                                                _password.text.toString(),
                                            'email': _email.text.toString(),
                                          });
                                          transformedData = {};
                                          input!.forEach((key, value) {
                                            transformedData![key] =
                                                value.toString();
                                          });
                                          jsonString =
                                              jsonEncode(transformedData);
                                          encrypt = requestClass
                                              .encryptRegisterInput(jsonString);
                                          requestClass
                                              .loginPostRequest(encrypt)
                                              .then((value) {
                                            loginResponseToken = requestClass
                                                .loginResponseBody();
                                            loginResponseRefreshToken = requestClass
                                                .loginResponseBodyRefreshToken();
                                            // if (loginResponseToken != null) {

                                            requestClass
                                                .getUser(loginResponseToken,
                                                    _email.text.toString())
                                                .whenComplete(
                                              () {
                                                debugPrint(
                                                    "user id5555:${requestClass.getUserId()}");
                                                requestClass
                                                    .getUserInformations(
                                                        loginResponseToken,
                                                        requestClass
                                                            .getUserId())
                                                    .whenComplete(
                                                  () {
                                                    setInfo(
                                                        requestClass
                                                            .getUserId()
                                                            .toString(),
                                                        loginResponseToken,
                                                        loginResponseRefreshToken,
                                                        requestClass
                                                            .getFirstName(),
                                                        requestClass
                                                            .getlastName(),
                                                        requestClass.getEmail(),
                                                        requestClass
                                                            .getOrganization(),
                                                        true,
                                                        requestClass
                                                            .getPassword(),
                                                        requestClass
                                                            .getApiKey());
                                                    if (requestClass
                                                                .loginResponseStatus() ==
                                                            200 &&
                                                        requestClass
                                                                .userInfoStatus() ==
                                                            200) {
                                                      Fluttertoast.showToast(
                                                          msg: _language
                                                              .tLoginSuccesMsg(),
                                                          backgroundColor:
                                                              Colors.grey);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Home(
                                                                    favoriteProductList: []),
                                                          ));
                                                    } else {
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      Fluttertoast.showToast(
                                                          msg: _language
                                                              .tErrorMsg(),
                                                          backgroundColor:
                                                              Colors.grey);
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: _language.tCaptureError(),
                                            backgroundColor: Colors.grey);
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  child: _language.getLanguage() == "AR"
                                      ? Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: _language
                                                  .tLoginHaveAccount()),
                                          TextSpan(
                                            text: _language.tLoginCreate(),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RegistrationPage()));
                                              },
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff41B072)),
                                          ),
                                        ]))
                                      : Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: _language
                                                  .tLoginHaveAccount()),
                                          TextSpan(
                                            text: _language.tLoginCreate(),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RegistrationPage()));
                                              },
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff41B072)),
                                          ),
                                        ])),
                                ),
                                Text(_language.tLoginOrText()),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 15, 10, 20),
                                  child: _language.getLanguage() == "AR"
                                      ? Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: _language.tLoginStartDemo(),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setInfo("", "", "", "", "", "",
                                                    "", false, "", "");
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home(
                                                              favoriteProductList: [],
                                                            )));
                                              },
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff41B072)),
                                          ),
                                        ]))
                                      : Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: _language.tLoginStartDemo(),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setInfo("", "", "", "", "", "",
                                                    "", false, "", "");
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home(
                                                              favoriteProductList: [],
                                                            )));
                                              },
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff41B072)),
                                          ),
                                        ])),
                                )
                              ],
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// scroll glow effect
class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
