/* Gui Reis & Gabi Namie     -    Created on 07/06/22 */


import UIKit

/// Informações para configuração inicial da Label
struct LabelConfiguration {
    let initialText: String
    let size: CGFloat
    let weight: UIFont.Weight
    let family: String?
    
    init(initialText: String, size: CGFloat, weight: UIFont.Weight) {
        self.initialText = initialText
        self.size = size
        self.weight = weight
        self.family = nil
    }
    
    init(initialText: String, size: CGFloat, weight: UIFont.Weight, familyName: String) {
        self.initialText = initialText
        self.size = size
        self.weight = weight
        self.family = familyName
    }
}
