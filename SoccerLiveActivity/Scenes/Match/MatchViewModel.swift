
import Foundation
import Combine

final class MatchViewModel: ObservableObject {
    
    @Published private(set) var match: Match
    @Published private(set) var isSimulating = false
    private var simulator: MatchSimulator
    private var cancellables = [AnyCancellable]()
    
    var canPauseMatch: Bool {
        isSimulating && match.time != .notStarted && match.time != .finished
    }
    
    init() {
        let newMatch = Match.getFakeMatch()
        self.match = newMatch
        self.simulator = MatchSimulator(match: newMatch)
        
        listenSimulationChanges()
    }
    
    func onPressMainButton() {
        if canPauseMatch {
            Task {
                await pauseMatch()
            }
        } else if match.time == .notStarted {
            startMatch()
        } else if match.time == .finished {
            restartMatch()
        } else {
            continueMatch()
        }
    }
    
    func appEnterOnForeground() {
        guard isSimulating else {
            return
        }
        
        Task {
            simulator.endBackgroundTask()
            await pauseMatch()
            continueMatch()
        }
    }
    
    func appEnterOnBackground() {
        guard isSimulating else {
            return
        }
            
        continueMatchOnBackground()
    }
}

// MARK: Private methods
private extension MatchViewModel {
    
    func listenSimulationChanges() {
        simulator.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.match.time != .finished,
                   self.simulator.match.time == .finished {
                    self.isSimulating = false
                }
                
                self.match = self.simulator.match
            }
            .store(in: &cancellables)
    }
    
    func startMatch() {
        isSimulating = true
        simulator.startSimulation()
    }
    
    func pauseMatch() async {
        isSimulating = false
        await simulator.pauseSimulation()
    }
    
    func continueMatch() {
        isSimulating = true
        simulator.continueSimulation()
    }
    
    func continueMatchOnBackground() {
        isSimulating = true
        simulator.continueSimationOnBackground()
    }
    
    func restartMatch() {
        // TODO: FIX
        let newMatch = Match.getFakeMatch()
        self.match = newMatch
        self.simulator = MatchSimulator(match: newMatch)
        
        startMatch()
    }
}
