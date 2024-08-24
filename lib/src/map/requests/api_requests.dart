import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../navigation/model/direction_route_response.dart';
import '../navigation/model/enums.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  // String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  // String navType = 'cycling';

//
  Future<Object?> getDrivingRouteUsingMapbox(
      {required LatLng source,
      required LatLng destination,
      required mapBoxAccessToken}) async {
    String url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$mapBoxAccessToken';

    debugPrint(url);
    try {
      final httpResponse = await http.get(Uri.parse(url));
      return json.decode(httpResponse.body);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<DirectionRouteResponse?> getDrivingRouteUsingGraphHooper(
      {String? customBaseUrl,
      required LatLng source,
      required LatLng destination,
      required NavigationProfile? navigationType,
      required String graphHooperApiKey}) async {
    String routeUrl = customBaseUrl!.isNotEmpty
        ? customBaseUrl
        : 'https://graphhopper.com/api/1';

    String startPoint = '${source.latitude}%2C${source.longitude}';
    String endPoint = '${destination.latitude}%2C${destination.longitude}';

    String url =
        '$routeUrl/route?point=$startPoint&point=$endPoint&profile=${navigationType!.name}&points_encoded=false&key=$graphHooperApiKey';

    debugPrint(url);
    try {
      final httpResponse = await http.get(Uri.parse(url));
      return DirectionRouteResponse.fromJson(json.decode(httpResponse.body));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
