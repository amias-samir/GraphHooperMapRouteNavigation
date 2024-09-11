import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/is_simulate_routing_notifier_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/map_controller_provider.dart';

class SimulateButton extends StatefulWidget {
  const SimulateButton({
    super.key,
  });

  @override
  State<SimulateButton> createState() => _SimulateButtonState();
}

class _SimulateButtonState extends State<SimulateButton> {
  @override
  Widget build(BuildContext context) {
    final mapController = MapControllerProvider.of(context);
    return SizedBox(
      height: 30.0,
      child: MaterialButton(
          child: const Text(
            'Simulate',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            // toggle the value
            IsSimulateRoutingNotifierController.toggleIsSimulatingValue();

            // calls method
            mapController.simulateRouting();
          }),
    );
  }
}
