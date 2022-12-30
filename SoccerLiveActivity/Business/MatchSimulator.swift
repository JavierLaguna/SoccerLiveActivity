
import Foundation

final class MatchSimulator: ObservableObject {
    
    private let simulateDuration: Duration = .seconds(1)
    private let breakTime = 5
    private let endTime = 5
    
    @Published private(set) var match: Match
    private let firstTimeDuration: Int
    private let secondTimeDuration: Int
    
    private var matchMinute = 0
    private var breakMinute = 0
        
    init(match: Match) {
        self.match = match
        firstTimeDuration = Int.random(in: 45...47)
        secondTimeDuration = Int.random(in: 90...95)
    }
    
    func startSimulation() async {
        await startFirstPart()
        
        await startBreak()
        
        await startSecondPart()
        
        endMatch()
    }
    
    private func startFirstPart() async {
        matchMinute = 0
        match.startMatch()
        
        while matchMinute <= firstTimeDuration {
            await waitSimulateTime()
            
            simulateGoal()
            matchMinute += 1
            match.updateTime(min: matchMinute)
        }
    }
    
    private func startBreak() async {
        breakMinute = 0
        match.breakMatch()
        
        while breakMinute <= breakTime {
            await waitSimulateTime()
            
            breakMinute += 1
        }
    }
    
    private func startSecondPart() async {
        matchMinute = 45
        match.startSecondPart()
        
        while matchMinute <= secondTimeDuration {
            await waitSimulateTime()
            
            simulateGoal()
            matchMinute += 1
            match.updateTime(min: matchMinute)
        }
    }
    
    private func endMatch() {
        match.endMatch()
    }
    
    private func simulateGoal() {
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
    
    private func waitSimulateTime() async {
        // TODO: JLI !
        try! await Task.sleep(until: .now + simulateDuration, clock: .continuous)
    }
}
