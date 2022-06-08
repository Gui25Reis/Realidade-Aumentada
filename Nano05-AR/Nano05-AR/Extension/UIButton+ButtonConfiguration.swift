/* Gui Reis & Gabi Namie     -    Created on 07/06/22 */


import UIKit


extension UIButton {
    
    /// Configura o ícone do botão a partir das informações da struct
    internal func setupButton(with configuration: ButtonConfiguration) -> Void {
        
        // Configuração do ícone
        let iconConfig = UIImage.SymbolConfiguration(
            pointSize: configuration.size,
            weight: configuration.weight,
            scale: configuration.scale
        )
        
        // Imagem + configuração
        let iconImage = UIImage(systemName: configuration.icon, withConfiguration: iconConfig)
        
        self.setImage(iconImage, for: .normal)
    }
}
