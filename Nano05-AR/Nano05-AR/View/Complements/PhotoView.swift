/* Gui Reis & Gabi Namie     -    Created on 06/06/22 */


import UIKit
import ARKit


class PhotoView: UIView {
    
    /* MARK: - Atributos */
    
    /// Imagem tirada
    private let mainView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    /// Emojis
    private var emojisLabels: [UILabel] = []
    
    /// Emojis selecionados
    private var emojisSelected: [Emojis]
    
    
    
    /* MARK: - Construtor */
    
    init(image: UIImage, emojis: [Emojis]) {
        self.emojisSelected = emojis
        
        super.init(frame: .zero)
        
        // Imagem
        self.mainView.image = image
        self.addSubview(self.mainView)
        
        // Emojis
        for emoji in emojis {
            let lbl = CustomViews.newLabel()
            lbl.text = emoji.description
            
            self.emojisLabels.append(lbl)
            self.addSubview(lbl)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    /// Constraints
    public override func layoutSubviews() -> Void {
        super.layoutSubviews()
        
        let space: CGFloat = 25
        let square: CGFloat = 35
        let safeArea: CGFloat = 25
        
        /// Divide a tela em 3 pra posicionar os dois emojis (quando forem dois)
        let width4 = self.frame.width/4
        
        // View AR
        NSLayoutConstraint.activate([
            self.mainView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mainView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mainView.rightAnchor.constraint(equalTo: self.rightAnchor)
            
        ])
        
        // Emojis
        switch self.emojisSelected.count {
        case 1:
            NSLayoutConstraint.activate([
                self.emojisLabels[0].centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.emojisLabels[0].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
                self.emojisLabels[0].heightAnchor.constraint(equalToConstant: square),
                self.emojisLabels[0].widthAnchor.constraint(equalToConstant: square),
            ])
        
        case 2:
            NSLayoutConstraint.activate([
                self.emojisLabels[0].centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -width4),
                self.emojisLabels[0].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
                self.emojisLabels[0].heightAnchor.constraint(equalToConstant: square),
                self.emojisLabels[0].widthAnchor.constraint(equalToConstant: square),
                
                                            
                self.emojisLabels[1].centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: width4),
                self.emojisLabels[1].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
                self.emojisLabels[1].heightAnchor.constraint(equalToConstant: square),
                self.emojisLabels[1].widthAnchor.constraint(equalToConstant: square),
            ])
        
        case 3:
            NSLayoutConstraint.activate([
                self.emojisLabels[1].centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.emojisLabels[1].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
                self.emojisLabels[1].heightAnchor.constraint(equalToConstant: square),
                self.emojisLabels[1].widthAnchor.constraint(equalToConstant: square),
                
                self.emojisLabels[0].centerYAnchor.constraint(equalTo: self.emojisLabels[1].centerYAnchor),
                self.emojisLabels[0].bottomAnchor.constraint(equalTo: self.emojisLabels[1].bottomAnchor),
                self.emojisLabels[0].heightAnchor.constraint(equalToConstant: square),
                self.emojisLabels[0].widthAnchor.constraint(equalToConstant: square),
                self.emojisLabels[0].rightAnchor.constraint(equalTo: self.emojisLabels[1].leftAnchor, constant: -space),
                
                self.emojisLabels[2].centerYAnchor.constraint(equalTo: self.emojisLabels[1].centerYAnchor),
                self.emojisLabels[2].bottomAnchor.constraint(equalTo: self.emojisLabels[1].bottomAnchor),
                self.emojisLabels[2].heightAnchor.constraint(equalToConstant: square),
                self.emojisLabels[2].widthAnchor.constraint(equalToConstant: square),
                self.emojisLabels[2].leftAnchor.constraint(equalTo: self.emojisLabels[1].rightAnchor, constant: space),
            ])
            
        default: break
        }
    }
}
