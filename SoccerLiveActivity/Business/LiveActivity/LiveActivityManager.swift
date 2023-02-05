
import Foundation
import ActivityKit

final class LiveActivityManager {
    
    private var match: Match
    private var activity: Activity<MatchLiveActivityAttributes>?
    
    init(match: Match) {
        self.match = match
    }
    
    func startLiveActivity() {
        do {
            activity = try .request(
                attributes: MatchLiveActivityAttributes(
                    stadium: match.stadium,
                    localTeamName: match.localTeam.shortName,
                    visitorTeamName: match.visitorTeam.shortName,
                    localTeamShield: match.localTeam.shield,
                    visitorTeamShield: match.visitorTeam.shield
                ),
                contentState: MatchLiveActivityAttributes.ContentState(
                    time: match.time,
                    localGoals: 0,
                    visitorGoals: 0
                )
            )
            
        } catch {
            print("ERROR - startLiveActivity - \(error.localizedDescription)")
        }
    }
    
    func updateLiveActivity(match: Match) async {
        self.match = match
        
        await activity?.update(using: MatchLiveActivityAttributes.ContentState(
            time: match.time,
            localGoals: match.score.localGoals.count,
            visitorGoals: match.score.visitorGoals.count
        ))
    }
    
    func endLiveActivity() async {
        // TODO: JLI NIL ACTIVITY ??
        // TODO: FIX END TIME TO SHOW
        await activity?.end(
            using: MatchLiveActivityAttributes.ContentState(
                time: match.time,
                localGoals: match.score.localGoals.count,
                visitorGoals: match.score.visitorGoals.count
            ),
            dismissalPolicy: .after(.now + 30)
        )
    }
}
