
enum MatchTime {
    case notStarted
    case firstPart(min: Int)
    case breakTime
    case secondPart(min: Int)
    case finished
}
