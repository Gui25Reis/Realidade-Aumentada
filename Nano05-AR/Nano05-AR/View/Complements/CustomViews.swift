/* Gui Reis & Gabi Namie     -    Created on 02/06/22 */


import UIKit


class CustomViews {
    
    /// Cria uma label com a configuração padrão do sistema
    static func newLabel() -> UILabel {
        let lbl = UILabel()
        
        lbl.textColor = .systemGray6
        lbl.textAlignment = .center
        lbl.backgroundColor = .secondaryLabel
        
        lbl.layer.cornerRadius = 10
        lbl.layer.masksToBounds = true
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    
    /// Cria um botão com a configuração padrão do sistema
    static func newButton() -> UIButton {
        let bt = UIButton()
    
        bt.backgroundColor = .secondaryLabel
        bt.tintColor = .systemGray6
        
        bt.layer.cornerRadius = 10
        bt.layer.masksToBounds = true

        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }
    
    
    /// Cria uma view com a configuração padrão do sistema
    static func newView(with color: UIColor? = nil) -> UIView {
        let v = UIView()
        
        if let color = color {
            v.backgroundColor = color
        }
        
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.clipsToBounds = true

        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    
    /// Cria uma view com a configuração padrão do sistema
    static func newImgView(with image: UIImage?) -> UIImageView {
        let imgView = UIImageView(image: image)
        
        imgView.backgroundColor = .secondaryLabel
        imgView.alpha = 0.7
        
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }
}
