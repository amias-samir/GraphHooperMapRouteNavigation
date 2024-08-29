import 'package:flutter/cupertino.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/map_controller_provider.dart';

//TODO: Uncomment onUser location updated call back

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

      // onUserLocationUpdated: (userLocation) {
      //   this.userLocation = userLocation;

      //   if (!isSimulateRouting) {
      //     navigationController.checkIsCoordinateInsideCircle(
      //         usersLatLng: userLocation.position);
      //     controller.animateCamera(CameraUpdate.newCameraPosition(
      //         CameraPosition(
      //             target: LatLng(userLocation.position.latitude,
      //                 userLocation.position.longitude),
      //             zoom: mapZoomLevel,
      //             bearing: userLocation.bearing!)));

      //     navigationController.updateSpeed(speed: userLocation.speed!);
      //     navigationController.updateBearing(bearing: userLocation.bearing!);
      //   }
      // },
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

//  Widget buildMapUi() {
//     return MaplibreMap(
//       styleString:
//           'https://tiles.basemaps.cartocdn.com/gl/voyager-gl-style/style.json',
//       onMapCreated: ,
//       onStyleLoadedCallback: _onStyleLoadedCallback,
//       initialCameraPosition: CameraPosition(
//         target: LatLng(
//             directionRouteResponse
//                 .paths![0].snappedWaypoints!.coordinates!.first[1],
//             directionRouteResponse
//                 .paths![0].snappedWaypoints!.coordinates!.first[0]),
//         zoom: mapZoomLevel,
//       ),
//       minMaxZoomPreference: const MinMaxZoomPreference(6, 19),
//       myLocationEnabled: true,
//       trackCameraPosition: true,
//       compassEnabled: false,
//       compassViewPosition: CompassViewPosition.TopRight,
//       myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
//       myLocationRenderMode: MyLocationRenderMode.GPS,
//       onUserLocationUpdated: (userLocation) {
//         this.userLocation = userLocation;

//         if (!isSimulateRouting) {
//           navigationController.checkIsCoordinateInsideCircle(
//               usersLatLng: userLocation.position);
//           controller.animateCamera(CameraUpdate.newCameraPosition(
//               CameraPosition(
//                   target: LatLng(userLocation.position.latitude,
//                       userLocation.position.longitude),
//                   zoom: mapZoomLevel,
//                   bearing: userLocation.bearing!)));

//           navigationController.updateSpeed(speed: userLocation.speed!);
//           navigationController.updateBearing(bearing: userLocation.bearing!);
//         }
//       },
//       // cameraTargetBounds: CameraTargetBounds(LatLngBounds( southwest: const LatLng(26.3978980576, 80.0884245137), northeast: const LatLng(26.3978980576, 80.0884245137))),
//     );
//   }
