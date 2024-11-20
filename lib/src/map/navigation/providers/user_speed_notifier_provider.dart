import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/src/map/navigation/controllers/speed_notifier.dart';

/// An [InheritedWidget] that provides [UserSpeedNotifier] to its descendants.
///
/// This allows widgets in the subtree to access the [UserSpeedNotifier] instance
/// without needing to pass it down manually.
class UserSpeedProvider extends InheritedWidget {
  /// The [UserSpeedNotifier] instance that this widget provides.
  final UserSpeedNotifier userSpeedNotifier;

  /// Creates a [UserSpeedProvider].
  ///
  /// The [userSpeedNotifier] and [child] parameters are required.
  const UserSpeedProvider({
    super.key,
    required this.userSpeedNotifier,
    required super.child,
  });

  /// Retrieves the nearest [UserSpeedProvider] up the widget tree and returns
  /// its [userSpeedNotifier].
  ///
  /// Throws a [FlutterError] if no [UserSpeedProvider] is found in the widget tree.
  static UserSpeedNotifier of(BuildContext context) {
    final UserSpeedProvider? provider =
        context.dependOnInheritedWidgetOfExactType<UserSpeedProvider>();
    if (provider == null) {
      throw FlutterError(
          'UserSpeedProvider.of() called with a context that does not contain a UserSpeedProvider.');
    }
    return provider.userSpeedNotifier;
  }

  /// Determines whether the widget tree should be rebuilt when the [userSpeedNotifier] changes.
  ///
  /// Returns `true` if the new [userSpeedNotifier] is different from the old one, otherwise `false`.
  @override
  bool updateShouldNotify(covariant UserSpeedProvider oldWidget) {
    return oldWidget.userSpeedNotifier != userSpeedNotifier;
  }
}
