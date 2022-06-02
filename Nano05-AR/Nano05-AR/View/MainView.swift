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
    
    /// Botão de começar
    private let startButton = CustomViews.newButton()
    
    
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
        
        self.addSubview(self.helpButton)
        self.addSubview(self.startButton)
        
        self.addSubview(self.photosLabel)
        self.addSubview(self.timerLabel)
        
        for _ in 0..<3 {
            let lbl = CustomViews.newLabel()
            lbl.text = Emojis.beijinho.description
            lbl.font = .systemFont(ofSize: 65, weight: .black)
            self.emojisLabels.append(lbl)
            self.addSubview(lbl)
        }
        
        let configIcon = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .large)
        self.helpButton.setImage(UIImage(systemName: "info.circle", withConfiguration: configIcon), for: .normal)
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
        let square: CGFloat = 70
        let safeArea: CGFloat = 50
        self.photosLabel.backgroundColor = .secondaryLabel
        self.photosLabel.text = "2/3"
        self.photosLabel.font = .systemFont(ofSize: 20, weight: .bold)
        self.timerLabel.text = "1"
        self.timerLabel.font = .systemFont(ofSize: 90, weight: .black)
                
        NSLayoutConstraint.activate([
            
            // View AR
            self.mainView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mainView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mainView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            // Photos Label
            self.photosLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.photosLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: space),
            self.photosLabel.heightAnchor.constraint(equalToConstant: 40),
            self.photosLabel.widthAnchor.constraint(equalToConstant: 60),
            
            // Help Button
            self.helpButton.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.helpButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space),
            self.helpButton.heightAnchor.constraint(equalToConstant: 50),
            self.helpButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
            self.startButton.heightAnchor.constraint(equalToConstant: square),
            self.startButton.widthAnchor.constraint(equalToConstant: square),
            
            self.timerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.timerLabel.heightAnchor.constraint(equalToConstant: 120),
            self.timerLabel.widthAnchor.constraint(equalToConstant: 80),
            
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
    }
}

