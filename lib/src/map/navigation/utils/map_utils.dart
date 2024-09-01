import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector_math;
import 'dart:math' show asin, cos, sqrt;

class MapUtils {
  /// Calculate Bearing value between two coordinates
  ///
  static double calculateBearingBtnTwoCords({
    required LatLng startLatLng,
    required LatLng endLatLng,
  }) {
    double lat1 = startLatLng.latitude;
    double lat2 = endLatLng.latitude;
    double lng1 = startLatLng.longitude;
    double lng2 = endLatLng.longitude;

    double dLon = (lng2 - lng1);
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double radian = (math.atan2(y, x));
    // double bearing  = (radian * 180)/pi;
    double bearing = vector_math.degrees(radian);

    bearing = (360 - ((bearing + 360) % 360));

    return bearing;
  }

  /// Calculates Distance between two coordinates
  ///
  static double calculateDistanceBtnTwoCoords({
    required LatLng startLatLng,
    required LatLng endLatLng,
  }) {
    // distance in Meters
    // if you want distance in Kilo Meters, Just divide by 1000
    double lat1 = startLatLng.latitude;
    double lat2 = endLatLng.latitude;
    double lng1 = startLatLng.longitude;
    double lng2 = endLatLng.longitude;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    double distance = 12742 * asin(sqrt(a)) * 1000;

    return distance;
  }

  /// Calculate speed
  ///
  static double calculateSpeed(double distance, int time) {
    double microToSecond = time / 1000000;
    double speed = distance / microToSecond;
    // updateSpeed(speed: speed);
    return speed;
  }
}
