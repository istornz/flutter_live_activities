import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'live_activities_method_channel.dart';

abstract class LiveActivitiesPlatform extends PlatformInterface {
  /// Constructs a LiveActivitiesPlatform.
  LiveActivitiesPlatform() : super(token: _token);

  static final Object _token = Object();

  static LiveActivitiesPlatform _instance = MethodChannelLiveActivities();

  /// The default instance of [LiveActivitiesPlatform] to use.
  ///
  /// Defaults to [MethodChannelLiveActivities].
  static LiveActivitiesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LiveActivitiesPlatform] when
  /// they register themselves.
  static set instance(LiveActivitiesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future createActivity(Map<String, String> data) {
    throw UnimplementedError('createActivity() has not been implemented.');
  }

  Future updateActivity() {
    throw UnimplementedError('updateActivity() has not been implemented.');
  }

  Future endActivity() {
    throw UnimplementedError('endActivity() has not been implemented.');
  }
}
