
enum MatchTime: Equatable, Codable, Hashable {
    case notStarted
    case firstPart(min: Int)
    case breakTime
    case secondPart(min: Int)
    case finished
    
    var label: String {
        switch self {
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
    
    var labelShort: String {
        switch self {
        case .notStarted:
            return "No empezado"
        case .firstPart(let min):
            return "1T / \(min)\""
        case .breakTime:
            return "Descanso"
        case .secondPart(let min):
            return "2T / \(min)\""
        case .finished:
            return "Finalizado"
        }
    }
}
