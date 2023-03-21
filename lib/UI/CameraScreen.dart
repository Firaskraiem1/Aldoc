import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
  // ignore: library_private_types_in_public_api
  static GlobalKey<_CameraScreenState> createKey() =>
      GlobalKey<_CameraScreenState>();
}

extension CameraScreenExtensionKey on GlobalKey<_CameraScreenState> {
  void captureImage() => currentState?.captureImage();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  CameraController? cameraController;

  XFile? image;

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
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: image == null
              ? CameraPreview(cameraController!)
              : Container(
                  child: imagePick(),
                )),
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

  Widget? imagePick() {
    if (image != null) {
      return Image.network(
        image!.path,
        height: 200,
      );
    }
    return null;
  }

  void captureImage() async {
    image = await cameraController!.takePicture();
    Navigator.pop(context, image?.path);
  }
}
