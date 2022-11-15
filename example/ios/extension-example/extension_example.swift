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
  
  public struct ContentState: Codable, Hashable {
    var data: Dictionary<String, String>
  }
  
  var id = UUID()
}

@available(iOSApplicationExtension 16.1, *)
struct PizzaDeliveryApp: Widget {
  
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      let pizza = PizzaData(JSONData: context.state.data)
      VStack(alignment: .leading) {
        Text("Your \(pizza!.name) is on the way!")
          .font(.title2)
        
        Spacer()
        VStack {
          Text("\(pizza!.description) 🍕")
            .font(.title3)
            .bold()
          Spacer()
        }
        Text("You've already paid: \(pizza!.price) + $9.9 Delivery Fee 💸")
          .font(.caption)
          .foregroundColor(.secondary)
          .padding(.horizontal, 5)
      }.padding(15)
    } dynamicIsland: { context in
      let pizza = PizzaData(JSONData: context.state.data)
      
      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Label("\(pizza!.quantity) item(s)", systemImage: "bag")
            .font(.title2)
        }
        DynamicIslandExpandedRegion(.trailing) {
          Label {
            Text(timerInterval: pizza!.deliverDate, countsDown: true)
              .multilineTextAlignment(.trailing)
              .frame(width: 50)
              .monospacedDigit()
              .font(.caption2)
          } icon: {
            Image(systemName: "timer")
          }
          .font(.title2)
        }
        DynamicIslandExpandedRegion(.center) {
          Text("\(pizza!.deliverName) is on his way!")
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
          Text("\(pizza!.quantity) item(s)")
        } icon: {
          Image(systemName: "bag")
        }
        .font(.caption2)
      } compactTrailing: {
        Text(timerInterval: pizza!.deliverDate, countsDown: true)
          .multilineTextAlignment(.center)
          .frame(width: 40)
          .font(.caption2)
      } minimal: {
        VStack(alignment: .center) {
          Image(systemName: "timer")
          Text(timerInterval: pizza!.deliverDate, countsDown: true)
            .multilineTextAlignment(.center)
            .monospacedDigit()
            .font(.caption2)
        }
      }
      .keylineTint(.accentColor)
    }
  }
}
