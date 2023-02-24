iimport 'package:mapbox_gl_modified/mapbox_gl_modified.dart';

class CalculatorUtils {

  calculateTime({required int miliSeconds}){

    double timeInMinutesDouble = miliSeconds/(1000 * 60);

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
    }else{
      timeString = '${miliSeconds~/(1000 * 60)} secs.';
    }

    return timeString;
  }

  calculateDistance({required double distanceInMeter}){
    String distanceString = '$distanceInMeter M';
    if(distanceInMeter > 500.0){
      distanceString = '${(distanceInMeter/1000).toStringAsFixed(2)} Km.';
    }else{
      distanceString = '${distanceInMeter.toStringAsFixed(2)} M.';
    }
    return distanceString;
  }


  bool isCoordinateInside({required LatLng instructionLatLng, double radius = 0.0002, required LatLng usersLatLng})  {
    double circle_x = instructionLatLng.longitude;
    double circle_y = instructionLatLng.latitude;
    double x = usersLatLng.longitude;
    double y = usersLatLng.latitude;
    // Compare radius of circle with
    // distance of its center from
    // given point
    if ((x - circle_x) * (x - circle_x) +
        (y - circle_y) * (y - circle_y) <= radius * radius) {
      return true;
    } else {
      return false;
    }
  }

}

final CalculatorUtils calculatorUtils = CalculatorUtils();