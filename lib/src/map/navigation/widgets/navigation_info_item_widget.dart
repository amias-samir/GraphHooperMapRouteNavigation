import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/model/instructions.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/constants.dart';

class NavigationInfoItemUi extends StatelessWidget {
  /// Creates [NavigationInfoItemUi] instance
  ///
  const NavigationInfoItemUi({
    super.key,
    required this.index,
    required this.instruction,
  });

  /// [index] integer value
  ///
  final int index;

  /// [Instruction] instance
  ///
  final Instruction instruction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: index != 0 && instruction.sign! == 0
              ? NavigationInstructionsType.getDirectionIconByInstructionType(
                  instructionType: index == 0 ? 10 : instruction.sign!)
              : NavigationInstructionsType.getDirectionIconByInstructionType(
                  instructionType: index == 0 ? 10 : instruction.sign!),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  CalculatorUtils.calculateDistance(
                      distanceInMeter: instruction.distance!),
                  style: CustomAppStyle.body12pxRegular(context)),
              Text(
                  CalculatorUtils.calculateTime(miliSeconds: instruction.time!),
                  style: CustomAppStyle.body12pxRegular(context)),
            ],
          ),
          title: Text(instruction.text!,
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
}
