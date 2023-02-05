
import SwiftUI
import WidgetKit
import ActivityKit

struct LockScreenView: View {
    
    private let context: ActivityViewContext<MatchLiveActivityAttributes>
    
    init(context: ActivityViewContext<MatchLiveActivityAttributes>) {
        self.context = context
    }
    
    var body: some View {
        VStack {
            HeaderView(stadium: context.attributes.stadium,
                       time: context.state.time.label)
            
            HStack {
                Spacer()
                
                TeamView(name: context.attributes.localTeamName,
                         shield: context.attributes.localTeamShield)
                
                Spacer()
                
                ScoreView(localGoals: context.state.localGoals,
                          visitorGoals: context.state.visitorGoals)
                
                Spacer()
                
                TeamView(name: context.attributes.visitorTeamName,
                         shield: context.attributes.visitorTeamShield)
                
                Spacer()
            }
        }
        .padding()
    }
}

private struct HeaderView: View {
    
    private let stadium: String
    private let time: String
    
    init(stadium: String, time: String) {
        self.stadium = stadium
        self.time = time
    }
    
    var body: some View {
        VStack {
            Text(stadium)
                .font(.subheadline)
                .underline()
            
            Spacer()
            
            Text(time)
                .font(.title)
        }
    }
}

private struct TeamView: View {
    
    private let name: String
    private let shield: String
    
    init(name: String, shield: String) {
        self.name = name
        self.shield = shield
    }
    
    var body: some View {
        VStack {
            Image(shield)
                .resizable()
                .frame(width: 46, height: 46)
            
            Text(name)
                .fontWeight(.semibold)
        }
    }
}

private struct ScoreView: View {
    
    private let localGoals: Int
    private let visitorGoals: Int
    
    init(localGoals: Int, visitorGoals: Int) {
        self.localGoals = localGoals
        self.visitorGoals = visitorGoals
    }
    
    var body: some View {
        ScoreTextView("\(localGoals)")
        
        ScoreTextView("-")
        
        ScoreTextView("\(visitorGoals)")
    }
}

private struct ScoreTextView: View {
    
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}
