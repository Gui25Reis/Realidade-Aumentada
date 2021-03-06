/* Gui Reis & Gabi Namie     -    Created on 02/06/22 */

/// Possรญveis emojis
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
        case .dormindinho: return "๐"
        case .linguinha: return "๐"
        case .beijinho: return "๐"
        case .baguncadinho: return "๐คจ"
        case .contentizinho: return "๐"
        case .surpresinho: return "๐ฎ"
        case .boiolinha: return "โบ๏ธ"
        case .dozinha: return "๐ฅบ"
        case .segredinho: return "๐คซ"
        case .safadinho: return "๐"
        case .diabinho: return "๐"
        case .bravinho: return "๐ "
        }
    }
}
