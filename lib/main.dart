import 'package:aldoc/UI/splashScreen.dart';
import 'package:aldoc/provider/authProvider.dart';
import 'package:aldoc/provider/cameraProvider.dart';
import 'package:aldoc/provider/filesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => cameraProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => authProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => filesProvider(),
        )
      ],
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const splashScreen(),
              builder: (context, child) => ResponsiveWrapper.builder(
                    child,
                    maxWidth: 1200,
                    minWidth: 480,
                    defaultScale: true,
                    breakpoints: [
                      const ResponsiveBreakpoint.resize(400, name: MOBILE),
                      const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                      const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                      const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                    ],
                  ));
        },
      ),
    );
  }
}
