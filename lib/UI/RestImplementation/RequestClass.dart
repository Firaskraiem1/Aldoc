// ignore_for_file: depend_on_referenced_packages, unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:aldoc/provider/Language.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show ClientException;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class RequestClass {
  String? extractDemoResponse;
  String? extractConnectedResponse;
  int? statusPostExtract;
  int? statusPostExtractConnected;
  String? ee;
  String? pathImageuserConnected;
  String? eee;
  String? token;
  String? refresh_token;
  int? eeeee;
  int? eeeeee;
  int? eeeeeee;
  int? eeeeeeee;
  String? userId;
  final Language _language = Language();
  String? firstName;
  String? lastName;
  String? email;
  String? organization;
  String? password;
  String? apikey;
  String? extractResult;
  int? extractResultStatus;
  Future<void> extractPostRequest(
      List<int> imageBytes, String fileData, String? currentState) async {
    Uri url;

    try {
      if (currentState == "idDocument") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/demo//idCard?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
        debugPrint("idDocument");
      } else if (currentState == "passport") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/passport?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
      } else if (currentState == "businessCard") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/businessCard?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
      } else {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/demo//invoice?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b');
      }
      var request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileData.split('/').last,
        contentType: MediaType.parse("image/jpg"),
      ));

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        debugPrint("post request succes");
      } else {
        Fluttertoast.showToast(
            msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
      }
      extractDemoResponse = await response.stream.bytesToString();
      statusPostExtract = response.statusCode;
    } on ClientException {
      Fluttertoast.showToast(
          msg: _language.tCaptureError(), backgroundColor: Colors.grey);
    } on Exception {
      Fluttertoast.showToast(
          msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
    }
  }

  String? postResponseBody() {
    var r = extractDemoResponse;
    return r;
  }

  int? postResponseStatus() {
    var r = statusPostExtract;
    return r;
  }

  Future<void> extractPostRequestConnectedUser(
      List<int> imageBytes,
      String fileData,
      String? userID,
      String? currentState,
      String? userToken) async {
    Uri url;
    try {
      if (currentState == "idDocument") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/image_extraction?skill_id=Identity_Card_Arabic_Medium_DTR_document_0.1&user_id=$userID&reference_id=$userID');
        debugPrint("idDocument+login");
      } else if (currentState == "passport") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/image_extraction?skill_id=Libyan_Passport_Arabic_English_Medium_DTR_document_0.1&user_id=$userID&reference_id=$userID');
        debugPrint("passport+login");
      } else if (currentState == "businessCard") {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/image_extraction?skill_id=Business_Card_Multilingual_Medium_DTR_document_1.1&user_id=$userID&reference_id=$userID');
        debugPrint("business card +login");
      } else {
        url = Uri.parse(
            'https://aldoc.dev.algobrain.ai/api/image_extraction?skill_id=Invoice_French_Medium_DTR_document_0.1&user_id=$userID&reference_id=$userID');
        debugPrint("invoice +login");
      }
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $userToken';
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileData.split('/').last,
        contentType: MediaType.parse("image/jpg"),
      ));

      http.StreamedResponse response = await request.send();
      extractConnectedResponse = await response.stream.bytesToString();

      statusPostExtractConnected = response.statusCode;
      debugPrint(
          "Extract result:$extractConnectedResponse+ Status:$statusPostExtractConnected");
      if (response.statusCode == 200) {
      } else {
        Fluttertoast.showToast(
            msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
      }
    } on ClientException {
      Fluttertoast.showToast(
          msg: _language.tCaptureError(), backgroundColor: Colors.grey);
    } on Exception {
      Fluttertoast.showToast(
          msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
    }
  }

  String? postConnectdResponseBody() {
    var r = extractConnectedResponse;
    return r;
  }

  int? postConnectedResponseStatus() {
    var r = statusPostExtractConnected;
    return r;
  }

  Future<void> userConnectedExtractResult(
    String? taskId,
    String? userToken,
  ) async {
    // taskId = taskId!.replaceAll(" ", "");

    Uri url = Uri.parse(
        'https://aldoc.dev.algobrain.ai/api/document_per_task?task_id=$taskId');
    try {
      debugPrint("$url");
      var getExtract =
          await http.get(url, headers: {'Authorization': 'Bearer $userToken'});
      extractResult = getExtract.body;
      extractResultStatus = getExtract.statusCode;
      debugPrint(
          "$extractResult+ ${getExtract.statusCode}+${getExtract.reasonPhrase}");
      if (getExtract.statusCode == 200) {
        debugPrint("$extractResult+ ${getExtract.statusCode}");
      } else {
        throw Exception(Fluttertoast.showToast(
            msg: _language.tErrorMsg(), backgroundColor: Colors.grey));
      }
    } catch (error) {
      print("e:$error");
    }
  }

  String? extractResultResponseBody() {
    var r = extractResult;
    return r;
  }

  int? extractResultResponseStatus() {
    var r = extractResultStatus;
    return r;
  }

  Future<void> getImageRequest(String? p) async {
    Uri url = Uri.parse(
        'https://aldoc.dev.algobrain.ai/demo//get_file?user_id=700bdfbd-f9bc-49bb-9822-cd108abaab4b&file_id=$p');
    var getResponse = await http.get(url);
    var responseImage = getResponse.bodyBytes;
    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;
    var file = File('$tempPath/image.jpg');
    await file.writeAsBytes(responseImage);
    ee = file.path.toString();
    if (getResponse.statusCode == 200) {
      debugPrint("get request succes");
    } else {
      Fluttertoast.showToast(
          msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
    }
  }

  String? getResponseBody() {
    var r = ee;
    return r;
  }

  Future<void> getImageConnectedUserRequest(
      String? p, String? userId, String? userToken) async {
    Uri url = Uri.parse(
        'https://aldoc.dev.algobrain.ai/demo//get_file?user_id=$userId&file_id=$p');

    try {
      var getResponse =
          await http.get(url, headers: {'Authorization': 'Bearer $userToken'});
      var responseImage = getResponse.bodyBytes;
      var tempDir = await getTemporaryDirectory();
      var tempPath = tempDir.path;
      var file = File('$tempPath/image${DateTime.now()}.jpg');
      await file.writeAsBytes(responseImage);
      pathImageuserConnected = file.path.toString();
      if (getResponse.statusCode == 200) {
        debugPrint("get request succes");
      } else {
        throw Exception(Fluttertoast.showToast(
            msg: _language.tErrorMsg(), backgroundColor: Colors.grey));
      }
    } catch (error) {
      print("e:$error");
    }
  }

  String? getUserConnectedImageResponseBody() {
    var r = pathImageuserConnected;
    return r;
  }

  String? encryptRegisterInput(String? input) {
    final plainText = input;
    final key = encrypt.Key.fromUtf8("azertyuiopmlkjaq");
    final iv = encrypt.IV.fromUtf8("azertyuiopmlkjaq");
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText!, iv: iv);
    return encrypted.base64;
  }

  int? statusRegister;
  Future<void> registerPostRequest(String? encrypted) async {
    Uri url = Uri.parse(
        'https://aldoc.dev.algobrain.ai/bff//users/registerEncrypted');

    if (encrypted != "") {
      var response = await http.post(url,
          body: jsonEncode({"encrypted_object": encrypted.toString()}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        debugPrint("register request succes");
      } else {
        Fluttertoast.showToast(
            msg: _language.tErrorMsg(), backgroundColor: Colors.grey);
      }
      eee = response.body;
      statusRegister = response.statusCode;
      debugPrint("${response.reasonPhrase}+${response.statusCode}");
    }
  }

  String? registerResponseBody() {
    var r = eee;
    return r;
  }

  int? registerResponseStatus() {
    var r = statusRegister;
    return r;
  }

  Future<void> loginPostRequest(String? encrypted) async {
    Uri url =
        Uri.parse('https://aldoc.dev.algobrain.ai/bff//users/login/encrypted');

    if (encrypted != "") {
      var response = await http.post(url,
          body: jsonEncode({"encrypted_object": encrypted.toString()}),
          headers: {"Content-Type": "application/json"});

      eeeee = response.statusCode;
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body.toString());
        if (data != null && data["token"] != null) {
          token = data["token"];
          refresh_token = data["refresh_token"];
        }
      }
      debugPrint("${response.reasonPhrase}+${response.statusCode}+$token ");
    }
  }

  String? loginResponseBody() {
    var r = token;
    return r;
  }

  String? loginResponseBodyRefreshToken() {
    var r = refresh_token;
    return r;
  }

  int? loginResponseStatus() {
    var r = eeeee;
    return r;
  }

  Future<void> getUser(String? token, String? email) async {
    Uri url = Uri.parse("https://aldoc.dev.algobrain.ai/api/users");
    if (token != null) {
      var response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      List<dynamic> data = await jsonDecode(response.body.toString());
      for (int i = 0; i <= data.length - 1; i++) {
        if (data[i]['email'].toString() == email) {
          userId = data[i]['id'].toString();
        }
      }
    }
    debugPrint("UserId:$userId");
  }

  String? getUserId() {
    return userId;
  }

  Future<void> getUserInformations(String? token, String? userId) async {
    Uri url = Uri.parse(
        "https://aldoc.dev.algobrain.ai/api/get_user?query_param=$userId");
    if (token != null) {
      var response = await http.get(url, headers: {'Authorization': token});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        firstName = data["first_name"].toString();
        lastName = data["last_name"].toString();
        email = data["email"].toString();
        organization = data["organization"]["name"].toString();
        password = data["password"].toString();
        apikey = data["api_key"].toString();
      }

      eeeeee = response.statusCode;
    }
  }

  int? userInfoStatus() {
    var r = eeeeee;
    return r;
  }

  String? getFirstName() {
    var e = firstName;
    return e;
  }

  String? getlastName() {
    var e = lastName;
    return e;
  }

  String? getEmail() {
    var e = email;
    return e;
  }

  String? getOrganization() {
    var e = organization;
    return e;
  }

  String? getPassword() {
    var e = password;
    return e;
  }

  String? getApiKey() {
    var e = apikey;
    return e;
  }

  Future<void> updatePasswordRequest(
      String? token, String? userId, String? encrypted) async {
    Uri url = Uri.parse(
        "https://aldoc.dev.algobrain.ai/api/update_user_password_encrypted?user_id=$userId");

    if (userId != null && token != null && encrypted != null) {
      var response = await http.put(url,
          body: jsonEncode({"encrypted_object": encrypted.toString()}),
          headers: {
            'Authorization': 'Bearer $token',
            "Content-Type": "application/json"
          });

      eeeeeee = response.statusCode;
    }
  }

  int? updatePwdResponseStatus() {
    var r = eeeeeee;
    return r;
  }

  Future<void> updateUserInformations(
      String? token,
      String pwd,
      String? email,
      String? firstName,
      String? lastName,
      String? organizationName,
      String? userId,
      String? apiKey) async {
    Uri url =
        Uri.parse("https://aldoc.dev.algobrain.ai/api/get_user?id=$userId");
    if (token != null) {
      var response = await http.put(url,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: jsonEncode({
            "password": pwd.toString(),
            "email": email.toString(),
            "first_name": firstName.toString(),
            "last_name": lastName.toString(),
            "role": "user".toString(),
            "organization_name": organizationName.toString(),
            "id": userId.toString(),
            "api_key": apiKey.toString()
          }));
      // if (response.statusCode == 200) {
      //   var data = json.decode(response.body.toString());
      //   debugPrint("$data");
      //   debugPrint(data["first_name"]);
      //   debugPrint(data["last_name"]);
      //   // firstName = data["first_name"].toString();
      //   // lastName = data["last_name"].toString();
      // }
      eeeeeeee = response.statusCode;
      // debugPrint(response.body);
    }
  }

  int? updateUserInfoResponseStatus() {
    var r = eeeeeeee;
    return r;
  }

  String? productsResponseBody;
  int? productStatus;
  Future<void> getProducts(
      String? userToken, String? userId, int? pages, String? skillId) async {
    Uri url = Uri.parse("https://aldoc.dev.algobrain.ai/api/products");
    if (userId != "" && userToken != null) {
      var request = await http.post(
        url,
        body: skillId != ""
            ? jsonEncode({
                "filtering_options": {
                  "status": "Transcribed",
                  "skill_id": skillId,
                  "user_id": userId
                },
                "filtering_options_to_remove": {
                  "status": "Deleted",
                },
                "page_size": pages,
                "page_number": 0,
                "sort_by_date": "true"
              })
            : jsonEncode({
                "filtering_options": {
                  "status": "Transcribed",
                  "user_id": userId
                },
                "filtering_options_to_remove": {
                  "status": "Deleted",
                },
                "page_size": pages,
                "page_number": 0,
                "sort_by_date": "true"
              }),
        headers: {'Authorization': userToken},
      );
      productsResponseBody = request.body;
      productStatus = request.statusCode;
      debugPrint(productsResponseBody);
    }
  }

  String? getProductsResponseBody() {
    var r = productsResponseBody;
    return r;
  }

  int? getProductsStatus() {
    var r = productStatus;
    return r;
  }
}
