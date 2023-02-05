
import SwiftUI

struct MatchView: View {
    @Environment(\.scenePhase) private var phase

    @ObservedObject private var viewModel = MatchViewModel()
        
    var body: some View {
        VStack {
            Text(viewModel.match.stadium)
                .underline()
                .font(.subheadline)
                .padding(.top)
                .padding(.bottom, 32)
            
            MatchTimeView(time: viewModel.match.time)
            
            HStack {
                TeamShieldView(team: viewModel.match.localTeam)
                    .frame(maxWidth: .infinity)
                
                MatchScoreView(
                    localGoals: viewModel.match.score.localGoals.count,
                    visitorGoals: viewModel.match.score.visitorGoals.count
                )
                
                TeamShieldView(team: viewModel.match.visitorTeam)
                    .frame(maxWidth: .infinity)
            }
            
            HStack {
                List {
                    ForEach(viewModel.match.score.localGoals, id: \.min) { goal in
                        GoalRowView(goal: goal)
                    }
                }
                
                List {
                    ForEach(viewModel.match.score.visitorGoals, id: \.min) { goal in
                        GoalRowView(goal: goal)
                    }
                }
            }
            
            Spacer()
            
            Button {
                viewModel.onPressMainButton()
            } label: {
                let title = viewModel.canPauseMatch ? "Pausar Partido" : "Empezar Partido"
                Text(title.uppercased())
                    .font(.title3)
                    .tint(.white)
            }
            .padding()
            .padding(.horizontal, 12)
            .background(.blue)
            .cornerRadius(8)
            .onChange(of: phase) { newPhase in
                switch newPhase {
                case .active:
                    viewModel.appEnterOnForeground()
                case .background:
                    viewModel.appEnterOnBackground()
                default:
                    break
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
