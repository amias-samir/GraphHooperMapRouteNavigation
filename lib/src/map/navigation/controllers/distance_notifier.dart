import 'package:flutter/foundation.dart';

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
    required double distance,
  }) {
    _distance = distance;
    notifyListeners();
  }
}
