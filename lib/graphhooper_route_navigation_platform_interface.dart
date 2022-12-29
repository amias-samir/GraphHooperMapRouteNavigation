import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'graphhooper_route_navigation_method_channel.dart';

abstract class GraphhooperRouteNavigationPlatform extends PlatformInterface {
  /// Constructs a GraphhooperRouteNavigationPlatform.
  GraphhooperRouteNavigationPlatform() : super(token: _token);

  static final Object _token = Object();

  static GraphhooperRouteNavigationPlatform _instance = MethodChannelGraphhooperRouteNavigation();

  /// The default instance of [GraphhooperRouteNavigationPlatform] to use.
  ///
  /// Defaults to [MethodChannelGraphhooperRouteNavigation].
  static GraphhooperRouteNavigationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GraphhooperRouteNavigationPlatform] when
  /// they register themselves.
  static set instance(GraphhooperRouteNavigationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

}
