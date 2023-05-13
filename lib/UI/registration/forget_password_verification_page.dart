// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, override_on_non_overriding_member, prefer_final_fields, use_build_context_synchronously

import 'package:aldoc/UI/registration/AddNewPassword.dart';
import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:aldoc/UI/registration/header_widget.dart';
import 'package:aldoc/provider/Language.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        showCursor: false,
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class ForgotPasswordVerificationPage extends StatefulWidget {
  const ForgotPasswordVerificationPage({Key? key, required this.myauth})
      : super(key: key);
  final EmailOTP myauth;
  @override
  _ForgotPasswordVerificationPageState createState() =>
      _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState
    extends State<ForgotPasswordVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
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
                  child: HeaderWidget(
                      _headerHeight, true, Icons.privacy_tip_outlined),
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
                                  _language.tVerificationMessage1(),
                                  style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
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
                                  _language.tVerificationMessage2(),
                                  style: const TextStyle(
                                      // fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Otp(otpController: otp1Controller),
                                  Otp(otpController: otp2Controller),
                                  Otp(otpController: otp3Controller),
                                  Otp(otpController: otp4Controller),
                                ],
                              ),
                              const SizedBox(height: 50.0),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _language.tVerificationMessage3(),
                                      style: const TextStyle(
                                        color: Colors.black38,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _language.tVerificationButton(),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await widget.myauth.sendOTP()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor:
                                                  const Color(0xff41B072),
                                              content: Text(_language
                                                  .tVerificationMessage4()),
                                            ));
                                          }
                                        },
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff41B072)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(
                                    context, "#AAAAAA", "#757575"),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  onPressed: () async {
                                    if (await widget.myauth.verifyOTP(
                                            otp: otp1Controller.text +
                                                otp2Controller.text +
                                                otp3Controller.text +
                                                otp4Controller.text) ==
                                        true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor:
                                            const Color(0xff41B072),
                                        content: Text(
                                            _language.tVerificationMessage5()),
                                      ));
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddNewPassword(),
                                          ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor:
                                            const Color(0xff41B072),
                                        content: Text(
                                            _language.tVerificationMessage6()),
                                      ));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      _language
                                          .tVerificationButton2()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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

// scroll glow effect
class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
