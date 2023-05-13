// ignore_for_file: override_on_non_overriding_member, no_leading_underscores_for_local_identifiers

import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/header_widget.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNewPassword extends StatefulWidget {
  const AddNewPassword({super.key});

  @override
  State<AddNewPassword> createState() => _AddNewPasswordState();
}

class _AddNewPasswordState extends State<AddNewPassword> {
  bool iSobscureNewPassword = true;
  bool iSobscureConfirmPassword = true;
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
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: const Color(0xffF8FBFA),
        body: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                  child:
                      HeaderWidget(_headerHeight, true, Icons.password_rounded),
                ),
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: _language.getLanguage() == "AR"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  _language.tLoginForgotPassword(),
                                  style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  // textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: _language.getLanguage() == "AR"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  _language.tAddNewPasswordMessage1(),
                                  style: const TextStyle(
                                      // fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  // textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  textAlign: _language.getLanguage() == "AR"
                                      ? TextAlign.end
                                      : TextAlign.start,
                                  obscureText: iSobscureNewPassword,
                                  decoration: InputDecoration(
                                    suffixIconColor: Colors.grey,
                                    suffixIcon: _language.getLanguage() != "AR"
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                iSobscureNewPassword =
                                                    !iSobscureNewPassword;
                                              });
                                            },
                                            icon: iSobscureNewPassword
                                                ? const Icon(
                                                    Icons.key_off,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.key,
                                                    color: Colors.grey,
                                                  ))
                                        : null,
                                    prefixIcon: _language.getLanguage() == "AR"
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                iSobscureNewPassword =
                                                    !iSobscureNewPassword;
                                              });
                                            },
                                            icon: iSobscureNewPassword
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
                                        _language.tAddNewPasswordMessage1(),
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
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return _language
                                          .tAddNewPasswordMessage1();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  textAlign: _language.getLanguage() == "AR"
                                      ? TextAlign.end
                                      : TextAlign.start,
                                  obscureText: iSobscureConfirmPassword,
                                  decoration: InputDecoration(
                                    suffixIconColor: Colors.grey,
                                    suffixIcon: _language.getLanguage() != "AR"
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                iSobscureConfirmPassword =
                                                    !iSobscureConfirmPassword;
                                              });
                                            },
                                            icon: iSobscureConfirmPassword
                                                ? const Icon(
                                                    Icons.key_off,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.key,
                                                    color: Colors.grey,
                                                  ))
                                        : null,
                                    prefixIcon: _language.getLanguage() == "AR"
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                iSobscureConfirmPassword =
                                                    !iSobscureConfirmPassword;
                                              });
                                            },
                                            icon: iSobscureConfirmPassword
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
                                        child: Text(_language
                                            .tRegisterConfirmPassword())),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    hintText:
                                        _language.tAddNewPasswordMessage1(),
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
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return _language
                                          .tAddNewPasswordMessage1();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 60.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      _language
                                          .tForgorPasswordButton()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
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
