
import SwiftUI

struct DynamicIslandBottomView: View {
    
    private let time: String
    private let stadium: String
    
    init(time: String, stadium: String) {
        self.time = time
        self.stadium = stadium
    }
    
    var body: some View {
        VStack {
            Text(time)
                .font(.title)
            
            Spacer()
            
            Text(stadium)
                .font(.subheadline)
                .underline()
        }
    }
}
