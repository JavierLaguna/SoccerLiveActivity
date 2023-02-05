
import SwiftUI

struct TeamShieldView: View {
    private let team: Team
    
    init(team: Team) {
        self.team = team
    }
    
    var body: some View {
        VStack {
            Image(team.shield)
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.bottom, 2)
            
            Text(team.name)
                .font(.footnote)
        }
    }
}

struct TeamShieldView_Previews: PreviewProvider {
    static var previews: some View {
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
        
        TeamShieldView(team: atleti)
    }
}
