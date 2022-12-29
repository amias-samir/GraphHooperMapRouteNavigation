import Flutter
import UIKit

public class SwiftGraphhooperRouteNavigationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "graphhooper_route_navigation", binaryMessenger: registrar.messenger())
    let instance = SwiftGraphhooperRouteNavigationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
