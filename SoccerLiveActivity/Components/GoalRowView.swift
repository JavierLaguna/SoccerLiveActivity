
import SwiftUI

struct GoalRowView: View {
    private let goal: Goal
    
    init(goal: Goal) {
        self.goal = goal
    }
    
    var body: some View {
        HStack {
            Text("\(goal.min)\"")

            Image(systemName: "soccerball")
                .resizable()
                .frame(width: 14, height: 14)
            
            Spacer()
            
            Text("\(goal.player.shirtName)")
        }
    }
}

struct GoalRowView_Previews: PreviewProvider {
    static var previews: some View {
        let koke = Player(name: "Jorge", surname: "Resurección", alias: "Koke", number: 6, birthday: Date())
        
        GoalRowView(goal: Goal(player: koke, min: 18))
    }
}
