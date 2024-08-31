import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/navigation_instruction_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/speed_notifier.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/map_utils.dart';

///
/// Notifier class for [MapScreen]
///
class MapScreenController extends ChangeNotifier {
  ///
  /// [NavigationInstructionController] instance
  ///
  final NavigationInstructionController navigationInstructionController;

  /// [UserSpeedNotifier] instance
  ///
  final UserSpeedNotifier userSpeedNotifier;

  /// [DirectionRouteResponse] instance variable that comes from Api Call.
  ///
  final DirectionRouteResponse directionRouteResponse;

  /// Creates [MapScreenController] instance
  ///
  MapScreenController({
    required this.navigationInstructionController,
    required this.userSpeedNotifier,
    required this.directionRouteResponse,
  });

  /// private [MaplibreMapController] instance
  ///
  MaplibreMapController? _mapController;

  /// Getter for mapbox controller instance
  ///
  MaplibreMapController? get mapController => _mapController;

  /// User's starting Location circle
  ///
  Circle? startingUserLocationCircle;

  /// Map zoom level
  ///
  double mapZoomLevel = 14.0;

  /// Bearing value btn two co-ordinates
  ///
  double bearingBtnTwoCoords = 0.0;

  /// User's starting location [UserLocation]
  ///
  final UserLocation userLocation = UserLocation(
      position: const LatLng(28.987280, 80.1652),
      altitude: 1200.0,
      bearing: 0.0,
      speed: 0.0,
      horizontalAccuracy: 0.0,
      verticalAccuracy: 0.0,
      timestamp: DateTime.now(),
      heading: UserHeading(
          magneticHeading: 0.0,
          trueHeading: 0.0,
          headingAccuracy: 0.0,
          x: 0.0,
          y: 0.0,
          z: 0.0,
          timestamp: DateTime.now()));

  /// Method to handle on map created callback
  ///
  void onMapCreated({
    required MaplibreMapController mapLibreMapController,
    VoidCallback? extraFunc,
  }) {
    // initialize map controller
    _mapController = mapLibreMapController;

    if (_mapController == null) return;

    if (directionRouteResponse.toJson().isNotEmpty) {
      Map<String, dynamic> routeResponse = {
        "geometry": directionRouteResponse.paths![0].points!.toJson(),
        "duration": directionRouteResponse.paths![0].time,
        "distance": directionRouteResponse.paths![0].distance,
      };
      addSourceAndLineLayer(routeResponse);
    }

    // listener for the zoom level
    _mapController!.addListener(
      () {
        mapZoomLevel = _mapController!.cameraPosition!.zoom;
      },
    );

    // if there are extra computations to be performed then
    if (extraFunc != null) {
      extraFunc.call();
    }
  }

  /// Method to add Source and Line layer
  ///
  Future<void> addSourceAndLineLayer(
      Map<String, dynamic> modifiedResponse) async {
    // add start and end marker i.e --> green and red respectively
    addStartAndEndMarker();

    // feature collection object
    final fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": modifiedResponse['geometry'],
        },
      ],
    };

    // Remove lineLayer and source if it exists
    await _mapController!.removeLayer("lines");
    await _mapController!.removeSource("fills");

    // Add new source and lineLayer
    await _mapController!
        .addSource("fills", GeojsonSourceProperties(data: fills));
    await _mapController!.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: NavigationColors.blue.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 6,
      ),
    );
  }

  /// This method adds start and end marker which is circle
  /// [Red color] denotes the destination
  /// [Green color] denotes the starting point for the user
  ///
  Future<void> addStartAndEndMarker() async {
    // if null return
    if (_mapController == null) {
      return;
    }

    // starting circle
    startingUserLocationCircle = await _mapController!.addCircle(
      CircleOptions(
          geometry: LatLng(
              directionRouteResponse
                  .paths![0].snappedWaypoints!.coordinates!.first[1],
              directionRouteResponse
                  .paths![0].snappedWaypoints!.coordinates!.first[0]),
          circleColor: NavigationColors.green.toHexStringRGB(),
          circleRadius: 12),
    );

    // destination circle
    _mapController!.addCircle(
      CircleOptions(
          geometry: LatLng(
              directionRouteResponse
                  .paths![0].snappedWaypoints!.coordinates!.last[1],
              directionRouteResponse
                  .paths![0].snappedWaypoints!.coordinates!.last[0]),
          circleColor: NavigationColors.red.toHexStringRGB(),
          circleRadius: 12),
    );
  }

  /// Method to update [UserLocation] circle
  /// And animate camera to user location
  ///
  Future<void> updateUserLocationCircleAndAnimate(
      UserLocation userLocation) async {
    if (mapController == null) return;

    final newLocationFromRes =
        LatLng(userLocation.position.latitude, userLocation.position.longitude);

    // circle options
    final circleOptions = CircleOptions(
      geometry: newLocationFromRes,
      circleColor: NavigationColors.green.toHexStringRGB(),
      circleRadius: 12,
    );

    // if there is no circle then add circle
    if (startingUserLocationCircle == null) {
      startingUserLocationCircle =
          await mapController!.addCircle(circleOptions);
    } else {
      // else update the same circle
      await mapController!
          .updateCircle(startingUserLocationCircle!, circleOptions);
    }

    //  Animate the camera to the user's location
    mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(
              userLocation.position.latitude, userLocation.position.longitude),
          zoom: mapZoomLevel,
          bearing: bearingBtnTwoCoords
          // bearing: navigationController.bearingBtnCOOrds.value,
          ),
    ));
  }

  /// Method to update bearing value
  ///
  void animateCameraWithBearingValue({
    required double bearingValue,
  }) {
    bearingBtnTwoCoords = bearingValue;

    mapController!.animateCamera(CameraUpdate.bearingTo(bearingBtnTwoCoords));
  }

  /// Method to animate camera to user's current location
  ///
  void animateUserToCurrentLocation({
    double? zoomLevel,
    double? bearing,
  }) {
    // TODO: update user location as he or she starts to move using maplibre onUserLocation updated
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            userLocation.position.latitude, userLocation.position.longitude),
        zoom: zoomLevel ?? mapZoomLevel,
        bearing: bearing ?? userLocation.bearing!)));
  }

  /// Method to simulate routing
  ///
  void simulateRouting({bool simulateRoute = true}) async {
    List<List<double>> points =
        directionRouteResponse.paths![0].points!.coordinates!;

    // hadSpokenInstructionsIdentifier.value = [];

    DateTime dateTimePrev = DateTime.now();

    int count = 0;
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!simulateRoute) {
        count = 0;
        timer.cancel();
      }

      if (count < points.length) {
        if (count < points.length - 1) {
          UserLocation userLocation1 = UserLocation(
              position: LatLng(points[count][1], points[count][0]),
              altitude: userLocation.altitude,
              bearing: userLocation.bearing,
              speed: userLocation.speed,
              horizontalAccuracy: userLocation.horizontalAccuracy,
              verticalAccuracy: userLocation.verticalAccuracy,
              timestamp: userLocation.timestamp,
              heading: UserHeading(
                  magneticHeading: 0.0,
                  trueHeading: 0.0,
                  headingAccuracy: 0.0,
                  x: 0.0,
                  y: 0.0,
                  z: 0.0,
                  timestamp: userLocation.timestamp));

          // animate camera with bearing value
          await updateUserLocationCircleAndAnimate(userLocation1);

          // update bearing
          animateCameraWithBearingValue(
            bearingValue: MapUtils.calculateBearingBtnTwoCords(
                startLatLng: LatLng(points[count][1], points[count][0]),
                endLatLng: LatLng(points[count + 1][1], points[count + 1][0])),
          );

          Duration diff = DateTime.now().difference(dateTimePrev);
          dateTimePrev = DateTime.now();

          final distanceBtnTwoCords = MapUtils.calculateDistanceBtnTwoCoords(
              startLatLng: LatLng(points[count][1], points[count][0]),
              endLatLng: LatLng(points[count + 1][1], points[count + 1][0]));

          final speed =
              MapUtils.calculateSpeed(distanceBtnTwoCords, diff.inMicroseconds);

          // set the user speed
          userSpeedNotifier.setUserSpeed(speed: speed);

          // calculateSpeed(
          //     calculateDistance(LatLng(points[count][1], points[count][0]),
          //         LatLng(points[count + 1][1], points[count + 1][0])),
          //     diff.inMicroseconds);

          navigationInstructionController.checkIsCoordinateInsideCircle(
              directionRouteResponse: directionRouteResponse,
              usersLatLng: userLocation1.position);
        }
      } else if (count == points.length) {
        UserLocation userLocation1 = UserLocation(
            position: LatLng(points[count - 1][1], points[count - 1][0]),
            altitude: userLocation.altitude,
            bearing: userLocation.bearing,
            speed: userLocation.speed,
            horizontalAccuracy: userLocation.horizontalAccuracy,
            verticalAccuracy: userLocation.verticalAccuracy,
            timestamp: userLocation.timestamp,
            heading: UserHeading(
                magneticHeading: 0.0,
                trueHeading: 0.0,
                headingAccuracy: 0.0,
                x: 0.0,
                y: 0.0,
                z: 0.0,
                timestamp: userLocation.timestamp));

        // use map controller to animate camera with bearing value
        await updateUserLocationCircleAndAnimate(userLocation1);

        navigationInstructionController.checkIsCoordinateInsideCircle(
            directionRouteResponse: directionRouteResponse,
            usersLatLng: userLocation1.position);

        timer.cancel();
      }

      count = count + 1;
    });
  }
}
