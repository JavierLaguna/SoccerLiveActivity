
import Foundation

struct Player: Equatable {
    let name: String
    let surname: String
    let alias: String?
    let number: Int
    let birthday: Date
    
    var shirtName: String {
        alias ?? surname
    }
    
    var age: Int {
        return 0 // TODO: JLI - Calculate
    }
}
