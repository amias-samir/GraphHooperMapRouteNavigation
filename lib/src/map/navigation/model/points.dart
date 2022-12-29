import 'dart:convert';

class Points {
  String? _type;
  List<List<double>>? _coordinates;

  Points({String? type, List<List<double>>? coordinates}) {
    if (type != null) {
      this._type = type;
    }
    if (coordinates != null) {
      this._coordinates = coordinates;
    }
  }

  String? get type => _type;
  set type(String? type) => _type = type;
  List<List<double>>? get coordinates => _coordinates;
  set coordinates(List<List<double>>? coordinates) => _coordinates = coordinates;

  Points.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    if(json['coordinates'] != null && json['coordinates'].length > 0 ){
      coordinates = List<List<double>>.from(json['coordinates'].map((coordinate) {
        List<double> coords = coordinate.cast<double>();
        return coords;
      }).toList());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['coordinates'] = this._coordinates;

    return data;
  }

}