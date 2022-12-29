#import "GraphhooperRouteNavigationPlugin.h"
#if __has_include(<graphhooper_route_navigation/graphhooper_route_navigation-Swift.h>)
#import <graphhooper_route_navigation/graphhooper_route_navigation-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "graphhooper_route_navigation-Swift.h"
#endif

@implementation GraphhooperRouteNavigationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGraphhooperRouteNavigationPlugin registerWithRegistrar:registrar];
}
@end
