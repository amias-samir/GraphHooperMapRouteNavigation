import 'paths.dart';
import 'hints.dart';
import 'info.dart';

class DirectionRouteResponse {
  Hints? hints;
  Info? info;
  List<Paths>? paths;

  DirectionRouteResponse({Hints? hints, Info? info, List<Paths>? paths}) {
    if (hints != null) {
      hints = hints;
    }
    if (info != null) {
      info = info;
    }
    if (paths != null) {
      paths = paths;
    }
  }

  DirectionRouteResponse.fromJson(Map<String, dynamic> json) {
    hints = json['hints'] != null ? Hints.fromJson(json['hints']) : null;
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    if (json['paths'] != null) {
      paths = <Paths>[];
      json['paths'].forEach((v) { paths!.add(Paths.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hints != null) {
      data['hints'] = hints!.toJson();
    }
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (paths != null) {
      data['paths'] = paths!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}