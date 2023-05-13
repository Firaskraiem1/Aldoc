// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show ClientException;

class RequestClass {
  void extractPostRequest(String fileData, String? currentState) async {
    Uri url;
    try {
      if (currentState == "idDocument") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/idCard?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
        debugPrint("idDocument");
      } else if (currentState == "passport") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/passport?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
      } else if (currentState == "businessCard") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/businessCard?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
      } else {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/invoice?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
      }
      // var request = http.MultipartRequest('POST', url);
      // request.fields['user_id'] = '700bdfbd-f9bc-49bb-9822-cd108abaab4b';
      // var imageFile = File(imagePath!);
      // var stream = http.ByteStream(image.openRead());
      // var length = await image.length();
      // var multipartFile = http.MultipartFile('image', stream, length,
      //     filename: image.path.split('/').last);
      // request.files.add(multipartFile);

      var request = http.MultipartRequest('POST', url)
        ..fields['userId'] = '700bdfbd-f9bc-49bb-9822-cd108abaab4b'
        ..files.add(http.MultipartFile.fromString(
          'file',
          fileData,
          filename: 'file',
        ));

      var response = await request.send();
      debugPrint(
          'Status code:${response.statusCode} +Reason:${response.reasonPhrase} ');
    } on ClientException {
      Fluttertoast.showToast(
          msg: "Failed to connect to host", backgroundColor: Colors.grey);
    }
  }
}
