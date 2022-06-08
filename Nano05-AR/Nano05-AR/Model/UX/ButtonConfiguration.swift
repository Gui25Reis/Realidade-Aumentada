/* Gui Reis & Gabi Namie     -    Created on 07/06/22 */


import UIKit

/// Informações para configuração inicial do botão apenas com ícone
struct ButtonConfiguration {
    // Ícone
    let icon: String
    let size: CGFloat
    let weight: UIImage.SymbolWeight
    let scale: UIImage.SymbolScale
    
    // Ação
    let target: Any?
    let action: Selector
}
