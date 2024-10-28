import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapDashboardScreen extends StatefulWidget {
  const MapDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MapDashboardScreenState();
  }
}

class MapDashboardScreenState extends State<MapDashboardScreen> {
  MaplibreMapController? controller;

  // ScrollController? draggableSheetController;

  /// water color raster id
  final watercolorRasterId = "watercolorRaster";

  /// selected style id
  int selectedStyleId = 0;

  /// User location instance
  ///
  UserLocation? userLocation;

  bool isInitialize = false;
  double markerSize = 0.5;
  double mapZoomLevel = 14.0;

  DirectionRouteResponse directionRouteResponse = DirectionRouteResponse();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMapCreated(MaplibreMapController controller) async {
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

  void addLayerToMap(DirectionRouteResponse directionRouteResponse) async {
    controller!.clearCircles();
    controller!.clearSymbols();

    if (directionRouteResponse.paths![0].points!.toJson().isNotEmpty) {
      _addSourceAndLineLayer(directionRouteResponse);
    }
  }

  // _onStyleLoadedCallback() async {
  //   controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: userLocation!.position, zoom: 13.0)),);
  // }

  Symbol? symbol;

  Future<void> getDataFromTheServer(LatLng latLng) async {
    if (userLocation == null) return;

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
        graphHooperApiKey:
            dotenv.env["API_KEY"] ?? "Include your API key in the env file");

    if (directionRouteResponse.toJson().isNotEmpty) {
      _addSourceAndLineLayer(directionRouteResponse);
    }

    // Fluttertoast.showToast(msg: 'Feature ID: ${featureId.toString()} \n '
    //     'details: ${placesDetailsDatabaseModel.toMap().toString()}');
  }

  Future<void> _addSourceAndLineLayer(
      DirectionRouteResponse directionRouteResponse) async {
    // if the controller is null returns from function
    if (controller == null) {
      return;
    }
    // Can animate camera to focus on the item
    // controller!.animateCamera(CameraUpdate.newCameraPosition(_kRestaurantsList[index]));

    // Add a polyLine between source and destination
    // Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    final fills = {
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
          .addSource("fills", GeojsonSourceProperties(data: fills));
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

  // gives build navigate to bottom sheet ui
  Widget buildNavigateToBottomSheetUI(
      DirectionRouteResponse directionRouteResponse) {
    _addSourceAndLineLayer(directionRouteResponse);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      padding: const EdgeInsets.all(16.0),
      height: 168.0,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${CalculatorUtils.calculateTime(miliSeconds: directionRouteResponse.paths![0].time!)} (${(directionRouteResponse.paths![0].distance! / 1000).toStringAsFixed(2)}km)',
                style: CustomAppStyle.headline6(context),
              ),
              IconButton(
                  onPressed: () {
                    // pop the bottom sheet
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  icon: const Icon(
                    Icons.close,
                    color: NavigationColors.black,
                  ))
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),

          // start navigation button
          //
          ElevatedButton.icon(
              // color: NaxaAppColors.red,
              onPressed: () async {
                // Get.back();
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WrapperScreen(
                            directionRouteResponse: directionRouteResponse),
                      ));
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

  Widget buildMapUI() {
    return MaplibreMap(
      styleString:
          'https://tiles.basemaps.cartocdn.com/gl/voyager-gl-style/style.json',
      onMapCreated: _onMapCreated,
      // onStyleLoadedCallback: _onStyleLoadedCallback,
      initialCameraPosition: CameraPosition(
        target: const LatLng(27.700769, 85.300140),
        zoom: mapZoomLevel,
      ),
      minMaxZoomPreference: const MinMaxZoomPreference(5, 19),
      myLocationEnabled: true,
      trackCameraPosition: true,
      compassEnabled: true,
      compassViewPosition: CompassViewPosition.TopRight,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) {
        getDataFromTheServer(latLng);
      },
      onUserLocationUpdated: (location) {
        userLocation = location;
      },

      // cameraTargetBounds: CameraTargetBounds(LatLngBounds( southwest: const LatLng( 25.873742 ,79.338507), northeast: const LatLng(28.147416, 89.009072))),
    );
  }

  void onFeatureTap(id, Point<double> point, LatLng coordinates) {
    if (directionRouteResponse.toJson().isNotEmpty) {
      // shows modal bottom sheet to start navigation
      showModalBottomSheet(
          context: context,
          builder: (context) =>
              buildNavigateToBottomSheetUI(directionRouteResponse));
    }
  }
}
