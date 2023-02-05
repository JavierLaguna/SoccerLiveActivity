
import ActivityKit
import WidgetKit
import SwiftUI

@main
struct SoccerLiveActivityWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            
            LockScreenView(context: context)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here. Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    
                    DynamicIslandTeamView(
                        team: context.attributes.localTeamName,
                        shield: context.attributes.localTeamShield,
                        goals: context.state.localGoals
                    )
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    
                    DynamicIslandTeamView(
                        team: context.attributes.visitorTeamName,
                        shield: context.attributes.visitorTeamShield,
                        goals: context.state.visitorGoals,
                        goalsAt: .left
                    )
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    
                    DynamicIslandBottomView(
                        time: context.state.time.label,
                        stadium: context.attributes.stadium
                    )
                    
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
            .previewDisplayName("LockScreen / Notification")
    }
}
