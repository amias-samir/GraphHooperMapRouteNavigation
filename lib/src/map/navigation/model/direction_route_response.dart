import 'paths.dart';
import 'hints.dart';
import 'info.dart';

class DirectionRouteResponse {
  Hints? _hints;
  Info? _info;
  List<Paths>? _paths;

  DirectionRouteResponse({Hints? hints, Info? info, List<Paths>? paths}) {
    if (hints != null) {
      this._hints = hints;
    }
    if (info != null) {
      this._info = info;
    }
    if (paths != null) {
      this._paths = paths;
    }
  }

  Hints? get hints => _hints;
  set hints(Hints? hints) => _hints = hints;
  Info? get info => _info;
  set info(Info? info) => _info = info;
  List<Paths>? get paths => _paths;
  set paths(List<Paths>? paths) => _paths = paths;

  DirectionRouteResponse.fromJson(Map<String, dynamic> json) {
    _hints = json['hints'] != null ? new Hints.fromJson(json['hints']) : null;
    _info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    if (json['paths'] != null) {
      _paths = <Paths>[];
      json['paths'].forEach((v) { _paths!.add(new Paths.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._hints != null) {
      data['hints'] = this._hints!.toJson();
    }
    if (this._info != null) {
      data['info'] = this._info!.toJson();
    }
    if (this._paths != null) {
      data['paths'] = this._paths!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}