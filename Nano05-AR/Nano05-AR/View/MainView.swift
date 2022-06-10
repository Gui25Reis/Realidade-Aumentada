/* Gui Reis & Gabi Namie     -    Created on 01/06/22 */


import UIKit
import ARKit


class MainView: UIView {
    
    /* MARK: - Atributos */
    
    /// View de AR principal
     let mainView: ARSCNView = {
        let v = ARSCNView()
        v.tag = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    /// Botão de tutorial
    private let helpButton = CustomViews.newButton()
    
    /// Botão para finalizar
    private let cancelButton = CustomViews.newButton()
    
    /// Botão de começar
    private let startButton = CustomViews.newButton()
    
    /// Contador de fotos tiradas
    private let photosLabel = CustomViews.newLabel()
    
    /// Timer
    private let timerLabel = CustomViews.newLabel()
    
    /// Texto para explicar o que precisa ser feito
    private let tipsLabel = CustomViews.newLabel()
    
    /// Emojis
    private var emojisLabels: [UILabel] = []
    
    /// View verificadas
    private var emojisChecked: [UIView] = []
    
    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(self.mainView)
        
        self.addSubview(self.cancelButton)
        self.addSubview(self.helpButton)
        self.addSubview(self.startButton)
        
        self.addSubview(self.photosLabel)
        self.addSubview(self.timerLabel)
        self.addSubview(self.tipsLabel)
        
        for _ in 0..<3 {
            // Label
            let lbl = CustomViews.newLabel()
        
            self.emojisLabels.append(lbl)
            self.addSubview(lbl)
            
            
            // Img verificada
            let image = UIImage(named: "EmojiValidation.png")
            let imgView = CustomViews.newImgView(with: image)
            self.emojisChecked.append(imgView)
            self.addSubview(imgView)
        }
        
        self.helpButton.isHidden = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /* Label */
    
    /// Define as configurações da label de contador de fotos tiradas
    public func setupPhotoCountLabel(with configuration: LabelConfiguration) -> Void {
        self.photosLabel.setupLabel(with: configuration)
    }
    
    
    /// Define as configurações da label do timer
    public func setupTimerLabel(with configuration: LabelConfiguration) -> Void {
        self.timerLabel.setupLabel(with: configuration)
    }
    
    
    /// Define as configurações da label de dicas
    public func setupTipsLabel(with configuration: LabelConfiguration) -> Void {
        self.tipsLabel.setupLabel(with: configuration)
    }
    
    
    /// Define as configurações das labels do emoji
    public func setupEmojisLabel(with configuration: LabelConfiguration) -> Void {
        for label in self.emojisLabels {
            label.setupLabel(with: configuration)
        }
    }
    
    
    /* Botão */
    
    /// Define a configuração do botão de iniciar
    public func setupStartButton(with configuration: ButtonConfiguration) -> Void {
        self.setupButton(for: self.startButton, with: configuration)
    }
    
    /// Define a configuração do botão de ajuda
    public func setupHelpButton(with configuration: ButtonConfiguration) -> Void {
        self.setupButton(for: self.helpButton, with: configuration)
    }
    
    /// Define a configuração do botão de cancelar
    public func setupCancelButton(with configuration: ButtonConfiguration) -> Void {
        self.setupButton(for: self.cancelButton, with: configuration)
    }
    
    
    /* View */
    
    /// Faz mostra/tira views a partir do estado dela.
    public func setupView(by status: ARStatus) {
        self.timerLabel.isHidden = true
        
        var visualization: Bool
        
        switch status {
        case .notStarted:
            visualization = true
            
            for label in self.emojisChecked {
                label.isHidden = visualization
            }
            self.setTipsLabelVisibility(to: false)
            
        case .inProgress, .takingPhoto:
            visualization = false
            self.setTipsLabelVisibility(to: true)
        
        case .ended:
            visualization = true
            
            for label in self.emojisChecked {
                label.isHidden = visualization
            }
            self.setTipsLabelVisibility(to: false)
        }
        
        for label in self.emojisLabels {
            label.isHidden = visualization
        }
        
        self.photosLabel.isHidden = visualization
        self.cancelButton.isHidden = visualization
        
        self.startButton.isHidden = !visualization
        
    }
    
    
    /* Outros */
    
    /// Define os emojis na label
    public func setEmojis(with emojis: [Emojis]) -> Void {
        for ind in 0..<emojis.count {
            self.emojisLabels[ind].text = emojis[ind].description
        }
    }
    
    
    /// Define se um emoji
    public func setEmojiValidation(to validation: Bool, for emoji: Emojis) -> Void {
        for index in 0..<emojisLabels.count {
            if MainViewController.emojisSelected[index] == emoji {
                self.emojisChecked[index].isHidden = !validation
            }
        }
    }
    
    
    /// Define o contador de fotos tiradas
    public func setPhotoCount(to count: Int, _ max: Int = 4) -> Void {
        self.photosLabel.text = "\(count)/\(max)"
    }
    
    
    /// Tira foto da tela
    public func takeScreenShot() -> UIImage {
        for emojis in emojisChecked {
            emojis.isHidden = true
        }
        return self.mainView.snapshot()
    }
    
    
    /// Define a visibilidade da label de dicas
    public func setTipsLabelVisibility(to visibility: Bool) -> Void {
        self.tipsLabel.isHidden = !visibility
    }
    

    /* Timer */
    
    /// Esconde/Mostra o timer
    public func setTimerVisibility(to visibility: Bool) -> Void {
        self.timerLabel.isHidden = !visibility
    }
    
    
    /// Define o texto que vai na label do timer
    public func setTimerText(to timer: Int) -> Void {
        self.timerLabel.text = "\(timer)"
    }
    
    
    /* AR View */
    
    /// Define o delegate da View AR
    public func setViewDelegate(with delegate: ARSessionDelegate) -> Void {
        self.mainView.session.delegate = delegate
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
    
    /// Constraints
    public override func layoutSubviews() -> Void {
        super.layoutSubviews()
        
        let space: CGFloat = 25
        let square: CGFloat = 70
        let safeArea: CGFloat = 50
        let button: CGFloat = 40
        
        
        NSLayoutConstraint.activate([
            
            // View AR
            self.mainView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.mainView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.mainView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            
            /* Labels */
            
            // Contador de fotos
            self.photosLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.photosLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.photosLabel.heightAnchor.constraint(equalToConstant: 40),
            self.photosLabel.widthAnchor.constraint(equalToConstant: 60),
            
            // Timer
            self.timerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.timerLabel.heightAnchor.constraint(equalToConstant: 120),
            self.timerLabel.widthAnchor.constraint(equalToConstant: 80),
            
            // Dicas
            self.tipsLabel.centerXAnchor.constraint(equalTo: self.emojisLabels[1].centerXAnchor),
            self.tipsLabel.bottomAnchor.constraint(equalTo: self.emojisLabels[1].topAnchor, constant: -space),
            self.tipsLabel.heightAnchor.constraint(equalToConstant: 40),
            self.tipsLabel.widthAnchor.constraint(equalToConstant: square*3 + space*2),
            
            
            /* Botões */
            
            // Ajuda
            self.helpButton.centerYAnchor.constraint(equalTo: self.photosLabel.centerYAnchor),
            self.helpButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: space),
            self.helpButton.heightAnchor.constraint(equalToConstant: button),
            self.helpButton.widthAnchor.constraint(equalToConstant: button),
            
            // Cancelar
            self.cancelButton.centerYAnchor.constraint(equalTo: self.photosLabel.centerYAnchor),
            self.cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space),
            self.cancelButton.heightAnchor.constraint(equalToConstant: button),
            self.cancelButton.widthAnchor.constraint(equalToConstant: button),
            
            // Começar
            self.startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
            self.startButton.heightAnchor.constraint(equalToConstant: square),
            self.startButton.widthAnchor.constraint(equalToConstant: square),
            
            
            /* Emojis */
            
            // Meio
            self.emojisLabels[1].centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emojisLabels[1].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
            self.emojisLabels[1].heightAnchor.constraint(equalToConstant: square),
            self.emojisLabels[1].widthAnchor.constraint(equalToConstant: square),
            
            // Esquerda
            self.emojisLabels[0].centerYAnchor.constraint(equalTo: self.emojisLabels[1].centerYAnchor),
            self.emojisLabels[0].bottomAnchor.constraint(equalTo: self.emojisLabels[1].bottomAnchor),
            self.emojisLabels[0].heightAnchor.constraint(equalToConstant: square),
            self.emojisLabels[0].widthAnchor.constraint(equalToConstant: square),
            self.emojisLabels[0].rightAnchor.constraint(equalTo: self.emojisLabels[1].leftAnchor, constant: -space),
            
            // Direita
            self.emojisLabels[2].centerYAnchor.constraint(equalTo: self.emojisLabels[1].centerYAnchor),
            self.emojisLabels[2].bottomAnchor.constraint(equalTo: self.emojisLabels[1].bottomAnchor),
            self.emojisLabels[2].heightAnchor.constraint(equalToConstant: square),
            self.emojisLabels[2].widthAnchor.constraint(equalToConstant: square),
            self.emojisLabels[2].leftAnchor.constraint(equalTo: self.emojisLabels[1].rightAnchor, constant: space),
            
            
            /* Emojis validados */
            
            // Meio
            self.emojisChecked[1].centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emojisChecked[1].bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -safeArea),
            self.emojisChecked[1].heightAnchor.constraint(equalToConstant: square),
            self.emojisChecked[1].widthAnchor.constraint(equalToConstant: square),
            
            // Esquerda
            self.emojisChecked[0].centerYAnchor.constraint(equalTo: self.emojisChecked[1].centerYAnchor),
            self.emojisChecked[0].bottomAnchor.constraint(equalTo: self.emojisChecked[1].bottomAnchor),
            self.emojisChecked[0].heightAnchor.constraint(equalToConstant: square),
            self.emojisChecked[0].widthAnchor.constraint(equalToConstant: square),
            self.emojisChecked[0].rightAnchor.constraint(equalTo: self.emojisChecked[1].leftAnchor, constant: -space),
            
            // Direita
            self.emojisChecked[2].centerYAnchor.constraint(equalTo: self.emojisChecked[1].centerYAnchor),
            self.emojisChecked[2].bottomAnchor.constraint(equalTo: self.emojisChecked[1].bottomAnchor),
            self.emojisChecked[2].heightAnchor.constraint(equalToConstant: square),
            self.emojisChecked[2].widthAnchor.constraint(equalToConstant: square),
            self.emojisChecked[2].leftAnchor.constraint(equalTo: self.emojisChecked[1].rightAnchor, constant: space),
        ])
    }
    
    
    
    /* MARK: - Outros */
    
    
    /// Faz a configuração do botão
    private func setupButton(for button: UIButton, with configuration: ButtonConfiguration) -> Void {
        button.setupButton(with: configuration)
        button.addTarget(configuration.target, action: configuration.action, for: .touchDown)
    }
}

