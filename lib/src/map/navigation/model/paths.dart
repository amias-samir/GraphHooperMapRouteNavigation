import 'package:graphhooper_route_navigation/src/map/navigation/model/points.dart';

import 'instructions.dart';

class Paths {
  double? distance;
  double? weight;
  int? time;
  int? transfers;
  bool? pointsEncoded;
  List<double>? bbox;
  Points? points;
  List<Instruction>? instructions;
  int? ascend;
  int? descend;
  Points? snappedWaypoints;

  Paths(
      {double? distance,
      double? weight,
      int? time,
      int? transfers,
      bool? pointsEncoded,
      List<double>? bbox,
      Points? points,
      List<Instruction>? instructions,
      int? ascend,
      int? descend,
      Points? snappedWaypoints}) {
    if (distance != null) {
      distance = distance;
    }
    if (weight != null) {
      weight = weight;
    }
    if (time != null) {
      time = time;
    }
    if (transfers != null) {
      transfers = transfers;
    }
    if (pointsEncoded != null) {
      pointsEncoded = pointsEncoded;
    }
    if (bbox != null) {
      bbox = bbox;
    }
    if (points != null) {
      points = points;
    }
    if (instructions != null) {
      instructions = instructions;
    }
    if (ascend != null) {
      ascend = ascend;
    }
    if (descend != null) {
      descend = descend;
    }
    if (snappedWaypoints != null) {
      snappedWaypoints = snappedWaypoints;
    }
  }

  Paths.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    weight = json['weight'];
    time = json['time'];
    transfers = json['transfers'];
    pointsEncoded = json['points_encoded'];
    bbox = json['bbox'].cast<double>();
    points = json['points'] != null ? Points.fromJson(json['points']) : null;
    if (json['instructions'] != null) {
      instructions = <Instruction>[];
      json['instructions'].forEach((v) {
        instructions!.add(Instruction.fromJson(v));
      });
    }
    ascend = json['ascend'].toInt();
    descend = json['descend'].toInt();
    snappedWaypoints = json['snapped_waypoints'] != null
        ? Points.fromJson(json['snapped_waypoints'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['weight'] = weight;
    data['time'] = time;
    data['transfers'] = transfers;
    data['points_encoded'] = pointsEncoded;
    data['bbox'] = bbox;
    if (points != null) {
      data['points'] = points!.toJson();
    }
    if (instructions != null) {
      data['instructions'] = instructions!.map((v) => v.toJson()).toList();
    }
    data['ascend'] = ascend;
    data['descend'] = descend;
    if (snappedWaypoints != null) {
      data['snapped_waypoints'] = snappedWaypoints!.toJson();
    }
    return data;
  }
}
