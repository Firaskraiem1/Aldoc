import 'package:aldoc/UI/IntroductionScreen.dart';
import 'package:aldoc/UI/registration/signIn.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    goToIntoduction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FBFA),
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(
          "assets/aldoc.png",
        ),
        const SizedBox(height: 41.76),
        const GFLoader(
          type: GFLoaderType.ios,
          size: 50,
        ),
      ])),
    );
  }

  goToIntoduction() async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
      () {},
    );

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const IntroductionScreen(),
        ));
  }
}
