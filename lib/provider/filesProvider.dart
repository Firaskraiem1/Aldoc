// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class filesProvider with ChangeNotifier {
  String? saveName;
  bool state1 = false;

  String? state8;
  setSaveName(String t) {
    saveName = t;
    notifyListeners();
  }

  String? getSaveName() {
    return saveName;
  }

  setFavoriteState(bool t) {
    state1 = t;
    notifyListeners();
  }

  bool getFavoriteState() {
    return state1;
  }

  // file path for favorite file

  setFilePath(String s) {
    state8 = s;
    notifyListeners();
  }

  getFilePath() {
    return state8;
  }
}
