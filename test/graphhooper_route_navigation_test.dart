import 'package:flutter_test/flutter_test.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation_platform_interface.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGraphhooperRouteNavigationPlatform
    with MockPlatformInterfaceMixin
    implements GraphhooperRouteNavigationPlatform {

  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GraphhooperRouteNavigationPlatform initialPlatform = GraphhooperRouteNavigationPlatform.instance;

  test('$MethodChannelGraphhooperRouteNavigation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGraphhooperRouteNavigation>());
  });

  test('getPlatformVersion', () async {
    // GraphhooperRouteNavigation graphhooperRouteNavigationPlugin = GraphhooperRouteNavigation();
    MockGraphhooperRouteNavigationPlatform fakePlatform = MockGraphhooperRouteNavigationPlatform();
    GraphhooperRouteNavigationPlatform.instance = fakePlatform;

    // expect(await graphhooperRouteNavigationPlugin.getPlatformVersion(), '42');
  });
}
