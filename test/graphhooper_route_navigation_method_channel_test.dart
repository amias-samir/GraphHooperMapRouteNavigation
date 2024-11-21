import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation_method_channel.dart';

void main() {
  // ignore: unused_local_variable
  MethodChannelGraphhooperRouteNavigation platform = MethodChannelGraphhooperRouteNavigation();
  const MethodChannel channel = MethodChannel('graphhooper_route_navigation');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
    (MethodCall call) async {
      // Your mock implementation
      return 'mock response';
    },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    ); // Clean up mock handlers
  });

}
