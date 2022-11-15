//
//  extension_example.swift
//  extension-example
//
//  Created by Dimitri Dessus on 28/09/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {
      PizzaDeliveryApp()
    }
  }
}

// We need to redefined live activities pipe
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState
  
  public struct ContentState: Codable, Hashable { }
  
  var id = UUID()
}

// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "group.dimitridessus.liveactivities")!

@available(iOSApplicationExtension 16.1, *)
struct PizzaDeliveryApp: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      let pizzaName = sharedDefault.string(forKey: "name")!
      let pizzaDescription = sharedDefault.string(forKey: "description")!
      let pizzaPrice = sharedDefault.float(forKey: "price")
      
      VStack(alignment: .leading) {
        Text("Your \(pizzaName) is on the way!")
          .font(.title2)
        Spacer()
        VStack {
          Text("\(pizzaDescription) 🍕")
            .font(.title3)
            .bold()
          Spacer()
        }
        Text("You've already paid: \(pizzaPrice) + $9.9 Delivery Fee 💸")
          .font(.caption)
          .foregroundColor(.secondary)
          .padding(.horizontal, 5)
        
        // Open the Flutter app with custom data
        Link(destination: URL(string: "la://my.app/order?=123")!) {
          Text("See order 📝")
        }.padding(.vertical, 5).padding(.horizontal, 5)
      }.padding(15)
    } dynamicIsland: { context in
      let deliverName = sharedDefault.string(forKey: "deliverName")!
      let quantity = sharedDefault.integer(forKey: "quantity")
      let deliverStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: "deliverStartDate") / 1000)
      let deliverEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: "deliverEndDate") / 1000)
      let deliverDate = deliverStartDate...deliverEndDate
      
      return DynamicIsland {
        DynamicIslandExpandedRegion(.center) {
          Text("\(deliverName) is on his way!")
            .lineLimit(1)
            .font(.caption)
        }
        DynamicIslandExpandedRegion(.bottom) {
          Button {
          } label: {
            Label("Contact driver", systemImage: "phone")
          }
        }
      } compactLeading: {
        Label {
          Text("\(quantity) item(s)")
        } icon: {
          Image(systemName: "bag")
        }
        .font(.caption2)
      } compactTrailing: {
        Text(timerInterval: deliverDate, countsDown: true)
          .multilineTextAlignment(.center)
          .frame(width: 40)
          .font(.caption2)
      } minimal: {
        VStack(alignment: .center) {
          Image(systemName: "timer")
          Text(timerInterval: deliverDate, countsDown: true)
            .multilineTextAlignment(.center)
            .monospacedDigit()
            .font(.caption2)
        }
      }
      .keylineTint(.accentColor)
    }
  }
}
