
import ActivityKit

struct MatchLiveActivityAttributes: ActivityAttributes {
    typealias ContentState = MatchLiveActivity
    
    struct MatchLiveActivity: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        let time: MatchTime
        let localGoals: Int
        let visitorGoals: Int
    }
    
    // Fixed non-changing properties about your activity go here!
    let stadium: String
    let localTeamName: String
    let visitorTeamName: String
    let localTeamShield: String
    let visitorTeamShield: String
}
