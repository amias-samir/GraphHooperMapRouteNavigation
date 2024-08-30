import 'package:flutter/widgets.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/navigation_instruction_controller.dart';

/// Provider Container or Widget for [NavigationInstructionController]
/// Uses [InheritedWidget].
class NavigationInstructionProvider extends InheritedWidget {
  final NavigationInstructionController navigationInstructionController;

  // Constructor that takes the controller and child widget
  const NavigationInstructionProvider({
    super.key,
    required this.navigationInstructionController,
    required super.child,
  });

  // Method to access the provider in the widget tree
  static NavigationInstructionController? of(BuildContext context) {
    // Using context to find the nearest instance of the provider
    return context
        .dependOnInheritedWidgetOfExactType<NavigationInstructionProvider>()
        ?.navigationInstructionController;
  }

  @override
  bool updateShouldNotify(covariant NavigationInstructionProvider oldWidget) {
    // Return true if the controller reference has changed
    return oldWidget.navigationInstructionController !=
        navigationInstructionController;
  }
}
