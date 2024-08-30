import 'dart:math';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/audio_instruction_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/map_controller_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/app_styles.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/constants.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/widgets/instruction_info_widget.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/widgets/map_compass_widget.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/widgets/map_widget.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/widgets/my_location_zoom_icon_widget.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../controllers/route_navigation_controller.dart';
import '../model/direction_route_response.dart';
import '../model/instructions.dart';
import '../utils/calculator_utils.dart';
import '../utils/navigation_app_colors.dart';

class MapRouteNavigationScreenPage extends StatefulWidget {
  final DirectionRouteResponse directionRouteResponse;
  static const IconData compass =
      IconData(0xf8ca, fontFamily: 'iconFont', fontPackage: 'iconFontPackage');

  const MapRouteNavigationScreenPage(this.directionRouteResponse, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MapRouteNavigationScreenPageState();
  }
}

class MapRouteNavigationScreenPageState
    extends State<MapRouteNavigationScreenPage> {
  final navigationController = Get.put(RouteNavigationRouteController());

  // TextToSpeech textToSpeech = TextToSpeech();

  late MaplibreMapController controller;
  // late UserLocation userLocation;

  late DirectionRouteResponse directionRouteResponse;

  bool isSimulateRouting = false;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKeyRoute =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // direction route response initialization
    directionRouteResponse = widget.directionRouteResponse;

    // textToSpeech.setLanguage('en-US');
    // navigationController.setEnableAudio(enableAudio: true, textToSpeech: textToSpeech );
  }

  void onFeatureTap(dynamic featureId, Point point, LatLng latLng) async {
    // Fluttertoast.showToast(msg: 'Feature ID: ${featureId.toString()} \n '
    //     'Coordinates: ${latLng.toString()}');
  }

  void showInSnackBar(String value) {
    _scaffoldKeyRoute.currentState?.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  Future<bool> _willPopCallback(bool didPop) async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Get.back();
    });
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    // TODO: implement build
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        _willPopCallback(didPop);
      },
      child: Scaffold(
        key: _scaffoldKeyRoute,
        body: SafeArea(
          child: ExpandableBottomSheet(
            persistentContentHeight: MediaQuery.of(context).size.height * 0.1,
            background: buildBackgroundUi(),
            persistentHeader: buildPersistentHeaderUi(),
            expandableContent: buildExpandableContentUi(),
          ),
        ),
      ),
    );
  }

  Widget buildBackgroundUi() {
    return Stack(children: [
      MapWidget(
        directionRouteResponse: directionRouteResponse,
      ),
      buildCompass(),
      const InstructionInfo()
    ]);
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
                height: MediaQuery.of(context).size.height * 0.08,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 20.0),
                            child: Text(
                                'Speed : ${navigationController.userSpeed.value}',
                                style: CustomAppStyle.headline6(context)),
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
                              child: const Text(
                                'Simulate',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                isSimulateRouting = !isSimulateRouting;
                                navigationController.simulateRouting(
                                    directionRouteResponse,
                                    mapScreenController.userLocation,
                                    simulateRoute: isSimulateRouting);
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
                          child: Text(
                              'Distance : ${CalculatorUtils.calculateDistance(distanceInMeter: directionRouteResponse.paths![0].distance!)}',
                              style: CustomAppStyle.headline6(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                              'Time : ${CalculatorUtils.calculateTime(miliSeconds: directionRouteResponse.paths![0].time!)}',
                              style: CustomAppStyle.headline6(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    itemCount:
                        directionRouteResponse.paths![0].instructions!.length,
                    itemBuilder: (buildContext, index) {
                      return buildNavigationInfoItemUi(
                          index: index,
                          instructions: directionRouteResponse
                              .paths![0].instructions![index]);
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  buildNavigationInfoItemUi(
      {required index, required Instruction instructions}) {
    return Column(
      children: [
        ListTile(
          leading: index != 0 && instructions.sign! == 0
              ? NavigationInstructionsType.getDirectionIconByInstructionType(
                  instructionType: index == 0 ? 10 : instructions.sign!)
              : NavigationInstructionsType.getDirectionIconByInstructionType(
                  instructionType: index == 0 ? 10 : instructions.sign!),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  CalculatorUtils.calculateDistance(
                      distanceInMeter: instructions.distance!),
                  style: CustomAppStyle.body12pxRegular(context)),
              Text(
                  CalculatorUtils.calculateTime(
                      miliSeconds: instructions.time!),
                  style: CustomAppStyle.body12pxRegular(context)),
            ],
          ),
          title: Text(instructions.text!,
              style: CustomAppStyle.body12pxRegular(context)),
        ),
        Container(
          height: 1.0,
          width: MediaQuery.of(context).size.width,
          color: NavigationColors.greyLight,
        )
      ],
    );
  }

  Widget buildCompass() {
    return Positioned(
        top: 20.0,
        right: 16.0,
        child: Column(
          children: [
            const MapCompassWidget(),
            const SizedBox(
              height: 20.0,
            ),
            const AudioIconWidget(),
            const SizedBox(
              height: 20.0,
            ),
            CustomFloatingActionButton(
                heroTag: 'tag_my_location_zoom',
                onPressed: () {
                  // animate user to current location
                  final mapScreenController = MapControllerProvider.of(context);
                  mapScreenController.animateUserToCurrentLocation(
                      zoomLevel: 19.0, bearing: 0.0);
                },
                iconData: Icons.gps_fixed),
          ],
        ));
  }

  Container buildPersistentHeaderUi() {
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                borderRadius: BorderRadius.circular(
                    3) // use instead of BorderRadius.all(Radius.circular(20))
                ),
          ),
        ),
      ),
    );
  }

  Container buildExpandableContentUi() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.71,
      color: Colors.white,
      child: buildNavigationInfoUi(),
    );
  }

  Future<Uint8List> loadMarkerImage(String assetsPath) async {
    var byteData = await rootBundle.load(assetsPath);
    return byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  }

  /// This function rotates the map on the bearing change
  ///
  // void rotateMapOnBearingChange() {
  //   navigationController.bearingBtnCOOrds.stream.listen((event) {
  //     controller.animateCamera(
  //         CameraUpdate.bearingTo(navigationController.bearingBtnCOOrds.value));
  //     // navigationController.updateDistanceBtnCOOrds(distance: event);
  //   });
  // }
}

class AudioIconWidget extends StatelessWidget {
  const AudioIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final audioInstructionController = AudioInstructionProvider.of(context);
    return ListenableBuilder(
        listenable: audioInstructionController,
        builder: (context, child) {
          final isAudioEnabled = audioInstructionController.enableAudio;

          return CustomFloatingActionButton(
              heroTag: 'tag_sound_enable_disable',
              onPressed: () {
                // toggle enable audio
                audioInstructionController.setEnableAudio(
                  enableAudio: !isAudioEnabled,
                );
              },
              iconData: isAudioEnabled ? Icons.volume_up : Icons.volume_off);
        });
  }
}
