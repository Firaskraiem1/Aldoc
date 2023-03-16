import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    initCamera().then((value) {
      startCamera(0);
    });
  }

  @override
  void dispose() {
    // open camera
    cameraController?.dispose();
    // orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const SizedBox(
        child: Text("erreur"),
      );
    }
    return Scaffold(
      backgroundColor: Image.asset("assets/back.jpg").color,
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/back.jpg"))),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
              height: 210, width: 250, child: CameraPreview(cameraController!)),
        ),
      ]),
    );
  }

  Future initCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  void startCamera(int index) async {
    cameraController = CameraController(
      cameras![index],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  // void captureImage() {
  //   cameraController!.takePicture().then((value) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const UploadScreen(),
  //         ));
  //   });
  // }
}
