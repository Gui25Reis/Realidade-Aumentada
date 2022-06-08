/* Gui Reis & Gabi Namie     -    Created on 03/06/22 */


import UIKit
import ARKit

class ResultView: UIView {
    
    /* MARK: - Atributos */
    
    /// Fotos tiradas
    private var photosView: [PhotoView] = []
    
    /// View para deixar as foto juntas
    private let photosContainer = CustomViews.newView()
    
    
    
    /* MARK: - Construtor */
    
    init(photosTaken: [PhotoTaken]) {
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        
        // Fotos
        self.addSubview(self.photosContainer)
        
        for photo in photosTaken {
            let photoView = PhotoView(image: photo.image, emojis: photo.emojis)
            
            self.photosView.append(photoView)
            self.addSubview(photoView)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    public func setEmojisVisualization(to visualization: Bool) -> Void {
        for emoji in photosView {
            emoji.setEmojisVisualization(to: visualization)
        }
    }
    
    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() -> Void {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            /* Fotos */
            self.photosContainer.topAnchor.constraint(equalTo: self.topAnchor),
            self.photosContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.photosContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.photosContainer.heightAnchor.constraint(equalToConstant: self.frame.height),
            self.photosContainer.widthAnchor.constraint(equalToConstant: self.frame.width),
            
            // Quadrante 1
            self.photosView[1].topAnchor.constraint(equalTo: self.photosContainer.topAnchor),
            self.photosView[1].rightAnchor.constraint(equalTo: self.photosContainer.rightAnchor),
            self.photosView[1].bottomAnchor.constraint(equalTo: self.photosContainer.centerYAnchor),
            self.photosView[1].leftAnchor.constraint(equalTo: self.photosContainer.centerXAnchor),
            
            // Quadrante 2
            self.photosView[0].topAnchor.constraint(equalTo: self.photosContainer.topAnchor),
            self.photosView[0].leftAnchor.constraint(equalTo: self.photosContainer.leftAnchor),
            self.photosView[0].bottomAnchor.constraint(equalTo: self.photosContainer.centerYAnchor),
            self.photosView[0].rightAnchor.constraint(equalTo: self.photosContainer.centerXAnchor),
            
            // Quadrante 2
            self.photosView[2].topAnchor.constraint(equalTo: self.photosContainer.centerYAnchor),
            self.photosView[2].leftAnchor.constraint(equalTo: self.photosContainer.leftAnchor),
            self.photosView[2].bottomAnchor.constraint(equalTo: self.photosContainer.bottomAnchor),
            self.photosView[2].rightAnchor.constraint(equalTo: self.photosContainer.centerXAnchor),
            
            // Quadrante 4
            self.photosView[3].topAnchor.constraint(equalTo: self.photosContainer.centerYAnchor),
            self.photosView[3].rightAnchor.constraint(equalTo: self.photosContainer.rightAnchor),
            self.photosView[3].bottomAnchor.constraint(equalTo: self.photosContainer.bottomAnchor),
            self.photosView[3].leftAnchor.constraint(equalTo: self.photosContainer.centerXAnchor)
        ])
    }
}
