import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../navigation/model/direction_route_response.dart';
import '../navigation/model/enums.dart';
import 'package:http/http.dart' as http;



class ApiRequest{
  String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  String navType = 'cycling';

// String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1IjoicGVhY2VuZXBhbCIsImEiOiJjajZhYzJ4ZmoxMWt4MzJsZ2NnMmpsejl4In0.rb2hYqaioM1-09E83J-SaA';
//
  Future getDrivingRouteUsingMapbox(LatLng source, LatLng destination) async {
    String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=pk.eyJ1IjoicGVhY2VuZXBhbCIsImEiOiJjajZhYzJ4ZmoxMWt4MzJsZ2NnMmpsejl4In0.rb2hYqaioM1-09E83J-SaA';

    debugPrint(url);
    try {
      final httpResponse = await http.get(Uri.parse(url));
      return json.decode(httpResponse.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getDrivingRouteUsingGraphHooper(LatLng source, LatLng destination, NavigationProfile? navigationType) async {

    String startPoint = '${source.latitude}%2C${source.longitude}';
    String endPoint = '${destination.latitude}%2C${destination.longitude}';

    String url = 'https://route.naxa.com.np/route?point=$startPoint&point=$endPoint&profile=${navigationType!.name}&points_encoded=false';

    debugPrint(url);
    try {
      final httpResponse = await http.get(Uri.parse(url));
      return DirectionRouteResponse.fromJson(json.decode(httpResponse.body));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}

