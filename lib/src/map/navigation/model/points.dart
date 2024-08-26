import 'dart:convert';

class Points {
  String? type;
  List<List<double>>? coordinates;

  Points({String? type, List<List<double>>? coordinates}) {
    if (type != null) {
      type = type;
    }
    if (coordinates != null) {
      coordinates = coordinates;
    }
  }

  Points.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null && json['coordinates'].length > 0) {
      coordinates =
          List<List<double>>.from(json['coordinates'].map((coordinate) {
        List<double> coords = coordinate.cast<double>();
        return coords;
      }).toList());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;

    return data;
  }
}
