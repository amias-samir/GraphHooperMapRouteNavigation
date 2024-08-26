import 'package:maplibre_gl/maplibre_gl.dart';

class CalculatorUtils {
  static String calculateTime({required int miliSeconds}) {
    double timeInMinutesDouble = miliSeconds / (1000 * 60);

    int timeInMinutes = timeInMinutesDouble.round();
    String timeString = '$timeInMinutes';

    if (timeInMinutes > 0) {
      timeString = (timeInMinutes < 60)
          ? '${timeInMinutes.toString()} mins.'
          : (timeInMinutes > 60 && timeInMinutes < (60 * 24))
              ? '${(timeInMinutes ~/ 60)} hrs'
              : (timeInMinutes > (60 * 24) && timeInMinutes < (60 * 24 * 29))
                  ? '${(timeInMinutes ~/ (60 * 24))} d'
                  : "infinity";
    } else {
      timeString = '${miliSeconds ~/ (1000 * 60)} secs.';
    }

    return timeString;
  }

  static String calculateDistance({required double distanceInMeter}) {
    String distanceString = '$distanceInMeter M';
    if (distanceInMeter > 500.0) {
      distanceString = '${(distanceInMeter / 1000).toStringAsFixed(2)} Km.';
    } else {
      distanceString = '${distanceInMeter.toStringAsFixed(2)} M.';
    }
    return distanceString;
  }

  static bool isCoordinateInside(
      {required LatLng instructionLatLng,
      double radius = 0.0002,
      required LatLng usersLatLng}) {
    double circleX = instructionLatLng.longitude;
    double circleY = instructionLatLng.latitude;
    double x = usersLatLng.longitude;
    double y = usersLatLng.latitude;
    // Compare radius of circle with
    // distance of its center from
    // given point

    final distanceFromCircleOfCenter = (x - circleX) * (x - circleY) + (y - circleX) * (y - circleY);

    if (distanceFromCircleOfCenter <=
        radius * radius) {
      return true;
    } else {
      return false;
    }
  }
}
