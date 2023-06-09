// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class filesProvider with ChangeNotifier {
  String? saveName;
  bool state1 = false;
  bool state3 = false;
  int? state4;
  String? state8;
  String? state2;
  List<dynamic> favoriteList = [];
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

  //response
  setResponse(String? r) {
    state2 = r;
    notifyListeners();
  }

  getResponse() {
    return state2;
  }

  //response
  setResponseState(bool r) {
    state3 = r;
    notifyListeners();
  }

  getResponseState() {
    return state3;
  }

  //response status for exctract post request
  setResponseStatus(int? r) {
    state4 = r;
    notifyListeners();
  }

  getResponseStatus() {
    return state4;
  }

  setFavoriteList(String? taskId, String? dateCreation, String? fileName,
      String? fileSize) {
    favoriteList.add({
      'task_id': taskId,
      'created_at': dateCreation,
      'file_name': fileName,
      'file_size': fileSize
    });
    notifyListeners();
  }

  removeEmelentFromList(int? index) {
    if (index != null) {
      favoriteList.removeAt(index);
      notifyListeners();
    }
  }

  getFavoriteList() {
    return favoriteList;
  }
}
