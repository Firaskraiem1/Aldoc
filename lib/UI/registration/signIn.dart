// ignore_for_file: library_private_types_in_public_api

import 'package:aldoc/UI/Home.dart';
import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/forget_password.dart';
import 'package:aldoc/UI/registration/header_widget.dart';
import 'package:aldoc/UI/registration/signUp.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:aldoc/provider/authProvider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _headerHeight = 300; //250
  final Key _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool iSobscurePassword = true;
  final Language _language = Language();
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

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<authProvider>(context);
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
                                  child: TextField(
                                    textAlign: _language.getLanguage() == "AR"
                                        ? TextAlign.end
                                        : TextAlign.start,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            _language.tLoginEmail(),
                                            _language.tLoginEmailMessage(),
                                            Icons.email),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextField(
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
                                      label: Align(
                                          alignment:
                                              _language.getLanguage() == "AR"
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child:
                                              Text(_language.tLoginPassword())),
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      hintText:
                                          _language.tLoginPasswordMessage(),
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
                                    child: _isLoading
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
                                      setState(() {
                                        authProv.setLoginState(true);
                                        _isLoading = true;
                                      });
                                      await Future.delayed(
                                        const Duration(seconds: 4),
                                        () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Home(),
                                              ));
                                        },
                                      );
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
