
import SwiftUI

struct MatchTimeView: View {
    private let time: MatchTime
    
    var timeValue: String {
        switch time {
        case .notStarted:
            return "No empezado"
        case .firstPart(let min):
            return "\(min)\" (1ª Parte)"
        case .breakTime:
            return "Descanso"
        case .secondPart(let min):
            return "\(min)\" (2ª Parte)"
        case .finished:
            return "Finalizado"
        }
    }
    
    init(time: MatchTime) {
        self.time = time
    }
    
    var body: some View {
        Text(timeValue.uppercased())
            .font(.subheadline)
    }
}

struct MatchTimeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchTimeView(time: .firstPart(min: 35))
    }
}
