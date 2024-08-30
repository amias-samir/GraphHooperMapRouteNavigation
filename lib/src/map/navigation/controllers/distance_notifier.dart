import 'package:flutter/foundation.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/map_utils.dart';

class DistanceNotifier extends ChangeNotifier {
  /// instance variable which gives distance between two coordinates
  ///
  double _distance = 0.0;

  /// Getter for the [_distance]
  ///
  double get distance => _distance;

  /// Set the distance btn two cords
  ///
  void setDistanceBetweenTwoCoordinates({
    required LatLng startLatLng,
    required LatLng endLatLng,
  }) {
    _distance = MapUtils.calculateBearingBtnTwoCords(
      startLatLng: startLatLng,
      endLatLng: endLatLng,
    );

    notifyListeners();
  }
}
