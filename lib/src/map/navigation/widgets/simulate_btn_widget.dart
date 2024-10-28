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
    final isSimulatingRouting =
        IsSimulateRoutingNotifierController.isSimulateRouting;
    return SizedBox(
      height: 30.0,
      child: MaterialButton(
          child: ValueListenableBuilder<bool>(
              valueListenable:
                  IsSimulateRoutingNotifierController.isSimulateRoutingNotifier,
              builder: (context, val, child) {
                return Text(
                  val ? 'Stop Simulation' : "Simulate",
                  style: const TextStyle(color: Colors.black),
                );
              }),
          onPressed: () {
            // toggle the value
            IsSimulateRoutingNotifierController.toggleIsSimulatingValue(
              onSimulationStopped: () {
                mapController.stopSimulation();
              },
              onSimulationStart: () {
                mapController.simulateRouting();
              },
            );
          }),
    );
  }
}
