// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';

class authProvider with ChangeNotifier {
  bool state1 = false;
  setLoginState(bool s) {
    state1 = s;
    notifyListeners();
  }

  getLoginState() {
    return state1;
  }
}
