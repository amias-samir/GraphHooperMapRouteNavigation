import 'package:flutter/material.dart';

class IsSimulateRoutingNotifierController {
  static final ValueNotifier<bool> isSimulateRoutingNotifier =
      ValueNotifier<bool>(false);

  static bool get isSimulateRouting => isSimulateRoutingNotifier.value;

  /// Method to toggle the value of the [isSimulateRoutingNotifier]
  /// if the value is already simulating then on again calling this function
  /// stops the simulation
  ///
  static void toggleIsSimulatingValue({
    required VoidCallback onSimulationStopped,
    required VoidCallback onSimulationStart,
  }) {
    if (isSimulateRouting) {
      onSimulationStopped.call();
    } else {
      onSimulationStart.call();
    }

    // update the notifier
    isSimulateRoutingNotifier.value = !isSimulateRouting;
  }
}
