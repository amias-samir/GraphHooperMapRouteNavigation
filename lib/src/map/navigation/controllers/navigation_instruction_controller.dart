import 'package:flutter/widgets.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/model/instructions.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/screens/wrapper_screen.dart';

///
/// [NavigationInstructionController] global instance which is used in [WrapperScreen] to pass down values to widget
/// This is used in the wrapper screen .
/// Only use this instance to call the methods of the controller not to get state values
///
final navigationInstructionProvider = NavigationInstructionController();

/// [NavigationInstructionController] holds all the logic for showing the navigation instruction
/// on the screen.
///
class NavigationInstructionController extends ChangeNotifier {
  /// Private [Instruction] instance variable
  ///
  Instruction _instruction = Instruction();

  /// Getter for [_instruction]
  ///
  Instruction get instruction => _instruction;

  /// Updates [_instruction]
  ///
  void updateInstructions(Instruction instruction) {
    _instruction = instruction;
    notifyListeners();
  }
}

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
