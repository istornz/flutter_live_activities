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
    if (call.method == "createActivity") {
      if #available(iOS 16.1, *) {
        guard let args = call.arguments else {
          return
        }
        if let myArgs = args as? [String: Any],
           let data = myArgs["data"] as? Dictionary<String, String> {
          createActivity(params: data)
        } else {
          result(FlutterError(code: "-1", message: "iOS could not extract " +
                              "flutter arguments in method: (sendParams)", details: nil))
        }
      }
    } else if (call.method == "updateActivity") {
      if #available(iOS 16.1, *) {
        //update(activity: <#T##Activity<GroceryDeliveryAppAttributes>#>, )
      }
    } else if (call.method == "endActivity") {
      if #available(iOS 16.1, *) {
        //end(activity: <#T##Activity<GroceryDeliveryAppAttributes>#>, )
      }
    }
    
    result("iOS " + UIDevice.current.systemVersion)
  }
}

@available(iOS 16.1, *)
func createActivity(params: Dictionary<String, String>) {
  let center = UNUserNotificationCenter.current()
  center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
    
    if let error = error {
      // Handle the error here.
      print(error);
    }
    
    // Enable or disable features based on the authorization.
  }
  /*
  
  let attributes = LiveActivitiesAppAttributes()
  let contentState = LiveActivitiesAppAttributes.LiveDeliveryData(data: params)
  do {
    let _ = try Activity<LiveActivitiesAppAttributes>.request(
      attributes: attributes,
      contentState: contentState,
      pushType: .token)
  } catch (let error) {
    print(error.localizedDescription)
  }
   */
  
  let pizzaDeliveryAttributes = LiveActivitiesAppAttributes()
  let initialContentState = LiveActivitiesAppAttributes.LiveDeliveryData(data: params)
                                            
  do {
      let deliveryActivity = try Activity<LiveActivitiesAppAttributes>.request(
          attributes: pizzaDeliveryAttributes,
          contentState: initialContentState,
          pushType: nil)
      print("Requested a pizza delivery Live Activity \(deliveryActivity.id)")
  } catch (let error) {
      print("Error requesting pizza delivery Live Activity \(error.localizedDescription)")
  }
}

@available(iOS 16.1, *)
func update(activity: Activity<LiveActivitiesAppAttributes>) {
  /*Task {
   let updatedStatus = GroceryDeliveryAppAttributes.LiveDeliveryData(courierName: "Adam",
   deliveryTime: .now + 150)
   await activity.update(using: updatedStatus)
   }*/
}

@available(iOS 16.1, *)
func end(activity: Activity<LiveActivitiesAppAttributes>) {
  Task {
    await activity.end(dismissalPolicy: .immediate)
  }
}


struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState
  
  public struct ContentState: Codable, Hashable {
    var data: Dictionary<String, String>
  }
  
  var id = UUID()
}

struct PizzaDeliveryAttributes: ActivityAttributes {
    public typealias PizzaDeliveryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var driverName: String
        var estimatedDeliveryTime: ClosedRange<Date>
    }

    var numberOfPizzas: Int
    var totalAmount: String
}
