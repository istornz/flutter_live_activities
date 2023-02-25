import ActivityKit
import Flutter
import UIKit

public class SwiftLiveActivitiesPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var urlSchemeSink: FlutterEventSink?
  private var appGroupId: String?
  private var sharedDefault: UserDefaults?
  private var appLifecycleLifeActiviyIds = [String]()
  private var activityEventSink: FlutterEventSink?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "live_activities", binaryMessenger: registrar.messenger())
    let urlSchemeChannel = FlutterEventChannel(name: "live_activities/url_scheme", binaryMessenger: registrar.messenger())
    let tokenEventChannel = FlutterEventChannel(name: "live_activities/token_channel", binaryMessenger: registrar.messenger())
    
    let instance = SwiftLiveActivitiesPlugin()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
    urlSchemeChannel.setStreamHandler(instance)
    tokenEventChannel.setStreamHandler(instance)
    registrar.addApplicationDelegate(instance)
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    if let args = arguments as? String{
      if (args == "urlSchemeStream") {
        urlSchemeSink = events
      } else if (args == "activityUpdateStream") {
        activityEventSink = events
      }
    }
    
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    if let args = arguments as? String{
      if (args == "urlSchemeStream") {
        urlSchemeSink = nil
      } else if (args == "activityUpdateStream") {
        activityEventSink = nil
      }
    }
    return nil
  }
  
  private func initializationGuard(result: @escaping FlutterResult) {
    if self.appGroupId == nil || self.sharedDefault == nil {
      result(FlutterError(code: "NEED_INIT", message: "you need to run 'init()' first with app group id to create live activity", details: nil))
    }
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if #available(iOS 16.1, *) {
      
      switch call.method {
        case "init":
          guard let args = call.arguments as? [String: Any] else {
            return
          }
          
          if let appGroupId = args["appGroupId"] as? String {
            self.appGroupId = appGroupId
            sharedDefault = UserDefaults(suiteName: self.appGroupId)!
            result(nil)
          } else {
            result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'appGroupId' is valid", details: nil))
          }
          
          break
        case "createActivity":
          initializationGuard(result: result)
          guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "WRONG_ARGS", message: "Unknown data type in argument", details: nil))
            return
          }
          
          if let data = args["data"] as? [String: Any] {
            let removeWhenAppIsKilled = args["removeWhenAppIsKilled"] as? Bool ?? false
            createActivity(data: data, removeWhenAppIsKilled: removeWhenAppIsKilled, result: result)
          } else {
            result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'data' is valid", details: nil))
          }
          break
        case "updateActivity":
          initializationGuard(result: result)
          guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "WRONG_ARGS", message: "Unknown data type in argument", details: nil))
            return
          }
          if let activityId = args["activityId"] as? String, let data = args["data"] as? [String: Any] {
            updateActivity(activityId: activityId, data: data, result: result)
          } else {
            result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'activityId' & 'data' are valid", details: nil))
          }
          break
        case "endActivity":
          guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "WRONG_ARGS", message: "Unknown data type in argument", details: nil))
            return
          }
          if let activityId = args["activityId"] as? String {
            endActivity(activityId: activityId, result: result)
          } else {
            result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'activityId' is valid", details: nil))
          }
          break
        case "getActivityState":
          guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "WRONG_ARGS", message: "Unknown data type in argument", details: nil))
            return
          }
          if let activityId = args["activityId"] as? String {
            getActivityState(activityId: activityId, result: result)
          } else {
            result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'activityId' is valid", details: nil))
          }
          break
        case "getPushToken":
          guard let args = call.arguments  as? [String: Any] else {
            return
          }
          if let activityId = args["activityId"] as? String {
            getPushToken(activityId: activityId, result: result)
          } else {
            result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'activityId' is valid", details: nil))
          }
          break
        case "getAllActivitiesIds":
          getAllActivitiesIds(result: result)
          break
        case "endAllActivities":
          endAllActivities(result: result)
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
  func createActivity(data: [String: Any], removeWhenAppIsKilled: Bool, result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      
      if let error = error {
        result(FlutterError(code: "AUTHORIZATION_ERROR", message: "authorization error", details: error.localizedDescription))
      }
    }
    
    let sharedId = data["sharedId"] as? String ?? UUID().uuidString
    
    for item in data {
      sharedDefault!.set(item.value, forKey: sharedId + item.key)
    }
    
    let liveDeliveryAttributes = LiveActivitiesAppAttributes(sharedId: sharedId)
    let initialContentState = LiveActivitiesAppAttributes.LiveDeliveryData(appGroupId: appGroupId!)
    
    do {
      let deliveryActivity = try Activity<LiveActivitiesAppAttributes>.request(
        attributes: liveDeliveryAttributes,
        contentState: initialContentState,
        pushType: .token)
      if removeWhenAppIsKilled {
        appLifecycleLifeActiviyIds.append(deliveryActivity.id)
      }
      monitorLiveActivity(deliveryActivity)
      result(deliveryActivity.id)
    } catch (let error) {
      result(FlutterError(code: "LIVE_ACTIVITY_ERROR", message: "can't launch live activity", details: error.localizedDescription))
    }
  }
  
  @available(iOS 16.1, *)
  func updateActivity(activityId: String, data: [String: Any], result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        if activityId == activity.id {
          for item in data {
            sharedDefault!.set(item.value, forKey: item.key)
          }
          
          let updatedStatus = LiveActivitiesAppAttributes.LiveDeliveryData(appGroupId: self.appGroupId!)
          await activity.update(using: updatedStatus)
          break;
        }
      }
      result(nil)
    }
  }
  
  @available(iOS 16.1, *)
  func getActivityState(activityId: String, result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        if (activityId == activity.id) {
          switch (activity.activityState) {
            case .active:
              result("active")
            case .ended:
              result("ended")
            case .dismissed:
              result("dismissed")
            @unknown default:
              result("unknown")
          }
        }
      }
    }
  }
  
  @available(iOS 16.1, *)
  func getPushToken(activityId: String, result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        if (activityId == activity.id) {
          for await data in activity.pushTokenUpdates {
            let pushToken = data.map {String(format: "%02x", $0)}.joined()
            result(pushToken)
          }
        }
      }
    }
  }
  
  @available(iOS 16.1, *)
  func endActivity(activityId: String, result: @escaping FlutterResult) {
    appLifecycleLifeActiviyIds.removeAll { $0 == activityId }
    Task {
      await endActivitiesWithId(activityIds: [activityId])
      result(nil)
    }
  }
  
  @available(iOS 16.1, *)
  func endAllActivities(result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        await activity.end(dismissalPolicy: .immediate)
      }
      appLifecycleLifeActiviyIds.removeAll()
      result(nil)
    }
  }
  
  @available(iOS 16.1, *)
  func getAllActivitiesIds(result: @escaping FlutterResult) {
    var activitiesId: [String] = []
    for activity in Activity<LiveActivitiesAppAttributes>.activities {
      activitiesId.append(activity.id)
    }
    
    result(activitiesId)
  }
  
  @available(iOS 16.1, *)
  private func endActivitiesWithId(activityIds: [String]) async {
    for activity in Activity<LiveActivitiesAppAttributes>.activities {
      if (activityIds.contains { $0 == activity.id }) {
        await activity.end(dismissalPolicy: .immediate)
      }
    }
  }
  
  public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    
    if components?.scheme == nil { return false }
    
    var queryResult: Dictionary<String, Any> = Dictionary()
    
    queryResult["queryItems"] = components?.queryItems?.map({ (item) -> Dictionary<String, String> in
      var queryItemResult: Dictionary<String, String> = Dictionary()
      queryItemResult["name"] = item.name
      queryItemResult["value"] = item.value
      return queryItemResult
    })
    queryResult["scheme"] = components?.scheme
    queryResult["host"] = components?.host
    queryResult["path"] = components?.path
    queryResult["url"] = components?.url?.absoluteString
    
    urlSchemeSink?.self(queryResult)
    return true
  }
  
  public func applicationWillTerminate(_ application: UIApplication) {
    if #available(iOS 16.1, *) {
      Task {
        await self.endActivitiesWithId(activityIds: self.appLifecycleLifeActiviyIds)
      }
    }
  }
  
  struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState
    
    public struct ContentState: Codable, Hashable {
      var appGroupId: String
    }
    
    var sharedId: String
    var id = UUID()
  }
  
  @available(iOS 16.1, *)
  private func monitorLiveActivity<T : ActivityAttributes>(_ activity: Activity<T>) {
    Task {
      for await state in activity.activityStateUpdates {
        var response: Dictionary<String, Any> = Dictionary()
        response["activityId"] = activity.id
        switch state {
          case .active:
            monitorTokenChanges(activity)
          case .dismissed, .ended:
            response["status"] = "ended"
            activityEventSink?.self(response)
          @unknown default:
            response["status"] = "unknown"
            activityEventSink?.self(response)
        }
      }
    }
  }
  
  @available(iOS 16.1, *)
  private func monitorTokenChanges<T: ActivityAttributes>(_ activity: Activity<T>) {
    Task {
      for await data in activity.pushTokenUpdates {
        var response: Dictionary<String, Any> = Dictionary()
        let pushToken = data.map {String(format: "%02x", $0)}.joined()
        response["token"] = pushToken
        response["activityId"] = activity.id
        response["status"] = "active"
        activityEventSink?.self(response)
      }
    }
  }
}
