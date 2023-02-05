
import Foundation
import UIKit

final class MatchSimulator: ObservableObject {
    
    static private let backgroundTaskName = "BackgroundMatchSimulation"
    
    private let simulateDuration: Duration = .seconds(1)
    private let breakTime = 5
    private let endTime = 5
    
    @Published private(set) var match: Match
    private let firstTimeDuration: Int
    private let secondTimeDuration: Int
    private let liveActivityManager: LiveActivityManager
    
    private var isSimulating = false
    private var matchMinute = 0
    private var breakMinute = 0
    private var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid

    init(match: Match) {
        self.match = match
        
        firstTimeDuration = Int.random(in: 45...47)
        secondTimeDuration = Int.random(in: 90...95)
        liveActivityManager = LiveActivityManager(match: match)
    }
    
    func startSimulation()  {
        isSimulating = true
        matchMinute = 0
        match.startMatch()
        
        liveActivityManager.startLiveActivity()
        
        simulationTask()
    }
    
    func pauseSimulation() async {
        isSimulating = false
        await waitSimulateTime()
    }
    
    
    func continueSimulation() {
        isSimulating = true
        simulationTask()
    }
    
    func continueSimationOnBackground() {
        DispatchQueue.global().async {
            self.backgroundTaskId = UIApplication.shared.beginBackgroundTask (withName: MatchSimulator.backgroundTaskName) {

                self.endBackgroundTask()
            }
            
            Task {
                await self.pauseSimulation()

                self.continueSimulation()
            }
        }
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTaskId)
        backgroundTaskId = .invalid
    }
}

// MARK: Private methods
private extension MatchSimulator {
    
    func simulationTask() {
        guard isSimulating else {
            return
        }
        
        Task {
            await waitSimulateTime()
            await updateMatchState()
            
            simulationTask()
        }
    }
    
    func updateMatchState() async {
        switch match.time {
        case .notStarted, .finished:
            return
        case .firstPart, .secondPart:
            await updateMatchPart()
        case .breakTime:
            await updateBreak()
        }
    }
    
    func updateMatchPart() async {
        if case .firstPart = match.time,
              matchMinute > firstTimeDuration {
            await startBreak()
            return
        }
        
        if case .secondPart = match.time,
              matchMinute > secondTimeDuration {
            await endMatch()
            return
        }

        simulateGoal()
        matchMinute += 1
        match.updateTime(min: matchMinute)
        
        await liveActivityManager.updateLiveActivity(match: match)
    }
    
    func startBreak() async {
        breakMinute = 0
        match.breakMatch()
        
        await liveActivityManager.updateLiveActivity(match: match)
    }
    
    func updateBreak() async {
        guard breakMinute <= breakTime else {
            await startSecondPart()
            return
        }
            
        breakMinute += 1
        match.updateTime(min: matchMinute)
    }
    
    func startSecondPart() async {
        matchMinute = 45
        match.startSecondPart()
        
        await liveActivityManager.updateLiveActivity(match: match)
    }
    
    func endMatch() async {
        isSimulating = false
        match.endMatch()
        
        await liveActivityManager.endLiveActivity()
        
        endBackgroundTask()
    }
    
    func simulateGoal() {
        let randomInt = Int.random(in: 0...100)
        let isGoal = randomInt >= 95
        
        if isGoal {
            let isLocalGoal = Bool.random()
            
            if isLocalGoal {
                guard let player = match.localTeam.players.first else {
                    return
                }
                
                match.doLocalGoal(player: player)
                
            } else {
                guard let player = match.visitorTeam.players.first else {
                    return
                }
                
                match.doVisitorGoal(player: player)
            }
        }
    }
    
    func waitSimulateTime() async {
        do {
            try await Task.sleep(until: .now + simulateDuration, clock: .continuous)
        } catch {
            print("ERROR - waitSimulateTime - \(error.localizedDescription)")
        }
    }
}
