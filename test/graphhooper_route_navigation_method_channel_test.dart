import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation_method_channel.dart';

void main() {
  MethodChannelGraphhooperRouteNavigation platform = MethodChannelGraphhooperRouteNavigation();
  const MethodChannel channel = MethodChannel('graphhooper_route_navigation');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
