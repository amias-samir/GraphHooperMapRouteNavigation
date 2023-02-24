import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:mapbox_gl_modified/mapbox_gl_modified.dart';

class MapDashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MapDashboardScreenState();
  }
}

class MapDashboardScreenState extends State<MapDashboardScreen> {
  MapboxMapController? controller;
  // ScrollController? draggableSheetController;
  final watercolorRasterId = "watercolorRaster";
  int selectedStyleId = 0;
  UserLocation? userLocation = UserLocation(
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
  bool isInitialize = false;

  double markerSize = 0.5;
  double mapZoomLevel = 14.0;

  DirectionRouteResponse directionRouteResponse = DirectionRouteResponse();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String mapAccessToken = 'YOUR_MAPBOX_PUBLIC_TOKEN';

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;

    controller.onFeatureTapped.add(onFeatureTap);

    controller.addListener(() {
      mapZoomLevel = controller.cameraPosition!.zoom;
    });
    // updateCameraONLocateMeTap();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // updateCameraONLocateMeTap();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  addLayerToMap(DirectionRouteResponse directionRouteResponse) async {
    controller!.clearCircles();
    controller!.clearSymbols();

    if (directionRouteResponse.paths![0].points!.toJson().isNotEmpty) {
      _addSourceAndLineLayer(directionRouteResponse);
    }
  }

  _onStyleLoadedCallback() async {
    controller!.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: userLocation!.position, zoom: 13.0)),
    );
  }

  Symbol? symbol;
  getDataFromTheServer(LatLng latLng) async {
    debugPrint(
      'getDataFromTheServer LatLng: ${latLng.toString()}  \n',
    );

    try {
      controller!.removeSymbol(symbol!);
    } catch (exception) {
      debugPrint('$exception');
    }

    symbol = await controller!.addSymbol(SymbolOptions(
      geometry: latLng,
      iconSize: markerSize,
      iconImage: "assets/icon/health_icon.png",
    ));

    ApiRequest apiRequest = ApiRequest();

    directionRouteResponse = await apiRequest.getDrivingRouteUsingGraphHooper(
        source: userLocation!.position,
        destination: latLng,
        navigationType: NavigationProfile.car,
        graphHooperApiKey: 'Your GraphHooper API Key');

    if (directionRouteResponse.toJson().isNotEmpty) {
      _addSourceAndLineLayer(directionRouteResponse);
    }

    // Fluttertoast.showToast(msg: 'Feature ID: ${featureId.toString()} \n '
    //     'details: ${placesDetailsDatabaseModel.toMap().toString()}');
  }

  _addSourceAndLineLayer(DirectionRouteResponse directionRouteResponse) async {
    // Can animate camera to focus on the item
    // controller!.animateCamera(CameraUpdate.newCameraPosition(_kRestaurantsList[index]));

    // Add a polyLine between source and destination
    // Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": directionRouteResponse.paths![0].points!.toJson(),
        },
      ],
    };

    // Remove lineLayer and source if it exists
    await controller!.removeLayer("lines");
    await controller!.removeSource("fills");

    try {
      // Add new source and lineLayer
      await controller!
          .addSource("fills", GeojsonSourceProperties(data: _fills));
      await controller!.addLineLayer(
        "fills",
        "lines",
        LineLayerProperties(
          lineColor: Colors.blue.toHexStringRGB(),
          lineCap: "round",
          lineJoin: "round",
          lineWidth: 5,
        ),
      );
    } catch (exception) {
      debugPrint('$exception');
    }
  }

  CalculatorUtils calculatorUtils = CalculatorUtils();
  buildNavigateToBottomSheetUI(DirectionRouteResponse directionRouteResponse) {
    _addSourceAndLineLayer(directionRouteResponse);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      padding: EdgeInsets.all(16.0),
      height: 168.0,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${calculatorUtils.calculateTime(miliSeconds: directionRouteResponse.paths![0].time!)} (${(directionRouteResponse.paths![0].distance! / 1000).toStringAsFixed(2)}km)',
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    height: 1.25,
                    letterSpacing: 0.0,
                    color: Colors.black),
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: NavigationColors.black,
                  ))
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: ElevatedButton.icon(
                // color: NaxaAppColors.red,
                onPressed: () async {
                  Get.back();
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Get.to(MapRouteNavigationScreenPage(
                        directionRouteResponse, mapAccessToken));
                  });
                },
                icon: const Icon(
                  Icons.navigation_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Start Navigation',
                  style: CustomAppStyle.body14pxRegular(context)
                      .copyWith(color: NavigationColors.white.withOpacity(0.9)),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // markerSize =  (MediaQuery.of(context).size.width*0.0015);

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: buildMapUI(),
    );
  }

  buildMapUI() {
    return MapboxMap(
      styleString: MapboxStyles.MAPBOX_STREETS,
      accessToken: mapAccessToken,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoadedCallback,
      // initialCameraPosition: const CameraPosition(target: LatLng(27.7172, 85.3240)),
      initialCameraPosition: CameraPosition(
        target: LatLng(28.987280, 80.1652),
        zoom: mapZoomLevel,
      ),
      minMaxZoomPreference: const MinMaxZoomPreference(6, 18),
      myLocationEnabled: true,
      trackCameraPosition: true,
      compassEnabled: true,
      compassViewPosition: CompassViewPosition.TopRight,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) {
        getDataFromTheServer(latLng);
      },
      onUserLocationUpdated: (userLocation1) {
        userLocation = userLocation1;
        controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(userLocation!.position.latitude,
                userLocation!.position.longitude),
            zoom: mapZoomLevel,
            bearing: userLocation!.bearing!)));
      },
      // cameraTargetBounds: CameraTargetBounds(LatLngBounds( southwest: const LatLng( 25.873742 ,79.338507), northeast: const LatLng(28.147416, 89.009072))),
    );
  }

// /modified
  void onFeatureTap(
      dynamic featureId, dynamic featureDetail, Point point, LatLng latlng) {
    if (directionRouteResponse.toJson().isNotEmpty) {
      Get.bottomSheet(
        buildNavigateToBottomSheetUI(directionRouteResponse),
        enableDrag: true,
        persistent: false,
        ignoreSafeArea: true,
        isScrollControlled: true,
      );
    }
  }
}
