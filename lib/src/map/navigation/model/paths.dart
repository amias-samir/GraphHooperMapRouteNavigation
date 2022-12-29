
import 'package:graphhooper_route_navigation/src/map/navigation/model/points.dart';

import 'instructions.dart';

class Paths {
  double? _distance;
  double? _weight;
  int? _time;
  int? _transfers;
  bool? _pointsEncoded;
  List<double>? _bbox;
  Points? _points;
  List<Instructions>? _instructions;
  int? _ascend;
  int? _descend;
  Points? _snappedWaypoints;

  Paths({double? distance, double? weight, int? time, int? transfers, bool? pointsEncoded, List<double>? bbox, Points? points, List<Instructions>? instructions, int? ascend, int? descend, Points? snappedWaypoints}) {
    if (distance != null) {
      this._distance = distance;
    }
    if (weight != null) {
      this._weight = weight;
    }
    if (time != null) {
      this._time = time;
    }
    if (transfers != null) {
      this._transfers = transfers;
    }
    if (pointsEncoded != null) {
      this._pointsEncoded = pointsEncoded;
    }
    if (bbox != null) {
      this._bbox = bbox;
    }
    if (points != null) {
      this._points = points;
    }
    if (instructions != null) {
      this._instructions = instructions;
    }
    if (ascend != null) {
      this._ascend = ascend;
    }
    if (descend != null) {
      this._descend = descend;
    }
    if (snappedWaypoints != null) {
      this._snappedWaypoints = snappedWaypoints;
    }
  }

  double? get distance => _distance;
  set distance(double? distance) => _distance = distance;
  double? get weight => _weight;
  set weight(double? weight) => _weight = weight;
  int? get time => _time;
  set time(int? time) => _time = time;
  int? get transfers => _transfers;
  set transfers(int? transfers) => _transfers = transfers;
  bool? get pointsEncoded => _pointsEncoded;
  set pointsEncoded(bool? pointsEncoded) => _pointsEncoded = pointsEncoded;
  List<double>? get bbox => _bbox;
  set bbox(List<double>? bbox) => _bbox = bbox;
  Points? get points => _points;
  set points(Points? points) => _points = points;
  List<Instructions>? get instructions => _instructions;
  set instructions(List<Instructions>? instructions) => _instructions = instructions;
  int? get ascend => _ascend;
  set ascend(int? ascend) => _ascend = ascend;
  int? get descend => _descend;
  set descend(int? descend) => _descend = descend;
  Points? get snappedWaypoints => _snappedWaypoints;
  set snappedWaypoints(Points? snappedWaypoints) => _snappedWaypoints = snappedWaypoints;

  Paths.fromJson(Map<String, dynamic> json) {
    _distance = json['distance'];
    _weight = json['weight'];
    _time = json['time'];
    _transfers = json['transfers'];
    _pointsEncoded = json['points_encoded'];
    _bbox = json['bbox'].cast<double>();
    _points = json['points'] != null ? new Points.fromJson(json['points']) : null;
    if (json['instructions'] != null) {
      _instructions = <Instructions>[];
      json['instructions'].forEach((v) { _instructions!.add(new Instructions.fromJson(v)); });
    }
    _ascend = json['ascend'].toInt();
    _descend = json['descend'].toInt();
    _snappedWaypoints = json['snapped_waypoints'] != null ? new Points.fromJson(json['snapped_waypoints']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this._distance;
    data['weight'] = this._weight;
    data['time'] = this._time;
    data['transfers'] = this._transfers;
    data['points_encoded'] = this._pointsEncoded;
    data['bbox'] = this._bbox;
    if (this._points != null) {
      data['points'] = this._points!.toJson();
    }
    if (this._instructions != null) {
      data['instructions'] = this._instructions!.map((v) => v.toJson()).toList();
    }
    data['ascend'] = this._ascend;
    data['descend'] = this._descend;
    if (this._snappedWaypoints != null) {
      data['snapped_waypoints'] = this._snappedWaypoints!.toJson();
    }
    return data;
  }
}