import 'package:flutter/widgets.dart';

import '../controllers/distance_notifier.dart';

class DistanceProvider extends InheritedWidget {
  final DistanceNotifier distanceNotifier;

  const DistanceProvider({
    super.key,
    required this.distanceNotifier,
    required super.child,
  });

  /// Provides the closest [DistanceProvider] up the widget tree.
  ///
  static DistanceNotifier of(BuildContext context) {
    final DistanceProvider? provider =
        context.dependOnInheritedWidgetOfExactType<DistanceProvider>();
    if (provider == null) {
      throw FlutterError(
          'DistanceProvider.of() called with a context that does not contain a DistanceProvider.');
    }
    return provider.distanceNotifier;
  }

  @override
  bool updateShouldNotify(covariant DistanceProvider oldWidget) {
    return oldWidget.distanceNotifier != distanceNotifier;
  }
}
