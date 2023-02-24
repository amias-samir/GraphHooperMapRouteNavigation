import 'package:mapbox_gl_modified/mapbox_gl_modified.dart';

import 'direction_route_response.dart';

class InstructionsCoordsAndIndexList {
  List<List<double>> _instructionsCoordsList;
  List<int> _instructionsIndexList;

  InstructionsCoordsAndIndexList(
      this._instructionsCoordsList, this._instructionsIndexList);

  List<List<double>> get instructionsCoordsList => _instructionsCoordsList;

  set instructionsCoordsList(List<List<double>> value) {
    _instructionsCoordsList = value;
  }

  List<int> get instructionsIndexList => _instructionsIndexList;

  set instructionsIndexList(List<int> value) {
    _instructionsIndexList = value;
  }
}

class InstructionsCoordsIndexListAndUsersLoc {
  List<List<double>> _instructionsCoordsList;
  List<int> _instructionsIndexList;
  DirectionRouteResponse _directionRouteResponse;
  LatLng _usersLatLng;

  InstructionsCoordsIndexListAndUsersLoc(
      this._instructionsCoordsList,
      this._instructionsIndexList,
      this._directionRouteResponse,
      this._usersLatLng);

  List<List<double>> get instructionsCoordsList => _instructionsCoordsList;

  set instructionsCoordsList(List<List<double>> value) {
    _instructionsCoordsList = value;
  }

  LatLng get usersLatLng => _usersLatLng;

  set usersLatLng(LatLng value) {
    _usersLatLng = value;
  }

  DirectionRouteResponse get directionRouteResponse => _directionRouteResponse;

  set directionRouteResponse(DirectionRouteResponse value) {
    _directionRouteResponse = value;
  }

  List<int> get instructionsIndexList => _instructionsIndexList;

  set instructionsIndexList(List<int> value) {
    _instructionsIndexList = value;
  }
}
