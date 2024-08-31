import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/map_controller.dart';

/// A provider class for [MapScreenController] that extends [InheritedWidget].
/// This class allows the [MapScreenController] instance to be accessed
/// from the widget tree easily.
class MapControllerProvider extends InheritedWidget {
  /// The [MapScreenController] instance that is provided to the widget tree.
  final MapScreenController mapController;

  /// Creates an instance of [MapControllerProvider].
  ///
  /// The [child] parameter is the widget that will have access
  /// to the [mapController]. The [mapController] parameter is
  /// required and cannot be null.
  const MapControllerProvider({
    super.key,
    required this.mapController,
    required super.child,
  });

  /// Provides a static method to access the [MapScreenController] from
  /// the nearest [MapControllerProvider] in the widget tree.
  ///
  /// Use this method in the widget tree to easily obtain the [MapScreenController].
  ///
  /// Example usage:
  /// ```dart
  /// MapController controller = MapControllerProvider.of(context);
  /// ```
  ///
  /// Returns the [MapScreenController] if found, otherwise throws an error.
  static MapScreenController of(BuildContext context) {
    final MapControllerProvider? provider =
        context.dependOnInheritedWidgetOfExactType<MapControllerProvider>();
    if (provider == null) {
      throw FlutterError(
          'MapControllerProvider.of() called with a context that does not contain a MapControllerProvider.');
    }
    return provider.mapController;
  }

  /// Determines whether the widgets that depend on this [InheritedWidget]
  /// should be rebuilt when the [MapControllerProvider] updates.
  ///
  /// Returns true if any significant changes occur, otherwise false.
  /// In this example, the map controller does not change, so this always returns false.
  @override
  bool updateShouldNotify(MapControllerProvider oldWidget) {
    // Return true if the new mapController is different from the old one
    return oldWidget.mapController != mapController;
  }
}
