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
    if #available(iOS 16.2, *) {
      FootballMatchApp()
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

@available(iOSApplicationExtension 16.2, *)
struct FootballMatchApp: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      let matchName = sharedDefault.string(forKey: context.attributes.prefixedKey("matchName"))!
      
      let teamAName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAName"))!
      let teamAState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAState"))!
      let teamAScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamAScore"))
      let teamALogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamALogo"))!
      
      let teamBName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBName"))!
      let teamBState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBState"))!
      let teamBScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamBScore"))
      let teamBLogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBLogo"))!
      
      let matchStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchStartDate")) / 1000)
      let matchEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchEndDate")) / 1000)
      let matchRemainingTime = matchStartDate...matchEndDate
      
      ZStack {
        LinearGradient(colors: [Color.black.opacity(0.5),Color.black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottom)
        
        HStack {
          ZStack {
            VStack(alignment: .center, spacing: 2.0) {
              
              Spacer()
              
              Text(teamAName)
                .lineLimit(1)
                .font(.subheadline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
              
              Text(teamAState)
                .lineLimit(1)
                .font(.footnote)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            }
            .frame(width: 70, height: 120)
            .padding(.bottom, 8)
            .padding(.top, 8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            ZStack {
              if let uiImageTeamA = UIImage(contentsOfFile: teamALogo)
              {
                Image(uiImage: uiImageTeamA)
                  .resizable()
                  .frame(width: 80, height: 80)
                  .offset(y:-20)
              }
            }
          }
          
          VStack(alignment: .center, spacing: 6.0) {
            HStack {
              Text("\(teamAScore)")
                .font(.title)
                .fontWeight(.bold)
              
              Text(":")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
              
              Text("\(teamBScore)")
                .font(.title)
                .fontWeight(.bold)
            }
            .padding(.horizontal, 5.0)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            HStack(alignment: .center, spacing: 2.0) {
              Text(timerInterval: matchRemainingTime, countsDown: true)
                .multilineTextAlignment(.center)
                .frame(width: 50)
                .monospacedDigit()
                .font(.footnote)
                .foregroundStyle(.white)
            }
            
            VStack(alignment: .center, spacing: 1.0) {
              Link(destination: URL(string: "la://my.app/stats")!) {
                Text("See stats 📊")
              }.padding(.vertical, 5).padding(.horizontal, 5)
              Text(matchName)
                .font(.footnote)
                .foregroundStyle(.white)
            }
          }
          .padding(.vertical, 6.0)
          
          ZStack {
            VStack(alignment: .center, spacing: 2.0) {
              
              Spacer()
              
              Text(teamBName)
                .lineLimit(1)
                .font(.subheadline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
              
              Text(teamBState)
                .lineLimit(1)
                .font(.footnote)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            }
            .frame(width: 70, height: 120)
            .padding(.bottom, 8)
            .padding(.top, 8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            ZStack {
              if let uiImageTeamB = UIImage(contentsOfFile: teamBLogo)
              {
                Image(uiImage: uiImageTeamB)
                  .resizable()
                  .frame(width: 80, height: 80)
                  .offset(y:-20)
              }
            }
          }
        }
        .padding(.horizontal, 2.0)
      }.frame(height: 160)
    } dynamicIsland: { context in
      let matchName = sharedDefault.string(forKey: context.attributes.prefixedKey("matchName"))!
      
      let teamAName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAName"))!
      let teamAState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAState"))!
      let teamAScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamAScore"))
      let teamALogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamALogo"))!
      
      let teamBName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBName"))!
      let teamBState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBState"))!
      let teamBScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamBScore"))
      let teamBLogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBLogo"))!
      
      let matchStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchStartDate")) / 1000)
      let matchEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchEndDate")) / 1000)
      let matchRemainingTime = matchStartDate...matchEndDate
      
      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack(alignment: .center, spacing: 2.0) {
            
            if let uiImageTeamA = UIImage(contentsOfFile: teamALogo)
            {
              Image(uiImage: uiImageTeamA)
                .resizable()
                .frame(width: 80, height: 80)
                .offset(y:0)
            }
            
            Spacer()
            
            Text(teamAName)
              .lineLimit(1)
              .font(.subheadline)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
            
            Text(teamAState)
              .lineLimit(1)
              .font(.footnote)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
          }
          .frame(width: 70, height: 120)
          .padding(.bottom, 8)
          .padding(.top, 8)
          
          
        }
        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .center, spacing: 2.0) {
            
            if let uiImageTeamB = UIImage(contentsOfFile: teamBLogo)
            {
              Image(uiImage: uiImageTeamB)
                .resizable()
                .frame(width: 80, height: 80)
                .offset(y:0)
            }
            
            Spacer()
            
            Text(teamBName)
              .lineLimit(1)
              .font(.subheadline)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
            
            Text(teamBState)
              .lineLimit(1)
              .font(.footnote)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
          }
          .frame(width: 70, height: 120)
          .padding(.bottom, 8)
          .padding(.top, 8)
          
          
        }
        DynamicIslandExpandedRegion(.center) {
          VStack(alignment: .center, spacing: 6.0) {
            HStack {
              Text("\(teamAScore)")
                .font(.title)
                .fontWeight(.bold)
              
              Text(":")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
              
              Text("\(teamBScore)")
                .font(.title)
                .fontWeight(.bold)
            }
            .padding(.horizontal, 5.0)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            HStack(alignment: .center, spacing: 2.0) {
              Text(timerInterval: matchRemainingTime, countsDown: true)
                .multilineTextAlignment(.center)
                .frame(width: 50)
                .monospacedDigit()
                .font(.footnote)
                .foregroundStyle(.white)
            }
            
            VStack(alignment: .center, spacing: 1.0) {
              Link(destination: URL(string: "la://my.app/stats")!) {
                Text("See stats 📊")
              }.padding(.vertical, 5).padding(.horizontal, 5)
              Text(matchName)
                .font(.footnote)
                .foregroundStyle(.white)
            }
            
          }
          .padding(.vertical, 6.0)
        }
      } compactLeading: {
        HStack {
          if let uiImageTeamA = UIImage(contentsOfFile: teamALogo)
          {
            Image(uiImage: uiImageTeamA)
              .resizable()
              .frame(width: 26, height: 26)
          }
          
          Text("\(teamAScore)")
            .font(.title)
            .fontWeight(.bold)
        }
      } compactTrailing: {
        HStack {
          Text("\(teamBScore)")
            .font(.title)
            .fontWeight(.bold)
          if let uiImageTeamB = UIImage(contentsOfFile: teamBLogo)
          {
            Image(uiImage: uiImageTeamB)
              .resizable()
              .frame(width: 26, height: 26)
          }
        }
      } minimal: {
        ZStack {
          if let uiImageTeamA = UIImage(contentsOfFile: teamALogo)
          {
            Image(uiImage: uiImageTeamA)
              .resizable()
              .frame(width: 26, height: 26)
              .offset(x:-6)
          }
          
          if let uiImageTeamB = UIImage(contentsOfFile: teamBLogo)
          {
            Image(uiImage: uiImageTeamB)
              .resizable()
              .frame(width: 26, height: 26)
              .offset(x:6)
          }
        }
      }
    }
  }
}

extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}
