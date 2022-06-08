/* Gui Reis & Gabi Namie     -    Created on 07/06/22 */


import UIKit


extension UILabel {
    
    /// Configura a label a partir das informações da struct
    internal func setupLabel(with configuration: LabelConfiguration) -> Void {
        self.text = configuration.initialText
        
        if let familyName = configuration.family {
            self.font = UIFont(name: familyName, size: configuration.size)
            self.font.withSize(configuration.size)
        } else {
            self.font = .systemFont(ofSize: configuration.size, weight: configuration.weight)
        }
    }
}
