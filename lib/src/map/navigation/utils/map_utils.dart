import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector_math;

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
}
