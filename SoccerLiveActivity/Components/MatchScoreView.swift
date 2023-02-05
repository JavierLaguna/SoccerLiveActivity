
import SwiftUI

struct MatchScoreView: View {
    
    private let localGoals: Int
    private let visitorGoals: Int
    
    init(localGoals: Int, visitorGoals: Int) {
        self.localGoals = localGoals
        self.visitorGoals = visitorGoals
    }
    
    var body: some View {
        HStack {
            Text("\(localGoals)")
                .font(.title2)
            
            Text(" - ")
                .font(.title2)
            
            Text("\(visitorGoals)")
                .font(.title2)
        }
        .padding()
        .background(.black.opacity(0.1))
        .cornerRadius(8)
    }
}

struct MatchScoreView_Previews: PreviewProvider {
    static var previews: some View {
        MatchScoreView(
            localGoals: 10,
            visitorGoals: 2
        )
    }
}
