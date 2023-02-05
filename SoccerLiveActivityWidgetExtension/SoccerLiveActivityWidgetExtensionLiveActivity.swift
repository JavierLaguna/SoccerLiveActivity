
import ActivityKit
import WidgetKit
import SwiftUI

// TODO: JLI MAKE COMPONENTS

@main
struct SoccerLiveActivityWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            
            VStack {
                VStack {
                    Text(context.attributes.stadium)
                        .font(.subheadline)
                        .underline()
                    
                    Spacer()
                    
                    Text(context.state.time.label)
                        .font(.title)
                }
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Image(context.attributes.localTeamShield)
                            .resizable()
                            .frame(width: 46, height: 46)
                        
                        Text(context.attributes.localTeamName)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Text("\(context.state.localGoals)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("-")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(context.state.visitorGoals)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    VStack {
                        Image(context.attributes.visitorTeamShield)
                            .resizable()
                            .frame(width: 46, height: 46)
                        
                        Text(context.attributes.visitorTeamName)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here. Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        VStack {
                            Image(context.attributes.localTeamShield)
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text(context.attributes.localTeamName)
                                .fontWeight(.semibold)
                        }
                        
                        Text("\(context.state.localGoals)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("\(context.state.visitorGoals)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        VStack {
                            Image(context.attributes.visitorTeamShield)
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text(context.attributes.visitorTeamName)
                                .fontWeight(.semibold)
                        }
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Text(context.state.time.label)
                            .font(.title)
                        
                        Spacer()
                        
                        Text(context.attributes.stadium)
                            .font(.subheadline)
                            .underline()
                    }
                }
            } compactLeading: {
                Text(context.state.time.labelShort)
            } compactTrailing: {
                Text("\(context.state.localGoals) - \(context.state.visitorGoals)")
            } minimal: {
                Text("\(context.state.localGoals)-\(context.state.visitorGoals)")
            }
        }
    }
}

struct SoccerLiveActivityWidgetExtensionLiveActivity_Previews: PreviewProvider {
    static let attributes = MatchLiveActivityAttributes(
        stadium: "Civitas Metropolitano",
        localTeamName: "ATM",
        visitorTeamName: "RMA",
        localTeamShield: "shield_atm",
        visitorTeamShield: "shield_rma"
    )
    
    static let contentState = MatchLiveActivityAttributes.ContentState(
        time: .firstPart(min: 44),
        localGoals: 19,
        visitorGoals: 0
    )
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
