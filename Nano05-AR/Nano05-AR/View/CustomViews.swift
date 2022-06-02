/* Gui Reis & Gabi Namie     -    Created on 02/06/22 */


import UIKit


class CustomViews {
    
    static func newLabel() -> UILabel {
        let lbl = UILabel()
        
        lbl.textColor = .systemGray3
        lbl.textAlignment = .center
        lbl.backgroundColor = .secondaryLabel
        
        lbl.layer.cornerRadius = 10

        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    
    static func newButton() -> UIButton {
        let bt = UIButton()
    
        bt.backgroundColor = .secondaryLabel

        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }
}
