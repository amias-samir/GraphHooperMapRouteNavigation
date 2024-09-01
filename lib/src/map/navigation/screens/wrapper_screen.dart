import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/audio_instruction_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/map_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/navigation_instruction_controller.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/speed_notifier.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/audio_instruction_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/instruction_controller_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/map_controller_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/providers/user_speed_notifier_provider.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/screens/map_route_navigation_screen.dart';

/// WrapperScreen: A composite screen that chains multiple InheritedWidgets to manage
/// and provide different state controllers throughout the application.
///
/// Main Purpose:
/// - To centralize the provision of state management objects (`ChangeNotifier` instances)
///   using InheritedWidgets, making them accessible across the widget tree.
/// - To create a modular and reusable setup for state management within a Flutter package,
///   allowing seamless integration of various state controllers (e.g., user settings, theme settings, navigation instructions).
/// - To facilitate easy state access and updates without relying on third-party dependencies
///   like Provider, thus keeping the package lightweight and focused on built-in Flutter mechanisms.
class WrapperScreen extends StatefulWidget {
  /// [DirectionRouteResponse] instance
  ///
  final DirectionRouteResponse directionRouteResponse;

  /// [WrapperScreen] constructor
  ///
  const WrapperScreen({
    super.key,
    required this.directionRouteResponse,
  });

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  /// [AudioInstructionController] instance this class will be passed down the widget tree.
  ///
  final audioInstructionController = AudioInstructionController();

  /// [NavigationInstructionController] that will be passed down the widget tree
  ///
  late final navigationInstructionController = NavigationInstructionController(
    directionRouteResponse: widget.directionRouteResponse,
    audioInstructionController: audioInstructionController,
  );

  /// [MapScreenController] instance that will be passed down the widget tree
  ///
  late final mapScreenController = MapScreenController(
    directionRouteResponse: widget.directionRouteResponse,
    navigationInstructionController: navigationInstructionController,
    userSpeedNotifier: userSpeedNotifier,
  );

  final userSpeedNotifier = UserSpeedNotifier();

  @override
  Widget build(BuildContext context) {
    return UserSpeedProvider(
      userSpeedNotifier: userSpeedNotifier,
      child: NavigationInstructionProvider(
        navigationInstructionController: navigationInstructionController,
        child: MapControllerProvider(
          mapController: mapScreenController,
          child: AudioInstructionProvider(
            audioInstructionController: audioInstructionController,
            child: MapRouteNavigationScreenPage(widget.directionRouteResponse),
          ),
        ),
      ),
    );
  }
}
