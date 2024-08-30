import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/map_controller_provider.dart';
import 'dart:math' as math;

class MapCompassWidget extends StatelessWidget {
  const MapCompassWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mapController = MapControllerProvider.of(context);
    // final mapLibreMapController = mapController.mapController;

    return InkWell(
      onTap: () {
        // animate camera to user location
        // mapLibreMapController?.animateCamera(CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //         target: userLocation.position,
        //         zoom: mapController.mapZoomLevel,
        //         tilt: 0,
        //         bearing: 0.0)))
        //         ;
        mapController.animateCameraWithBearingValue(bearingValue: 0.0);
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            )),
        child: ListenableBuilder(
            listenable: mapController,
            builder: (context, child) {
              return Transform.rotate(
                angle:
                    -mapController.bearingBtnTwoCoords * (math.pi / 180) - 70,
                child: const Center(
                    child: Icon(
                  CupertinoIcons.compass,
                  color: NavigationColors.grey,
                  size: 40.0,
                ))
                // Image.asset(
                //   "assets/compass.png",
                //   height: 50,
                //   alignment: Alignment.centerLeft,
                // )
                ,
              );
            }),
      ),
    );
  }
}
