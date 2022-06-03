//
//  PhotosView.swift
//  Nano05-AR
//
//  Created by Gabriele Namie on 03/06/22.
//

import UIKit
import ARKit

class PhotosView: UIView {
    
    /* MARK: - Atributos */
    
    
    /// Botão de começar
    private let shareButton = CustomViews.newButton()
    
    /// Fotos tiradas
    private var photos: [UIImage] = []
    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(self.shareButton)
        
        for _ in 0..<4 {
            //let photos =
        }
        
        let configIcon = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .large)
        self.shareButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: configIcon), for: .normal)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    /* MARK: - Ciclo de Vida */
    public override func layoutSubviews() -> Void {
        super.layoutSubviews()
        let space: CGFloat = 25
        //let square: CGFloat = 70
        let safeArea: CGFloat = 50
        
        
        NSLayoutConstraint.activate([
            
            
            // Botao de compartilhar
            self.shareButton.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space),
            self.shareButton.heightAnchor.constraint(equalToConstant: 50),
            self.shareButton.widthAnchor.constraint(equalToConstant: 50),
            
        ])
    }
}
