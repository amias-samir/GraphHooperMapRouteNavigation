
import 'package:maplibre_gl/maplibre_gl.dart';

import 'direction_route_response.dart';

class InstructionsCoordsAndIndexList{
  List<List<double>> instructionsCoordsList;
  List<int> instructionsIndexList;


  InstructionsCoordsAndIndexList(this.instructionsCoordsList, this.instructionsIndexList);
}

class InstructionsCoordsIndexListAndUsersLoc{
  List<List<double>> instructionsCoordsList;
  List<int> instructionsIndexList;
  DirectionRouteResponse directionRouteResponse;
  LatLng usersLatLng;

  InstructionsCoordsIndexListAndUsersLoc(
      this.instructionsCoordsList,
      this.instructionsIndexList,
      this.directionRouteResponse,
      this.usersLatLng);

}