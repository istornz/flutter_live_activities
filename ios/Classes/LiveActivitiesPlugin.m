#import "LiveActivitiesPlugin.h"
#if __has_include(<live_activities/live_activities-Swift.h>)
#import <live_activities/live_activities-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "live_activities-Swift.h"
#endif

@implementation LiveActivitiesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLiveActivitiesPlugin registerWithRegistrar:registrar];
}
@end
