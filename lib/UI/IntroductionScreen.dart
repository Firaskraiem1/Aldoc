import 'package:aldoc/UI/Home.dart';
import 'package:aldoc/UI/registration/ThemeHelper.dart';
import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
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
              decoration: ThemeHelper().buttonBoxDecoration(context),
              child: ElevatedButton(
                style: ThemeHelper().buttonStyle(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(51, 10, 27.29, 10),
                  child: Row(
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
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
