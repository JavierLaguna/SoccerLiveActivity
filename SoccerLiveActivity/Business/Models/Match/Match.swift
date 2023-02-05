
import Foundation

struct Match {
    let localTeam: Team
    let visitorTeam: Team
    private(set) var time: MatchTime
    private(set) var score: MatchScore
    let localInitPlayers: [Player]
    let localInitBench: [Player]
    private(set) var localCurrentPlayers: [Player]
    private(set) var localCurrentBench: [Player]
    private(set) var localSubstitution: [MatchSubstitution]
    let visitorInitPlayers: [Player]
    let visitorInitBench: [Player]
    private(set) var visitorCurrentPlayers: [Player]
    private(set) var visitorCurrentBench: [Player]
    private(set) var visitorSubstitution: [MatchSubstitution]
    let date: Date
    
    var stadium: String {
        localTeam.stadium
    }
    
    var matchMinute: Int? {
        switch time {
        case .firstPart(let min), .secondPart(let min):
            return min
        default:
            return nil
        }
    }
    
    init(local: Team, visitor: Team, localInitPlayers: [Player], localInitBench: [Player], visitorInitPlayers: [Player], visitorInitBench: [Player], date: Date) {
        localTeam = local
        visitorTeam = visitor
        time = .notStarted
        score = MatchScore(localGoals: [], visitorGoals: [])
        self.localInitPlayers = localInitPlayers
        self.localInitBench = localInitBench
        localCurrentPlayers = localInitPlayers
        localCurrentBench = localInitBench
        localSubstitution = []
        self.visitorInitPlayers = visitorInitPlayers
        self.visitorInitBench = visitorInitBench
        visitorCurrentPlayers = visitorInitPlayers
        visitorCurrentBench = visitorInitBench
        visitorSubstitution = []
        self.date = date
    }
    
    mutating func startMatch() {
        time = .firstPart(min: 0)
    }
    
    mutating func breakMatch() {
        time = .breakTime
    }
    
    mutating func startSecondPart() {
        time = .secondPart(min: 45)
    }
    
    mutating func endMatch() {
        time = .finished
    }
    
    mutating func updateTime(min: Int) {
        if case .firstPart = time {
            time = .firstPart(min: min)
        } else if case .secondPart = time {
            time = .secondPart(min: min)
        }
    }
    
    mutating func doLocalSubstitution(in inPlayer: Player, out outPlayer: Player) {
        localCurrentPlayers.removeAll(where: { $0 == outPlayer })
        localCurrentPlayers.append(inPlayer)
        
        localCurrentBench.removeAll(where: { $0 == inPlayer })
        localCurrentBench.append(outPlayer)
        
        let substitution = MatchSubstitution(inPlayer: inPlayer, outPlayer: outPlayer, time: time)
        localSubstitution.append(substitution)
    }
    
    mutating func doVisitorSubstitution(in inPlayer: Player, out outPlayer: Player) {
        visitorCurrentPlayers.removeAll(where: { $0 == outPlayer })
        visitorCurrentPlayers.append(inPlayer)
        
        visitorCurrentBench.removeAll(where: { $0 == inPlayer })
        visitorCurrentBench.append(outPlayer)
        
        let substitution = MatchSubstitution(inPlayer: inPlayer, outPlayer: outPlayer, time: time)
        visitorSubstitution.append(substitution)
    }
    
    mutating func doLocalGoal(player: Player) {
        guard let minute = matchMinute else {
            return
        }
        
        let goal = Goal(player: player, min: minute)
        var localGoals = score.localGoals
        localGoals.append(goal)
        score = MatchScore(localGoals: localGoals, visitorGoals: score.visitorGoals)
    }
    
    mutating func doVisitorGoal(player: Player) {
        guard let minute = matchMinute else {
            return
        }
        
        let goal = Goal(player: player, min: minute)
        var visitorGoals = score.visitorGoals
        visitorGoals.append(goal)
        score = MatchScore(localGoals: score.localGoals, visitorGoals: visitorGoals)
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
            visitorInitPlayers: [modric],
            visitorInitBench: [],
            date: Date()
        )
    }
}
