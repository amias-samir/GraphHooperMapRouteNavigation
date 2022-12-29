import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'graphhooper_route_navigation_platform_interface.dart';

/// An implementation of [GraphhooperRouteNavigationPlatform] that uses method channels.
class MethodChannelGraphhooperRouteNavigation extends GraphhooperRouteNavigationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('graphhooper_route_navigation');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
