/* Gui Reis & Gabi Namie     -    Created on 01/06/22 */


import UIKit
import ARKit


class MainView: UIView {
    
    /* MARK: - Atributos */
    
    /// View de AR principal
    private let mainView: ARSCNView = {
        let v = ARSCNView()
        
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    /// Botão de tutorial
    private let helpButton = CustomViews.newButton()
    
    
    /// Contador de fotos tiradas
    private let photosLabel = CustomViews.newLabel()
    
    
    /// Timer
    private let timerLabel = CustomViews.newLabel()
    
    
    /// Emojis
    private var emojisLabels: [UILabel] = []
    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(self.mainView)
        
        self.addSubview(self.photosLabel)
        self.addSubview(self.helpButton)
        
        self.addSubview(self.timerLabel)
        
        for _ in 0..<3 {
            let lbl = CustomViews.newLabel()
            self.addSubview(lbl)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Define os emojis na label
    public func setEmojis(with emojis: [Emojis]) -> Void {
        for ind in 0..<3 {
            self.emojisLabels[ind].text = emojis[ind].description
        }
    }
    
    /// Define o delegate da View AR
    public func setViewDelegate(with delegate: ARSCNViewDelegate) -> Void {
        self.mainView.delegate = delegate
    }
    
    /// Cria o tipo da configuraçào que a View AR vai fazer
    public func runConfiguration(with configuration: ARConfiguration) -> Void {
        self.mainView.session.run(configuration)
    }
    
    /// Pausa a sessão
    public func pauseSession() -> Void {
        self.mainView.session.pause()
    }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func layoutSubviews() -> Void {
        super.layoutSubviews()
        
        let space: CGFloat = 25
        let square: CGFloat = 60
                
        NSLayoutConstraint.activate([
            
            // View AR
            self.mainView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mainView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mainView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

