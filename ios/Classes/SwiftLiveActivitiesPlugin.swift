import Flutter
import UIKit
import ActivityKit

public class SwiftLiveActivitiesPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "live_activities", binaryMessenger: registrar.messenger())
    let instance = SwiftLiveActivitiesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if #available(iOS 16.1, *) {
      switch (call.method) {
      case "createActivity":
        guard let args = call.arguments  as? [String: Any] else {
          return
        }
        if let data = args["data"] as? Dictionary<String, String> {
          createActivity(data: data, result: result)
        } else {
          result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'data' is valid", details: nil))
        }
        break
      case "updateActivity":
        guard let args = call.arguments  as? [String: Any] else {
          return
        }
        if let activityId = args["activityId"] as? String, let data = args["data"] as? Dictionary<String, String> {
          updateActivity(activityId: activityId, data: data, result: result)
        } else {
          result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'activityId' & 'data' are valid", details: nil))
        }
        break
      case "endActivity":
        guard let args = call.arguments  as? [String: Any] else {
          return
        }
        if let activityId = args["activityId"] as? String {
          endActivity(activityId: activityId, result: result)
        } else {
          result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'activityId' is valid", details: nil))
        }
        break
      case "getAllActivitiesIds":
        getAllActivitiesIds(result: result);
        break
      case "endAllActivities":
        endAllActivities(result: result);
        break
      case "areActivitiesEnabled":
        result(ActivityAuthorizationInfo().areActivitiesEnabled)
        break
      default:
        break
      }
    } else {
      result(FlutterError(code: "WRONG_IOS_VERSION", message: "this version of iOS is not supported", details: nil))
    }
  }
  
  @available(iOS 16.1, *)
  func createActivity(data: Dictionary<String, String>, result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      
      if let error = error {
        result(FlutterError(code: "AUTHORIZATION_ERROR", message: "authorization error", details: error.localizedDescription))
      }
    }
    
    let liveDeliveryAttributes = LiveActivitiesAppAttributes()
    let initialContentState = LiveActivitiesAppAttributes.LiveDeliveryData(data: data)
    
    do {
      let deliveryActivity = try Activity<LiveActivitiesAppAttributes>.request(
        attributes: liveDeliveryAttributes,
        contentState: initialContentState,
        pushType: nil)
      result(deliveryActivity.id)
    } catch (let error) {
      result(FlutterError(code: "LIVE_ACTIVITY_ERROR", message: "can't launch live activity", details: error.localizedDescription))
    }
  }
  
  @available(iOS 16.1, *)
  func updateActivity(activityId: String, data: Dictionary<String, String>, result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        if (activityId == activity.id) {
          let updatedStatus = LiveActivitiesAppAttributes.LiveDeliveryData(data: data)
          await activity.update(using: updatedStatus)
          break;
        }
      }
      result(nil)
    }
  }
  
  @available(iOS 16.1, *)
  func endActivity(activityId: String, result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        if (activityId == activity.id) {
          await activity.end(dismissalPolicy: .immediate)
          break;
        }
      }
      result(nil)
    }
  }
  
  @available(iOS 16.1, *)
  func endAllActivities(result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        await activity.end(dismissalPolicy: .immediate)
      }
    }
    result(nil)
  }
  
  @available(iOS 16.1, *)
  func getAllActivitiesIds(result: @escaping FlutterResult) {
    Task {
      var activitiesId: [String] = []
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        activitiesId.append(activity.id)
      }
      
      result(activitiesId)
    }
  }
  
  struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState
    
    public struct ContentState: Codable, Hashable {
      // TODO: Need to send an Any object
      var data: Dictionary<String, String>
    }
    
    var id = UUID()
  }
}
