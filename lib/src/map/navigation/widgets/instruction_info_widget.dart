import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/navigation_instruction_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/utils/constants.dart';

/// Gives Instruction info which appears at the top when the user is navigating
/// This also includes the simulation
///
class InstructionInfo extends StatelessWidget {
  const InstructionInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // get navigation instruction controller class
    final instructionInfoController =
        NavigationInstructionProvider.of(context)!;

    // Below widget gets rebuilt whenever there is change in the controller [instructionInfoController]
    return ListenableBuilder(
        listenable: instructionInfoController,
        builder: (context, child) {
          final instruction = instructionInfoController.instruction;
          return Positioned(
            top: 10.0,
            right: MediaQuery.of(context).size.width * 0.2 + 8.0,
            left: 8.0,
            child: (instruction.text != null && instruction.text!.isNotEmpty)
                ? Container(
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: NavigationColors.cardBackgroundColor),
                    child: ListTile(
                      leading: NavigationInstructionsType
                          .getDirectionIconByInstructionType(
                              instructionType: instruction.sign!),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              CalculatorUtils.calculateDistance(
                                  distanceInMeter: instruction.distance!),
                              style: CustomAppStyle.body12pxRegular(context)),
                          Text(
                              CalculatorUtils.calculateTime(
                                  miliSeconds: instruction.time!),
                              style: CustomAppStyle.body12pxRegular(context)),
                        ],
                      ),
                      title: Text(instruction.text!,
                          style: CustomAppStyle.body12pxBold(context)),
                    ),
                  )
                : Container(),
          );
        });
  }
}
