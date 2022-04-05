#import "CrLoggerPlugin.h"
#if __has_include(<cr_logger/cr_logger-Swift.h>)
#import <cr_logger/cr_logger-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cr_logger-Swift.h"
#endif

@implementation CrLoggerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCrLoggerPlugin registerWithRegistrar:registrar];
}
@end
