import ActivityKit
import Flutter
import UIKit

@available(iOS 16.1, *)
class FlutterAlertConfig {
  let _title:String
  let _body:String
  let _sound:String?
//  let _sound:AlertConfiguration.AlertSound

  init(title:String, body:String, sound:String?) {
    _title = title;
    _body = body;
      _sound = sound;
//    _sound = sound == nil ? .default : AlertConfiguration.AlertSound(rawValue: sound!);
  }

  func getAlertConfig() -> AlertConfiguration {
      return AlertConfiguration(title: LocalizedStringResource(stringLiteral: _title), body: LocalizedStringResource(stringLiteral: _body), sound: (_sound == nil) ? .default : AlertConfiguration.AlertSound.named(_sound!));
  }
}

public class SwiftLiveActivitiesPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var urlSchemeSink: FlutterEventSink?
  private var appGroupId: String?
  private var urlScheme: String?
  private var sharedDefault: UserDefaults?
  private var appLifecycleLifeActiviyIds = [String]()
  private var activityEventSink: FlutterEventSink?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "live_activities", binaryMessenger: registrar.messenger())
    let urlSchemeChannel = FlutterEventChannel(name: "live_activities/url_scheme", binaryMessenger: registrar.messenger())
    let activityStatusChannel = FlutterEventChannel(name: "live_activities/activity_status", binaryMessenger: registrar.messenger())
    
    let instance = SwiftLiveActivitiesPlugin()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
    urlSchemeChannel.setStreamHandler(instance)
    activityStatusChannel.setStreamHandler(instance)
    registrar.addApplicationDelegate(instance)
  }
  
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    urlSchemeSink = nil
    activityEventSink = nil
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
    if (call.method == "areActivitiesEnabled") {
      if #available(iOS 16.1, *) {
        result(ActivityAuthorizationInfo().areActivitiesEnabled)
      } else {
        result(false)
      }
      return
    }
    
    if #available(iOS 16.1, *) {
      switch call.method {
        case "init":
          guard let args = call.arguments as? [String: Any] else {
            return
          }

          self.urlScheme = args["urlScheme"] as? String;
          
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
            let staleIn = args["staleIn"] as? Int? ?? nil
            createActivity(data: data, removeWhenAppIsKilled: removeWhenAppIsKilled, staleIn: staleIn, result: result)
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
              let alertConfigMap = args["alertConfig"] as? [String:String?];
              let alertTitle = alertConfigMap?["title"] as? String;
              let alertBody = alertConfigMap?["body"] as? String;
              let alertSound = alertConfigMap?["sound"] as? String;
              
              let alertConfig = (alertTitle == nil || alertBody == nil) ? nil : FlutterAlertConfig(title: alertTitle!, body: alertBody!, sound: alertSound);
        
//              let alertTitle = args?[
            updateActivity(activityId: activityId, data: data, alertConfig: alertConfig, result: result)
          } else {
            result(FlutterError(code: "WRONG_ARGS", message: "argument are not valid, check if 'activityId', 'data' are valid", details: nil))
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
        default:
          break
      }
    } else {
      result(FlutterError(code: "WRONG_IOS_VERSION", message: "this version of iOS is not supported", details: nil))
    }
  }
  
  @available(iOS 16.1, *)
  func createActivity(data: [String: Any], removeWhenAppIsKilled: Bool, staleIn: Int?, result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
      // TODO: do we have to request this permission???
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

      if let error = error {
        result(FlutterError(code: "AUTHORIZATION_ERROR", message: "authorization error", details: error.localizedDescription))
      }
    }

    for item in data {
      sharedDefault!.set(item.value, forKey: item.key)
    }
    
    let liveDeliveryAttributes = LiveActivitiesAppAttributes()
    let initialContentState = LiveActivitiesAppAttributes.LiveDeliveryData(appGroupId: appGroupId!)
    var deliveryActivity: Activity<LiveActivitiesAppAttributes>?
    if #available(iOS 16.2, *){
      let activityContent = ActivityContent(
        state: initialContentState,
        staleDate: staleIn != nil ? Calendar.current.date(byAdding: .minute, value: staleIn!, to: Date.now) : nil)
      do {
        deliveryActivity = try Activity.request(
          attributes: liveDeliveryAttributes,
          content: activityContent,
          pushType: .token)
      } catch (let error) {
        result(FlutterError(code: "LIVE_ACTIVITY_ERROR", message: "can't launch live activity", details: error.localizedDescription))
      }
    } else {
      do {
        deliveryActivity = try Activity<LiveActivitiesAppAttributes>.request(
          attributes: liveDeliveryAttributes,
          contentState: initialContentState,
          pushType: .token)
        
      } catch (let error) {
        result(FlutterError(code: "LIVE_ACTIVITY_ERROR", message: "can't launch live activity", details: error.localizedDescription))
      }
    }
    if (deliveryActivity != nil) {
      if removeWhenAppIsKilled {
        appLifecycleLifeActiviyIds.append(deliveryActivity!.id)
      }
//       monitorLiveActivity(deliveryActivity!)
      result(deliveryActivity!.id)
    }
  }
  
  @available(iOS 16.1, *)
  func updateActivity(activityId: String, data: [String: Any?], alertConfig: FlutterAlertConfig?, result: @escaping FlutterResult) {
    Task {
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        if activityId == activity.id {
          for item in data {
            if (item.value != nil && !(item.value is NSNull)) {
              sharedDefault!.set(item.value, forKey: item.key)
            } else {
              sharedDefault!.removeObject(forKey: item.key)
            }
          }
          
          let updatedStatus = LiveActivitiesAppAttributes.LiveDeliveryData(appGroupId: self.appGroupId!)
          await activity.update(using: updatedStatus, alertConfiguration: alertConfig?.getAlertConfig())
          break;
        }
      }
      result(nil)
    }
  }


  @available(iOS 16.1, *)
  func getActivityState(activityId: String, result: @escaping FlutterResult) {
    Task {
      if let matchingActivity = Activity<LiveActivitiesAppAttributes>.activities.first(where: { $0.id == activityId }) {
        switch (matchingActivity.activityState) {
        case .active:
          result("active")
        case .ended:
          result("ended")
        case .dismissed:
          result("dismissed")
        case .stale:
          result("stale")
        @unknown default:
          result("unknown")
        }
      } else {
        // No matching activity was found
        result(nil)
      }
    }
  }
  
  @available(iOS 16.1, *)
  func getPushToken(activityId: String, result: @escaping FlutterResult) {
    Task {
      var pushToken: String?;
      for activity in Activity<LiveActivitiesAppAttributes>.activities {
        if (activityId == activity.id) {
          if let data = activity.pushToken {
            pushToken = data.map { String(format: "%02x", $0) }.joined()
          }
        }
      }
      result(pushToken)
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
    
    if components?.scheme == nil || components?.scheme != urlScheme { return false }
    
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
    
    var id = UUID()
  }
  
//   @available(iOS 16.1, *)
//   private func monitorLiveActivity<T : ActivityAttributes>(_ activity: Activity<T>) {
//       do {
//           try
//           Task {
//             for await state in activity.activityStateUpdates {
//               var response: Dictionary<String, Any> = Dictionary()
//               response["activityId"] = activity.id
//               switch state {
//               case .active:
//                 monitorTokenChanges(activity)
//               case .dismissed, .ended:
//                 response["status"] = "ended"
//                 activityEventSink?.self(response)
//               case .stale:
//                 response["status"] = "stale"
//                 activityEventSink?.self(response)
//               @unknown default:
//                 response["status"] = "unknown"
//                 activityEventSink?.self(response)
//               }
//             }
//           }
//       } catch {
//           print("error: ");
//           print(error);
//       }
//   }
  
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
