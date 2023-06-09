// ignore_for_file: override_on_non_overriding_member

import 'dart:convert';

import 'package:aldoc/UI/RestImplementation/RequestClass.dart';
import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  bool iSobscureText1 = true;
  bool iSobscureText2 = true;
  final Language _language = Language();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _organization = TextEditingController();
  RequestClass requestClass = RequestClass();
  Map<String, dynamic>? input;
  Map<String, dynamic>? transformedData;
  String? jsonString;
  String? encrypt;
  String? registerResponse;
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

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FBFA),
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(25, 80, 25, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 5, color: Colors.white),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        offset: Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey.shade300,
                                    size: 80.0,
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(70, 70, 0, 0),
                                  child: IconButton(
                                    splashRadius: 0.1,
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Colors.grey.shade700,
                                      size: 25.0,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: _firstName,
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tRegisterFirstName(), Icons.person),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return _language.tRegisterFirstNameMessage();
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: _lastName,
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tRegisterLastName(), Icons.person),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return _language.tRegisterLastNameMessage();
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
                              controller: _email,
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tLoginEmail(), Icons.email),
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return _language.tLoginEmailMessage();
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                    .hasMatch(val)) {
                                  return _language.tLoginEmailErrorMessage();
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
                              controller: _password,
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              obscureText: iSobscureText1,
                              decoration: InputDecoration(
                                suffixIconColor: Colors.grey,
                                suffixIcon: _language.getLanguage() != "AR"
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            iSobscureText1 = !iSobscureText1;
                                          });
                                        },
                                        icon: iSobscureText1
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
                                            iSobscureText1 = !iSobscureText1;
                                          });
                                        },
                                        icon: iSobscureText1
                                            ? const Icon(
                                                Icons.key_off,
                                                color: Colors.grey,
                                              )
                                            : const Icon(
                                                Icons.key,
                                                color: Colors.grey,
                                              ))
                                    : null,
                                // label: Align(
                                //     alignment: _language.getLanguage() == "AR"
                                //         ? Alignment.centerRight
                                //         : Alignment.centerLeft,
                                //     child: Text(_language.tLoginPassword())),
                                // labelStyle:
                                //     const TextStyle(color: Colors.black),
                                hintText: _language.tLoginPassword(),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return _language.tLoginPasswordMessage();
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
                              controller: _confirmPassword,
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              obscureText: iSobscureText2,
                              decoration: InputDecoration(
                                suffixIconColor: Colors.grey,
                                suffixIcon: _language.getLanguage() != "AR"
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            iSobscureText2 = !iSobscureText2;
                                          });
                                        },
                                        icon: iSobscureText2
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
                                            iSobscureText2 = !iSobscureText2;
                                          });
                                        },
                                        icon: iSobscureText2
                                            ? const Icon(
                                                Icons.key_off,
                                                color: Colors.grey,
                                              )
                                            : const Icon(
                                                Icons.key,
                                                color: Colors.grey,
                                              ))
                                    : null,
                                // label: Align(
                                //     alignment: _language.getLanguage() == "AR"
                                //         ? Alignment.centerRight
                                //         : Alignment.centerLeft,
                                //     child: Text(
                                //         _language.tRegisterConfirmPassword())),
                                // labelStyle:
                                //     const TextStyle(color: Colors.black),
                                hintText: _language.tRegisterConfirmPassword(),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return _language
                                      .tRegisterConfirmPasswordMessage();
                                } else if (_confirmPassword.text !=
                                    _password.text) {
                                  return _language
                                      .tRegisterConfirmPasswordErrorMessage();
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: _organization,
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tRegisterOrganization(),
                                  Icons.corporate_fare),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return _language
                                      .tRegisterOrganizationMessage();
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          FormField<bool>(
                            builder: (state) {
                              return Column(
                                children: <Widget>[
                                  _language.getLanguage() == "AR"
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              _language.tRegisterConditions(),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            Checkbox(
                                                activeColor:
                                                    const Color(0xff41B072),
                                                value: checkboxValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    checkboxValue = value!;
                                                    state.didChange(value);
                                                  });
                                                }),
                                          ],
                                        )
                                      : Row(
                                          children: <Widget>[
                                            Checkbox(
                                                activeColor:
                                                    const Color(0xff41B072),
                                                value: checkboxValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    checkboxValue = value!;
                                                    state.didChange(value);
                                                  });
                                                }),
                                            Text(
                                              _language.tRegisterConditions(),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                  Container(
                                    alignment: _language.getLanguage() == "AR"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                      state.errorText ?? '',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            validator: (value) {
                              if (!checkboxValue) {
                                return _language.tRegisterErrorConditions();
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            width: 175,
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: _isLoading
                                  ? LoadingAnimationWidget.inkDrop(
                                      color: Colors.white, size: 30)
                                  : Text(
                                      _language.tRegisterButton().toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                              onPressed: () async {
                                var connectivityResult =
                                    await Connectivity().checkConnectivity();
                                if (connectivityResult ==
                                        ConnectivityResult.mobile ||
                                    connectivityResult ==
                                        ConnectivityResult.wifi) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    input = ({
                                      'password': _password.text.toString(),
                                      'email': _email.text.toString(),
                                      'first_name': _firstName.text.toString(),
                                      'last_name': _lastName.text.toString(),
                                      'role': 'user',
                                      'organization_name':
                                          _organization.text.toString()
                                    });
                                    transformedData = {};
                                    input!.forEach((key, value) {
                                      transformedData![key] = value.toString();
                                    });
                                    jsonString = jsonEncode(transformedData);
                                    debugPrint("$jsonString**************");
                                    encrypt = requestClass
                                        .encryptRegisterInput(jsonString);
                                    debugPrint("$encrypt**************");
                                    requestClass
                                        .registerPostRequest(encrypt)
                                        .then(
                                      (value) {
                                        registerResponse =
                                            requestClass.registerResponseBody();
                                        debugPrint(
                                            "************$registerResponse");
                                        if (registerResponse != null &&
                                            requestClass
                                                    .registerResponseStatus() ==
                                                200) {
                                          Fluttertoast.showToast(
                                              msg: _language
                                                  .tRegisterSuccesMsg(),
                                              backgroundColor: Colors.grey);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
                                              ));
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                    );
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
                          const SizedBox(height: 30.0),
                          // const Text(
                          //   "Or create account using social media",
                          //   style: TextStyle(color: Colors.grey),
                          // ),
                          // const SizedBox(height: 25.0),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     GestureDetector(
                          //       child: FaIcon(
                          //         FontAwesomeIcons.googlePlus,
                          //         size: 35,
                          //         color: HexColor("#EC2D2F"),
                          //       ),
                          //       onTap: () {},
                          //     ),
                          //     const SizedBox(
                          //       width: 30.0,
                          //     ),
                          //     GestureDetector(
                          //       child: Container(
                          //         padding: EdgeInsets.all(0),
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(100),
                          //           border: Border.all(
                          //               width: 5, color: HexColor("#40ABF0")),
                          //           color: HexColor("#40ABF0"),
                          //         ),
                          //         child: FaIcon(
                          //           FontAwesomeIcons.twitter,
                          //           size: 23,
                          //           color: HexColor("#FFFFFF"),
                          //         ),
                          //       ),
                          //       onTap: () {},
                          //     ),
                          //     const SizedBox(
                          //       width: 30.0,
                          //     ),
                          //     GestureDetector(
                          //       child: FaIcon(
                          //         FontAwesomeIcons.facebook,
                          //         size: 35,
                          //         color: HexColor("#3E529C"),
                          //       ),
                          //       onTap: () {},
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
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
