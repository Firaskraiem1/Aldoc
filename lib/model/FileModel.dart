class FileModel {
  FileSaved? fileSaved;

  FileModel({this.fileSaved});

  FileModel.fromJson(Map<String, dynamic> json) {
    fileSaved = json["fileSaved"] == null
        ? null
        : FileSaved.fromJson(json["fileSaved"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (fileSaved != null) {
      _data["fileSaved"] = fileSaved?.toJson();
    }
    return _data;
  }
}

class FileSaved {
  String? name;
  String? imagePath;
  OcrResult? ocrResult;
  DetectResult? detectResult;

  FileSaved({this.name, this.imagePath, this.ocrResult, this.detectResult});

  FileSaved.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    imagePath = json["imagePath"];
    ocrResult = json["ocrResult"] == null
        ? null
        : OcrResult.fromJson(json["ocrResult"]);
    detectResult = json["detectResult"] == null
        ? null
        : DetectResult.fromJson(json["detectResult"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["imagePath"] = imagePath;
    if (ocrResult != null) {
      _data["ocrResult"] = ocrResult?.toJson();
    }
    if (detectResult != null) {
      _data["detectResult"] = detectResult?.toJson();
    }
    return _data;
  }
}

class DetectResult {
  List<dynamic>? x;
  List<dynamic>? y;

  DetectResult({this.x, this.y});

  DetectResult.fromJson(Map<String, dynamic> json) {
    x = json["x"] ?? [];
    y = json["y"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (x != null) {
      _data["x"] = x;
    }
    if (y != null) {
      _data["y"] = y;
    }
    return _data;
  }
}

class OcrResult {
  List<dynamic>? x;
  List<dynamic>? y;

  OcrResult({this.x, this.y});

  OcrResult.fromJson(Map<String, dynamic> json) {
    x = json["x"] ?? [];
    y = json["y"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (x != null) {
      _data["x"] = x;
    }
    if (y != null) {
      _data["y"] = y;
    }
    return _data;
  }
}
