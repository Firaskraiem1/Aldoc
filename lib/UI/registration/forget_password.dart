// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, override_on_non_overriding_member

import 'package:aldoc/UI/registration/signIn.dart';
import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/forget_password_verification_page.dart';
import 'package:aldoc/UI/registration/header_widget.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  EmailOTP myauth = EmailOTP();
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
    double _headerHeight = 300;
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
                              Text(
                                _language.tLoginForgotPassword(),
                                style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                                // textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _language.tForgorPasswordMessage1(),
                                style: const TextStyle(
                                    // fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                                // textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _language.tForgorPasswordMessage2(),
                                style: const TextStyle(
                                  color: Colors.black38,
                                  // fontSize: 20,
                                ),
                                // textAlign: TextAlign.center,
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
                                  controller: email,
                                  decoration: ThemeHelper().textInputDecoration(
                                      _language.tLoginEmail(),
                                      _language.tLoginEmailMessage(),
                                      Icons.email),
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
                                ),
                              ),
                              const SizedBox(height: 40.0),
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
                                      myauth.setConfig(
                                          appEmail: email.text,
                                          appName: 'Email verification code',
                                          userEmail: email.text,
                                          otpLength: 4,
                                          otpType: OTPType.digitsOnly);
                                      if (await myauth.sendOTP() == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor:
                                              const Color(0xff41B072),
                                          content: Text(_language
                                              .tVerificationCodeSentMessage()),
                                        ));
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordVerificationPage(
                                                    myauth: myauth,
                                                  )),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor:
                                              const Color(0xff41B072),
                                          content: Text(_language
                                              .tVerificationCodeSentErrorMessage()),
                                        ));
                                      }
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: _language
                                            .tForgorPasswordMessage3()),
                                    TextSpan(
                                      text: _language.tLoginButton(),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()),
                                          );
                                        },
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff41B072)),
                                    ),
                                  ],
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
