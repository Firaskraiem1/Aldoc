// ignore_for_file: override_on_non_overriding_member

import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tRegisterFirstName(),
                                  _language.tRegisterFirstNameMessage(),
                                  Icons.person),
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
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tRegisterLastName(),
                                  _language.tRegisterLastNameMessage(),
                                  Icons.person),
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
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tLoginEmail(),
                                  _language.tLoginEmailMessage(),
                                  Icons.email),
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
                                label: Align(
                                    alignment: _language.getLanguage() == "AR"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                        _language.tAddNewPasswordMessage1())),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                hintText: _language.tAddNewPasswordMessage1(),
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
                                  return _language.tAddNewPasswordMessage1();
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
                                label: Align(
                                    alignment: _language.getLanguage() == "AR"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                        _language.tRegisterConfirmPassword())),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                hintText:
                                    _language.tRegisterConfirmPasswordMessage(),
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
                              textAlign: _language.getLanguage() == "AR"
                                  ? TextAlign.end
                                  : TextAlign.start,
                              decoration: ThemeHelper().textInputDecoration(
                                  _language.tRegisterOrganization(),
                                  _language.tRegisterOrganizationMessage(),
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
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  _language.tRegisterButton().toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ));
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
