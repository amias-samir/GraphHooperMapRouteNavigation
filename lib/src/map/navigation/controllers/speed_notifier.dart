import 'package:flutter/foundation.dart';

class UserSpeedNotifier extends ChangeNotifier {
  /// Travelling speed of the user
  ///
  double _speed = 0.0;

  /// Getter for the speed
  ///
  double get speed => _speed;

  /// set the user's speed
  ///
  void setUserSpeed({
    required double speed,
  }) {
    _speed = speed;
    notifyListeners();
  }
}
