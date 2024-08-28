import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../navigation/model/direction_route_response.dart';
import '../navigation/model/enums.dart';
import 'package:http/http.dart' as http;

/// [ApiRequest] class makes api requests to various sources for driving routes
class ApiRequest {
  /// Fetches a driving route between the specified source and destination
  /// using the GraphHopper API.
  ///
  /// The function constructs a URL based on the provided parameters and
  /// sends a GET request to retrieve the route data.
  ///
  /// - Parameters:
  ///   - customBaseUrl: An optional custom base URL for the GraphHopper API.
  ///   - source: The starting point of the route as a `LatLng` object.
  ///   - destination: The endpoint of the route as a `LatLng` object.
  ///   - navigationType: The [NavigationProfile] to be used for route calculation
  ///     (e.g., car, foot).
  ///   - graphHooperApiKey: The API key for authenticating with the GraphHopper API.
  ///
  /// - Returns: A `Future` that resolves to a [DirectionRouteResponse] object
  ///   if the request is successful. If an error occurs, an exception is thrown.
  ///
  /// - Throws:
  ///   - [HttpException] if the HTTP request fails.
  ///   - [Exception] for any other errors that occur during the request processing.
  Future<DirectionRouteResponse> getDrivingRouteUsingGraphHooper({
    String? customBaseUrl,
    required LatLng source,
    required LatLng destination,
    required NavigationProfile navigationType,
     required String graphHooperApiKey,
  }) async {
    // Compute the route URL
    String routeUrl = (customBaseUrl != null && customBaseUrl.isNotEmpty)
        ? customBaseUrl
        : 'https://graphhopper.com/api/1';

    // Compute the start and end points
    String startPoint = '${source.latitude}%2C${source.longitude}';
    String endPoint = '${destination.latitude}%2C${destination.longitude}';

    // Construct the full URL for the API request
    String url =
        '$routeUrl/route?point=$startPoint&point=$endPoint&profile=${navigationType.name}&points_encoded=false&key=$graphHooperApiKey';

    // Print the URL in debug mode
    debugPrint(url);

    // Send the GET request and handle the response or any exceptions
    final httpResponse = await http.get(Uri.parse(url));

    if (httpResponse.statusCode == 200) {
      return DirectionRouteResponse.fromJson(json.decode(httpResponse.body));
    } else {
      throw const HttpException('Failed to load route');
    }
  }

  // String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  // String navType = 'cycling';

  // Future<Object?> getDrivingRouteUsingMapbox(
  //     {required LatLng source,
  //     required LatLng destination,
  //     required mapBoxAccessToken}) async {
  //   String url =
  //       'https://api.mapbox.com/directions/v5/mapbox/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$mapBoxAccessToken';

  //   debugPrint(url);
  //   try {
  //     final httpResponse = await http.get(Uri.parse(url));
  //     return json.decode(httpResponse.body);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return null;
  //   }
  // }
}
