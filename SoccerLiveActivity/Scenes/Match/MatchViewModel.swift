
import Foundation
import Combine

final class MatchViewModel: ObservableObject {
    
    @Published private(set) var match: Match
    private var simulator: MatchSimulator
    private var cancellables = [AnyCancellable]()
    
    init() {
        let newMatch = Match.getFakeMatch()
        self.match = newMatch
        self.simulator = MatchSimulator(match: newMatch)
        
        listenSimulationChanges()
    }
    
    func startMatch() async {
        await simulator.startSimulation()
    }
    
    private func listenSimulationChanges() {
        simulator.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.match = self.simulator.match
            }
            .store(in: &cancellables)
    }
}

extension Match {
    
    static func getFakeMatch() -> Match {
        
        let koke = Player(name: "Jorge", surname: "Resurección", alias: "Koke", number: 6, birthday: Date())
        let atleti = Team(
            name: "Atlético de Madrid",
            shortName: "ATM",
            shield: "shield_atm",
            stadium: "Civitas Metropolitano",
            foundationDate: Date(),
            coach: "Diego P. Simeone",
            players: [koke]
        )
        
        let modric = Player(name: "Luka", surname: "Modric", alias: "Modric", number: 10, birthday: Date())
        let madrid = Team(
            name: "Real Madrid",
            shortName: "RMA",
            shield: "shield_rma",
            stadium: "Santiago Bernabeu",
            foundationDate: Date(),
            coach: "Carlo Ancelotti",
            players: [modric]
        )
        
        return Match(
            local: atleti,
            visitor: madrid,
            localInitPlayers: [koke],
            localInitBench: [],
            visitorInitPlayers: [],
            visitorInitBench: [],
            date: Date()
        )
    }
}
