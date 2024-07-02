#import "CommonModuleFlutterPlugin.h"
#if __has_include(<osam_common_module_flutter/osam_common_module_flutter-Swift.h>)
#import <osam_common_module_flutter/osam_common_module_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "osam_common_module_flutter-Swift.h"
#endif

@implementation CommonModuleFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCommonModuleFlutterPlugin registerWithRegistrar:registrar];
}
@end
