#import "FlutterSurvicatePlugin.h"
#if __has_include(<flutter_survicate/flutter_survicate-Swift.h>)
#import <flutter_survicate/flutter_survicate-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_survicate-Swift.h"
#endif

@implementation FlutterSurvicatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSurvicatePlugin registerWithRegistrar:registrar];
}
@end
