import 'dart:math' as math;
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/app_styles.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import 'package:text_to_speech/text_to_speech.dart';


import 'controllers/route_navigation_controller.dart';
import 'model/direction_route_response.dart';
import 'model/instructions.dart';
import 'utils/calculator_utils.dart';
import 'utils/navigation_app_colors.dart';

class MapRouteNavigationScreenPage extends StatefulWidget{
  DirectionRouteResponse directionRouteResponse;
  String mapAccesstoken;
  static const IconData compass = IconData(0xf8ca, fontFamily: 'iconFont', fontPackage: 'iconFontPackage');


  MapRouteNavigationScreenPage(this.directionRouteResponse, this.mapAccesstoken);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MapRouteNavigationScreenPageState();
  }

}

class MapRouteNavigationScreenPageState extends State<MapRouteNavigationScreenPage> {

  final navigationController = Get.put(RouteNavigationRouteController());

  // TextToSpeech textToSpeech = TextToSpeech();


  MaplibreMapController? controller;
  UserLocation? userLocation;
  UserLocation? usersLastLocation;
  Circle? symbol;

  DirectionRouteResponse? directionRouteResponse;

  bool isSimulateRouting = false;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKeyRoute = GlobalKey<ScaffoldMessengerState>();

  double mapZoomLevel = 14.0;

  _onMapCreated(MaplibreMapController controller1) async   {
    controller = controller1;

    if(directionRouteResponse != null && directionRouteResponse!.toJson().isNotEmpty){
      Map<String, dynamic> routeResponse = {
        "geometry": directionRouteResponse!.paths![0].points!.toJson(),
        "duration": directionRouteResponse!.paths![0].time,
        "distance": directionRouteResponse!.paths![0].distance,
      };
      _addSourceAndLineLayer(routeResponse);
    }


    controller!.addListener(() {
      mapZoomLevel = controller!.cameraPosition!.zoom;
    });

    // controller.onFeatureTapped.add(onFeatureTap);

    navigationSimulationListner();

    rotateMapOnBearingChange();

  }


  @override
  void initState() {
    userLocation = UserLocation(position:  const LatLng(28.987280, 80.1652), altitude: 1200.0, bearing: 0.0, speed: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0, timestamp: DateTime.now(),
        heading: UserHeading(magneticHeading: 0.0, trueHeading: 0.0, headingAccuracy: 0.0, x: 0.0, y: 0.0, z: 0.0, timestamp: DateTime.now()) );
    directionRouteResponse = widget.directionRouteResponse;
    super.initState();

    // textToSpeech.setLanguage('en-US');
    // navigationController.setEnableAudio(enableAudio: true, textToSpeech: textToSpeech );
    navigationController.findInstructionsCoordsAndIndex(directionRouteResponse: directionRouteResponse!);

  }

  _onStyleLoadedCallback() async {
    controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[1],
        directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[0]),
        zoom: mapZoomLevel)));

  }

  _animateCameraToUserLoation({double? zoomLevel, double? bearing}){
      controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(userLocation!.position.latitude, userLocation!.position.longitude),
          zoom:  zoomLevel?? mapZoomLevel,
      bearing: bearing ?? userLocation!.bearing!)));

  }



  onFeatureTap(dynamic featureId, Point point, LatLng latLng) async {
    // Fluttertoast.showToast(msg: 'Feature ID: ${featureId.toString()} \n '
    //     'Coordinates: ${latLng.toString()}');

  }

  void showInSnackBar(String value) {
    _scaffoldKeyRoute.currentState?.showSnackBar( SnackBar(content: Text(value),
    ));

  }


  _addSourceAndLineLayer(Map<String, dynamic> modifiedResponse ) async {
    addStartAndEndMarker();
    final _fills = {
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
    await controller!.removeLayer("lines");
    await controller!.removeSource("fills");

    // Add new source and lineLayer
    await controller!.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller!.addLineLayer(
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


  Future<bool> _willPopCallback() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
        Get.back();
      });
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    // TODO: implement build
    return WillPopScope(
      onWillPop: _willPopCallback ,
      child: Scaffold(
        key: _scaffoldKeyRoute,
        body: SafeArea(
          child: ExpandableBottomSheet(
            persistentContentHeight: MediaQuery.of(context).size.height*0.1,
            background: buildBackgroundUi(),

            persistentHeader: buildPersistentHeaderUi(),
            expandableContent: buildExpandableContentUi(),
          ),
        ),
      ),
    );
  }

  buildBackgroundUi(){
    return Stack(
        children:[
          buildMapUi(),
          buildCompass(),
          buildInstructionInfo()
        ]
    );
  }

  buildMapUi(){
    return MaplibreMap(
      styleString: 'https://tiles.basemaps.cartocdn.com/gl/voyager-gl-style/style.json',
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoadedCallback,
      initialCameraPosition: CameraPosition(target: LatLng(directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[1],
          directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[0]),
        zoom: mapZoomLevel,
      ),
      minMaxZoomPreference: const MinMaxZoomPreference(6, 19),
      myLocationEnabled: true,
      trackCameraPosition: true,
      compassEnabled: true,
      compassViewPosition: CompassViewPosition.TopRight,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onUserLocationUpdated: (userLocation){
        this.userLocation = userLocation;

        if(!isSimulateRouting) {
          navigationController.checkIsCoordinateInsideCircle(usersLatLng: userLocation.position);
          controller!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(userLocation.position
                  .latitude, userLocation.position.longitude),
                  zoom: mapZoomLevel,
                  bearing: userLocation.bearing!)));

          navigationController.updateSpeed(speed: userLocation.speed!);
          navigationController.updateBearing(bearing: userLocation.bearing!);
        }
      },
      // cameraTargetBounds: CameraTargetBounds(LatLngBounds( southwest: const LatLng(26.3978980576, 80.0884245137), northeast: const LatLng(26.3978980576, 80.0884245137))),
    );
  }

  buildNavigationInfoUi() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [

          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.08,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx((){
                          return  Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, left: 20.0),
                            child: Text('Speed : ${navigationController.userSpeed.value}', style: CustomAppStyle.headline6(context)),
                          );
                        }),

                        // Obx((){
                        //   // List<double> list = navigationController.distanceBtnCOOrds;
                        //   return Padding(padding: const EdgeInsets.only(bottom: 8.0, right: 20.0),
                        //   child: Text('Distance: ${navigationController.distanceBtnCOOrds.value}', style: CustomAppStyle.headline6(context),),);
                        // }),

                        SizedBox(
                          height: 30.0,
                          child: MaterialButton(
                            child: const Text('Simulate', style: TextStyle(color: Colors.black),),
                          onPressed: (){
                              isSimulateRouting = !isSimulateRouting;
                            navigationController.simulateRouting(directionRouteResponse!, userLocation!, simulateRoute: isSimulateRouting);
                          }),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text('Distance : ${calculatorUtils.calculateDistance(distanceInMeter: directionRouteResponse!.paths![0].distance!)}', style: CustomAppStyle.headline6(context)),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text('Time : ${calculatorUtils.calculateTime(miliSeconds: directionRouteResponse!.paths![0].time!)}', style: CustomAppStyle.headline6(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.6,
                child: ListView.builder(
                  itemCount: directionRouteResponse!.paths![0].instructions!.length,
                    itemBuilder: (buildContext, index){

                    return buildNavigationInfoItemUi(index:index  ,instructions: directionRouteResponse!.paths![0].instructions![index]);
                    }),
              )
            ],
          )

        ],
      ),
    );
  }

  buildNavigationInfoItemUi({required index, required Instructions instructions}){
    return Column(
      children: [
        ListTile(
          leading: index != 0 && instructions.sign! == 0?
          getDirectionIconByInstructionType(instructionType: index == 0? 10: instructions.sign!) :
          getDirectionIconByInstructionType(instructionType: index == 0? 10: instructions.sign!),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('${calculatorUtils.calculateDistance(distanceInMeter: instructions.distance!)}', style: CustomAppStyle.body12pxRegular(context)),
              Text('${calculatorUtils.calculateTime(miliSeconds :instructions.time!)}', style: CustomAppStyle.body12pxRegular(context)),
            ],
          ),
          title:Text(instructions.text!, style: CustomAppStyle.body12pxBold(context)),
        ),
        Container(height: 1.0, width: MediaQuery.of(context).size.width,
          color: NavigationColors.greyLight,)
      ],
    );
  }


  buildCompass() {

    return Positioned(
        top: 20.0,
        right: 16.0,
        child: Column(
          children: [
            Obx(() {
      // if(navigationController.bearingBtnCOOrds.value != 0.0){
            return  InkWell(
              onTap: () {
                controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                    target: usersLastLocation!.position,
                    zoom: mapZoomLevel,
                    tilt: 0,
                    bearing: 0.0)));

                navigationController.updateBearing(bearing: 0.0);
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
                child: Transform.rotate(
                  angle: -navigationController.bearingBtnCOOrds.value * (math.pi / 180)-70 ,
                  child:  const Center(child: Icon(CupertinoIcons.compass, color: NavigationColors.grey, size: 40.0,))
                  // Image.asset(
                  //   "assets/compass.png",
                  //   height: 50,
                  //   alignment: Alignment.centerLeft,
                  // )
                  ,
                ),
              ),
            );
      // }else{
      //       return  const SizedBox(
      //         height: 50,
      //         width: 50,
      //       );
      // }
    }),

            const SizedBox(height: 20.0,),

            Obx((){
              return FloatingActionButton(
                heroTag: 'tag_sound_enable_disable',
                onPressed: () async {
                  navigationController.setEnableAudio(enableAudio: !navigationController.enabledAudio.value);
                  },
                backgroundColor: NavigationColors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      width: 1, color: NavigationColors.boxBorderColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                child:  Icon(
                  navigationController.enabledAudio.value ? Icons.volume_up : Icons.volume_off,
                  size: 24,
                  color: NavigationColors.grey,
                ),
              );
            }),


            const SizedBox(height: 20.0,),

            FloatingActionButton(
              heroTag: 'tag_my_location_zoom',
              onPressed: () async {
                _animateCameraToUserLoation(zoomLevel: 19.0, bearing: 0.0);
              },
              backgroundColor: NavigationColors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                    width: 1, color: NavigationColors.boxBorderColor),
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              child: const Icon(
                Icons.gps_fixed,
                size: 24,
                color: NavigationColors.grey,
              ),
            ),




          ],
        ));
  }

  buildInstructionInfo() {

    return Positioned(
        top: 10.0,
        right: (MediaQuery.of(context).size.width*0.2)+8.0,
        left: 8.0,
        child: Obx(() {
          if(navigationController.instruction.value.text!.isNotEmpty){
            // String imageUrl = navigationInstructionsImage.getImageUrlByInstructionType(instructionType: navigationController.instruction.value.sign!);
            return  Container(
              width: MediaQuery.of(context).size.width*.7,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: NavigationColors.cardBackgroundColor
                ),
                child: ListTile(
                  leading:
                  // imageUrl.isEmpty ? const SizedBox() :
                  // CachedNetworkImage(
                  //   imageUrl: imageUrl,
                  //   fit: BoxFit.contain, height: 30.0, width: 30.0,)
                    getDirectionIconByInstructionType(instructionType: navigationController.instruction.value.sign!),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('${calculatorUtils.calculateDistance(distanceInMeter: navigationController.instruction.value.distance!)}', style: CustomAppStyle.body12pxRegular(context)),
                      Text('${calculatorUtils.calculateTime(miliSeconds :navigationController.instruction.value.time!)}', style: CustomAppStyle.body12pxRegular(context)),
                    ],
                  ),
                  title:Text(navigationController.instruction.value.text!, style: CustomAppStyle.body12pxBold(context)),
                ),
            );
          }else{
            return  Container();
          }
        }));
  }

  buildPersistentHeaderUi(){
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      child: Center(
        child: SizedBox(
          height: 6.0,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(3) // use instead of BorderRadius.all(Radius.circular(20))
            ),
          ),
        ),
      ),
    );
  }

  buildExpandableContentUi(){
    return Container(
      height: MediaQuery.of(context).size.height*0.71,
      color: Colors.white,
      child: buildNavigationInfoUi(),
    );
  }

  Future<Uint8List> loadMarkerImage(String assetsPath) async {
    var byteData = await rootBundle.load(assetsPath);
    return byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  }


  void navigationSimulationListner()  {
    navigationController.userLocation.stream.listen((userLocation) async {

      if(userLocation != usersLastLocation && symbol == null){
        await controller!.removeCircle(symbol!);
       symbol = await controller!.addCircle(
          CircleOptions(
              geometry: LatLng(directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[1],
                  directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[0]),
              circleColor: NavigationColors.green.toHexStringRGB(),
              circleRadius: 12),
        );
      }



      if(userLocation != null){

        controller!.updateCircle(symbol!, CircleOptions(
            geometry: LatLng(directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[1],
                directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[0]),
            circleColor: NavigationColors.green.toHexStringRGB(),
            circleRadius: 12));

        // controller!.animateCamera(CameraUpdate.newCameraPosition(
        //     CameraPosition(target: LatLng(userLocation.position
        //         .latitude, userLocation.position.longitude),
        //         zoom: mapZoomLevel,
        //         bearing: navigationController.bearingBtnCOOrds.value)));
      }

      usersLastLocation = userLocation;
    });
  }

  void addStartAndEndMarker() async {
    controller!.addCircle(
      CircleOptions(
          geometry: LatLng(directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[1],
              directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.first[0]),
          circleColor: NavigationColors.green.toHexStringRGB(),
      circleRadius: 12),
    );

    controller!.addCircle(
      CircleOptions(
          geometry: LatLng(directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.last[1],
              directionRouteResponse!.paths![0].snappedWaypoints!.coordinates!.last[0]),
          circleColor: NavigationColors.red.toHexStringRGB(),
      circleRadius: 12),
    );
  }

  void rotateMapOnBearingChange() {
    navigationController.bearingBtnCOOrds.stream.listen((event) {
      controller!.animateCamera(CameraUpdate.bearingTo(navigationController.bearingBtnCOOrds.value));
      // navigationController.updateDistanceBtnCOOrds(distance: event);
    });
  }
}