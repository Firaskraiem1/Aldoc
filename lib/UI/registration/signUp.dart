import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/signIn.dart';
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
  @override
  void initState() {
    super.initState();
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
                              decoration: ThemeHelper().textInputDecoration(
                                  'First Name',
                                  'Enter your first name',
                                  Icons.person),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter a firstName";
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
                              decoration: ThemeHelper().textInputDecoration(
                                  'Last Name',
                                  'Enter your last name',
                                  Icons.person),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter a lastName";
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
                              decoration: ThemeHelper().textInputDecoration(
                                  "Email", "Enter your email", Icons.email),
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if ((val!.isEmpty) ||
                                    !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)) {
                                  return "Enter a valid email address";
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
                              obscureText: iSobscureText1,
                              decoration: InputDecoration(
                                suffixIconColor: Colors.grey,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        iSobscureText1 = !iSobscureText1;
                                      });
                                    },
                                    icon: iSobscureText1
                                        ? const Icon(
                                            Icons.key_off,
                                          )
                                        : const Icon(
                                            Icons.key,
                                          )),
                                labelText: "Password*",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                hintText: "Enter your password",
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
                                  return "Please enter your password";
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
                              obscureText: iSobscureText2,
                              decoration: InputDecoration(
                                suffixIconColor: Colors.grey,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        iSobscureText2 = !iSobscureText2;
                                      });
                                    },
                                    icon: iSobscureText2
                                        ? const Icon(
                                            Icons.key_off,
                                          )
                                        : const Icon(
                                            Icons.key,
                                          )),
                                labelText: "Confirm Password*",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                hintText: "Enter your confirm password",
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
                                  return "Please enter your password";
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
                              decoration: ThemeHelper().textInputDecoration(
                                  'Organization',
                                  'Enter your organization',
                                  Icons.corporate_fare),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter an organization";
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
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                          activeColor: const Color(0xff41B072),
                                          value: checkboxValue,
                                          onChanged: (value) {
                                            setState(() {
                                              checkboxValue = value!;
                                              state.didChange(value);
                                            });
                                          }),
                                      const Text(
                                        "I accept all terms and conditions.",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
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
                                return 'You need to accept terms and conditions';
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
                                  "Register".toUpperCase(),
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
