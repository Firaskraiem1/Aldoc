import 'package:flutter/material.dart';

class filesProvider with ChangeNotifier {
  String? saveName;
  bool state1 = false;
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
}
