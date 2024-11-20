import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/user_speed_notifier_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/widgets/navigation_info_item_widget.dart';

class NavigationInfoUi extends StatelessWidget {
  /// Creates [NavigationInfoUi] instance
  ///
  const NavigationInfoUi({
    super.key,
    required this.directionRouteResponse,
  });

  /// [DirectionRouteResponse] instance
  ///
  final DirectionRouteResponse directionRouteResponse;

  @override
  Widget build(BuildContext context) {
    final speedNotifier = UserSpeedProvider.of(context);
    return Column(
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
                      // listener to update the value of the speed
                      ListenableBuilder(
                          listenable: speedNotifier,
                          builder: (context, child) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0, left: 20.0),
                              child: Text(
                                'Speed: ${speedNotifier.speed.toStringAsFixed(2)} Km/Hr',
                                style: CustomAppStyle.headline6(context),
                              ),
                            );
                          }),

                      // Obx((){
                      //   // List<double> list = navigationController.distanceBtnCOOrds;
                      //   return Padding(padding: const EdgeInsets.only(bottom: 8.0, right: 20.0),
                      //   child: Text('Distance: ${navigationController.distanceBtnCOOrds.value}', style: CustomAppStyle.headline6(context),),);
                      // }),

                      // const SimulateButton(),
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
                            'Expected Time : ${CalculatorUtils.calculateTime(miliSeconds: directionRouteResponse.paths![0].time!)}',
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
                    return NavigationInfoItemUi(
                      index: index,
                      instruction:
                          directionRouteResponse.paths![0].instructions![index],
                    );
                  }),
            )
          ],
        )
      ],
    );
  }
}
