
import Foundation
import ActivityKit

final class LiveActivityManager {
    
    private let endActivityDuration: Duration = .seconds(10)
    
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
                content: .init(
                    state: MatchLiveActivityAttributes.ContentState(
                        time: match.time,
                        localGoals: 0,
                        visitorGoals: 0
                    ),
                    staleDate: nil
                ),
                pushType: nil
            )
            
        } catch {
            print("ERROR - startLiveActivity - \(error.localizedDescription)")
        }
    }
    
    func updateLiveActivity(match: Match) async {
        self.match = match
        
        await activity?.update(.init(
            state: MatchLiveActivityAttributes.ContentState(
                time: match.time,
                localGoals: match.score.localGoals.count,
                visitorGoals: match.score.visitorGoals.count
            ),
            staleDate: nil
        ))
    }
    
    func endLiveActivity() async {
        
        await TimerUtils.waitTime(time: endActivityDuration)
        
        await activity?.end(
            .init(
                state: MatchLiveActivityAttributes.ContentState(
                    time: match.time,
                    localGoals: match.score.localGoals.count,
                    visitorGoals: match.score.visitorGoals.count
                ),
                staleDate: nil
            ),
            dismissalPolicy: .immediate
        )
        
        activity = nil
    }
}
