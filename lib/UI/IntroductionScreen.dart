import 'package:aldoc/UI/Home.dart';
import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FBFA),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/aldoc.png"),
            const SizedBox(
              height: 119.76,
            ),
            Image.asset("assets/Feel Safe With Us!.png"),
            const SizedBox(
              height: 19.63,
            ),
            Image.asset("assets/uploadTextIntro.png"),
            const SizedBox(
              height: 33.37,
            ),
            Container(
              width: 180,
              decoration: ThemeHelper().buttonBoxDecoration(context),
              child: ElevatedButton(
                style: ThemeHelper().buttonStyle(),
                child: _isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LoadingAnimationWidget.stretchedDots(
                              color: Colors.white, size: 35)
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Let's Go!",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            width: 12.71,
                          ),
                          Image.asset("assets/arrow-right-outline.png")
                        ],
                      ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.delayed(
                    const Duration(seconds: 2),
                    () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
