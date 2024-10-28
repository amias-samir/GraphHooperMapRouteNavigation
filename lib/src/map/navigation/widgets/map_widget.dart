import 'package:flutter/cupertino.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/is_simulate_routing_notifier_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/instruction_controller_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/map_controller_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/user_speed_notifier_provider.dart';

/// This is Map Screen which will show up after we start navigation.
///
class MapWidget extends StatelessWidget {
  /// [DirectionRouteResponse]instance
  ///
  final DirectionRouteResponse directionRouteResponse;

  /// Creates [MapWidget] insstance
  ///
  const MapWidget({
    super.key,
    required this.directionRouteResponse,
  });

  @override
  Widget build(BuildContext context) {
    // map controller
    final mapController = MapControllerProvider.of(context);
    //
    return MaplibreMap(
      styleString:
          'https://tiles.basemaps.cartocdn.com/gl/voyager-gl-style/style.json',
      onMapCreated: (mapLibreController) {
        // method which gets executed after the map has been initialized
        mapController.onMapCreated(mapLibreMapController: mapLibreController);
      },
      onStyleLoadedCallback: () {
        // function to be called after the style has been loadded
        _onStyleLoadedCallback(
          mapController.mapController!,
          directionRouteResponse,
          mapController.mapZoomLevel,
        );
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(
            directionRouteResponse
                .paths![0].snappedWaypoints!.coordinates!.first[1],
            directionRouteResponse
                .paths![0].snappedWaypoints!.coordinates!.first[0]),
        zoom: mapController.mapZoomLevel,
      ),
      minMaxZoomPreference: const MinMaxZoomPreference(6, 19),
      myLocationEnabled: true,
      trackCameraPosition: true,
      compassEnabled: false,
      compassViewPosition: CompassViewPosition.TopRight,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      myLocationRenderMode: MyLocationRenderMode.GPS,

      onUserLocationUpdated: (userLocation) {
        // navigation instruction controller
        final navigationInstructionController =
            NavigationInstructionProvider.of(context);

        // speed controller
        final speedNotifierController = UserSpeedProvider.of(context);

        if (!IsSimulateRoutingNotifierController.isSimulateRouting) {
          // update user's physical real location
          mapController.updateUserLocation(userLocation: userLocation);

          // checks if the coordinate is inside the circle
          navigationInstructionController.checkIsCoordinateInsideCircle(
            directionRouteResponse: directionRouteResponse,
            usersLatLng: userLocation.position,
          );

          // update user's speed
          speedNotifierController.setUserSpeed(speed: userLocation.speed);

          // update the bearing value
          mapController.updateBearingBtnTwoCoords(
              bearingValue: userLocation.bearing);
        }
      },
      // cameraTargetBounds: CameraTargetBounds(LatLngBounds( southwest: const LatLng(26.3978980576, 80.0884245137), northeast: const LatLng(26.3978980576, 80.0884245137))),
    );
  }

  void _onStyleLoadedCallback(
    MaplibreMapController mapLibreMapController,
    DirectionRouteResponse directionRouteResponse,
    double zoomLevel,
  ) async {
    mapLibreMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
          directionRouteResponse
              .paths![0].snappedWaypoints!.coordinates!.first[1],
          directionRouteResponse
              .paths![0].snappedWaypoints!.coordinates!.first[0]),
      zoom: zoomLevel,
    )));
  }
}
