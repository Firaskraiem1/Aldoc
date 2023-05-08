// ignore: file_names
import 'package:flutter/material.dart';

// ignore: camel_case_types
class cameraProvider with ChangeNotifier {
  bool state = false;
  bool state1 = false;
  bool state2 = false;
  bool state3 = false;
  bool state5 = false;
  bool state6 = false;
  bool state7 = false;
  String? state4;
  String? uploadPath;
  String? path;
  //camera state
  cameraState(bool s) {
    state = s;
    notifyListeners();
  }

  bool getCameraState() {
    return state;
  }

// restart state
  restartCameraState(bool s) {
    state2 = s;
  }

  bool getRestartState() {
    return state2;
  }

// remove appBar
  removeAppBar(bool s) {
    state3 = s;
  }

  bool getRemoveAppBar() {
    return state3;
  }

//flash state
  flashState(bool s) {
    state1 = s;
    notifyListeners();
  }

  bool getFlashState() {
    return state1;
  }

//image path
  setImagePath(String s) {
    path = s;
    notifyListeners();
  }

  String? getPathImage() {
    return path;
  }

  //image uploaded path
  setUploadPath(String s) {
    uploadPath = s;
    notifyListeners();
  }

  String? getPathUploadImage() {
    return uploadPath;
  }

  // current state pour uploadFile
  setCurrentState(String s) {
    state4 = s;
    notifyListeners();
  }

  String? getCurrentState() {
    return state4;
  }

  //  Invoice Camera
  setInvoiceCamera(bool s) {
    state5 = s;
    notifyListeners();
  }

  getInvoiceCamera() {
    return state5;
  }

//  Passport Camera
  setPassportCamera(bool s) {
    state6 = s;
    notifyListeners();
  }

  getPassportCamera() {
    return state6;
  }

  // generic form state pour gerer float buttons (padding)
  setGenericState(bool s) {
    state7 = s;
    notifyListeners();
  }

  getGenericState() {
    return state7;
  }
}
