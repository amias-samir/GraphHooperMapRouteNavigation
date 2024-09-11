import 'package:flutter/material.dart';

class IsSimulateRoutingNotifierController {
  static final ValueNotifier<bool> _isSimulateRouting =
      ValueNotifier<bool>(false);

  static bool get isSimulateRouting => _isSimulateRouting.value;

  static void updateIsSimulateRoutingValue({
    required bool simulateRouting,
  }) {
    _isSimulateRouting.value = simulateRouting;
  }

  static void toggleIsSimulatingValue() {
    _isSimulateRouting.value = !isSimulateRouting;
  }
}
