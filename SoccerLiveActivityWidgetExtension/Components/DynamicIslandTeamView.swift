
import SwiftUI

struct DynamicIslandTeamView: View {
    
    enum GoalsAt {
        case left
        case right
    }
    
    private let team: String
    private let shield: String
    private let goals: Int
    private let goalsAt: GoalsAt
    
    init(team: String, shield: String, goals: Int, goalsAt: GoalsAt = .right) {
        self.team = team
        self.shield = shield
        self.goals = goals
        self.goalsAt = goalsAt
    }
    
    var body: some View {
        HStack {
            if goalsAt == .left {
                GoalsText(goals: goals)
            }
            
            VStack {
                Image(shield)
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text(team)
                    .fontWeight(.semibold)
            }
            
            if goalsAt == .right {
                GoalsText(goals: goals)
            }
        }
    }
}

private struct GoalsText: View {
    
    private let goals: Int
    
    init(goals: Int) {
        self.goals = goals
    }
    
    var body: some View {
        Text("\(goals)")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}
