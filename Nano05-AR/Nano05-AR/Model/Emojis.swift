/* Gui Reis & Gabi Namie     -    Created on 02/06/22 */

/// Possíveis emojis
enum Emojis: CustomStringConvertible, CaseIterable {
    case dormindinho
    case linguinha
    case beijinho
    case baguncadinho
    case contentizinho
    case surpresinho
    case boiolinha
    case dozinha
    case segredinho
    case safadinho
    case diabinho
    case bravinho

    var description: String {
        switch self {
        case .dormindinho: return "😑"
        case .linguinha: return "😛"
        case .beijinho: return "😙"
        case .baguncadinho: return "🤨"
        case .contentizinho: return "😃"
        case .surpresinho: return "😮"
        case .boiolinha: return "☺️"
        case .dozinha: return "🥺"
        case .segredinho: return "🤫"
        case .safadinho: return "😏"
        case .diabinho: return "😈"
        case .bravinho: return "😠"
        }
    }
}
