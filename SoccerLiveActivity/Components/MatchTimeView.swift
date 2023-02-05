
import SwiftUI

struct MatchTimeView: View {
    
    private let time: MatchTime

    init(time: MatchTime) {
        self.time = time
    }
    
    var body: some View {
        Text(time.label.uppercased())
            .font(.subheadline)
    }
}

struct MatchTimeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchTimeView(time: .firstPart(min: 35))
    }
}
