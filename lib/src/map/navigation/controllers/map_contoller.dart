import 'package:flutter/cupertino.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';

///
/// Notifier class for [MapScreen]
///
class MapScreenController extends ChangeNotifier {
  /// private [MaplibreMapController] instance
  ///
  MaplibreMapController? _mapController;

  /// Getter for mapbox controller instance
  ///
  MaplibreMapController? get mapController => _mapController;

  /// User's starting Location circle
  ///
  Circle? startingUserLocationCircle;

  /// [DirectionRouteResponse] instance variable that comes from Api Call.
  ///
  DirectionRouteResponse? directionRouteResponse;

  /// Map zoom level
  ///
  double mapZoomLevel = 14.0;

  /// Bearing value btn two co-ordinates
  ///
  double bearingBtnTwoCoords = 0.0;

  /// Method to handle on map created callback
  ///
  void onMapCreated({
    required MaplibreMapController mapLibreMapController,
    VoidCallback? extraFunc,
  }) {
    // initialize map controller
    _mapController = mapLibreMapController;

    if (directionRouteResponse == null || _mapController == null) return;

    if (directionRouteResponse!.toJson().isNotEmpty) {
      Map<String, dynamic> routeResponse = {
        "geometry": directionRouteResponse!.paths![0].points!.toJson(),
        "duration": directionRouteResponse!.paths![0].time,
        "distance": directionRouteResponse!.paths![0].distance,
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

    notifyListeners();
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
    if (_mapController == null || directionRouteResponse == null) {
      return;
    }

    // starting circle
    startingUserLocationCircle = await _mapController!.addCircle(
      CircleOptions(
          geometry: LatLng(
              directionRouteResponse!
                  .paths![0].snappedWaypoints!.coordinates!.first[1],
              directionRouteResponse!
                  .paths![0].snappedWaypoints!.coordinates!.first[0]),
          circleColor: NavigationColors.green.toHexStringRGB(),
          circleRadius: 12),
    );

    // destination circle
    _mapController!.addCircle(
      CircleOptions(
          geometry: LatLng(
              directionRouteResponse!
                  .paths![0].snappedWaypoints!.coordinates!.last[1],
              directionRouteResponse!
                  .paths![0].snappedWaypoints!.coordinates!.last[0]),
          circleColor: NavigationColors.red.toHexStringRGB(),
          circleRadius: 12),
    );
  }

  /// Method to update [UserLocation] circle
  /// And animate camera to user location
  ///
  void updateUserLocationCircleAndAnimate(UserLocation userLocation) async {
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

  /// Method to intialize Direction route response
  ///
  void initializeDirectionRouteRes({
    required DirectionRouteResponse directionRouteResponse,
  }) {
    this.directionRouteResponse = directionRouteResponse;
  }
}
