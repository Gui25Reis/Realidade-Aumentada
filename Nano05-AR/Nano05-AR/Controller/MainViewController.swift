/* Gui Reis & Gabi Namie     -    Created on 01/06/22 */


import UIKit
import ARKit

class MainViewController: UIViewController, MainControllerDelegate {
    
    /* MARK: - Atributos */
    
    /// Delegate da view AR
    private let viewDelegate = ARMainViewDelegate()
    
    /// Capturas de tela feitas e seus emojis
    private var photoTaken: [PhotoTaken] = []
    
    /// Timer para tirar a foto
    private var timer: Timer?
    
    /// Valor do timer
    private var timerNumber: Int = 3
    
    /// Status de analize do Face Tracking
    private var statusAR: ARStatus = .notStarted
    
    /// Emojis (3) selecionados para fazer as emoções
    static var emojisSelected: [Emojis] = []
    
    /// Todos os emojis disponíveis para serem escolhidos randomicamente (em grupos de 3)
    private var allEmojis: [Emojis] = []
    
    /// Emojis que foram avaliados corretamente
    private var emojisRecognized: [Emojis] = []
    
    

    /* MARK: - Ciclo de Vida */
    
    public override func loadView() -> Void {
        super.loadView()
        
        let myView = MainView()
        self.view = myView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        guard let view = self.view as? MainView else {return}
        
        // Delegate
        self.viewDelegate.setProtocol(with: self)

        view.setViewDelegate(with: viewDelegate)
        
        
        /* TODO: LIDAR COM O ERRO */
        
        // AR
        guard ARFaceTrackingConfiguration.isSupported else {
            self.deviceNotSupportedHandler()
            return
        }
        
        
        // UX
        self.setupLabels()
        self.setupButtons()
        self.setupMenu()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        if let view = self.view as? MainView {
            
            // Configuração que a AR vai fazer
            let configuration = ARFaceTrackingConfiguration()
            configuration.maximumNumberOfTrackedFaces = 2
            
            view.runConfiguration(with: configuration)
        }
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) -> Void {
        super.viewWillDisappear(animated)
        
        if let view = self.view as? MainView {
            view.pauseSession()
        }
    }
    
    
    
    /* MARK: - Protocol */
    
    
    /// Inicia a contagem regressiva pra tirar foto
    internal func startTimer() -> Void {
        guard let view = self.view as? MainView else {return}
        self.statusAR = .takingPhoto
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self, selector: #selector(self.timerAction),
            userInfo: nil,
            repeats: true
        )
        
        self.timerNumber = 3
        view.setTimerText(to: self.timerNumber)
        view.setTimerVisibility(to: true)
        
        view.setTipsLabelVisibility(to: false)
    }
    

    /// Pega o estado atual do processo
    internal func getStatus() -> ARStatus {
        return self.statusAR
    }
    
    
    /// Adiciona os emojis que foram reconhecidos
    internal func addEmojiRecognized(with emoji: Emojis) -> Void {
        self.emojisRecognized.append(emoji)
        
        guard let view = self.view as? MainView else {return}
        view.setEmojiValidation(to: true, for: emoji)
    }
    
    
    /// Atualiza o estado do processo E configura as variáveis e view
    internal func updateStatus(to status: ARStatus) -> Void {
        self.statusAR = status
        self.configureVariable()
        self.setupMenu()
    }
    
    
    
    /* MARK: - Ações */
    
    /// Ação do botão de ajuda
    @objc func helpAction() -> Void {
        // guard let view = self.view as? MainView else {return}
    }
    
    
    /// Ação do botão de cancelar
    @objc func cancelAction() -> Void {
        // Criando alerta
        let alert = UIAlertController(
            title: "Cancelar fotos",
            message: "Tem certeza de que deseja cancelar?",
            preferredStyle: .actionSheet
        )
        
        // Botões do alerta
        let confirm = UIAlertAction(title: "Sair sem salvar", style: .destructive) { _ in
            self.statusAR = .notStarted
            self.setupMenu()
            self.photoTaken = []
        }
        alert.addAction(confirm)
        
        let confirmAndSave = UIAlertAction(title: "Sair e salvar fotos", style: .destructive, handler: nil)
        alert.addAction(confirmAndSave)
        
        let cancel = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        
        self.present(alert, animated: true)
    }
    
    
    /// Ação do botão de inicializar o jogo
    @objc func startAction() -> Void {
        guard let view = self.view as? MainView else {return}
        
        self.statusAR = .inProgress
        self.configureVariable()
        
        view.setupView(by: self.statusAR)
        
        // Configuração para inicio de jogo
        view.setEmojis(with: MainViewController.emojisSelected)
    }
    
    
    /// Ação do timer
    @objc func timerAction() -> Void {
        guard let view = self.view as? MainView else {return}
        
        // Contagem regressiva
        self.timerNumber -= 1
        view.setTimerText(to: self.timerNumber)
        
        // Finalizado
        if self.timerNumber == 0 {
            self.timer?.invalidate()
            self.takeScreenShot()
        }
    }

    
    /// Lida com o caso de dispositivos que não tem suporte para ARKit
    private func deviceNotSupportedHandler() -> Void {
        fatalError("Face tracking is not supported on this device.")
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Tira a foto
    private func takeScreenShot() -> Void {
        guard let view = self.view as? MainView else {return}
        view.setTimerVisibility(to: false)
        
        let image = view.takeScreenShot()
        
        // Salva a foto com os emojis
        let photoTaken = PhotoTaken(image: image, emojis: self.emojisRecognized)
        
        self.photoTaken.append(photoTaken)
        
        // Att o contador de fotos
        view.setPhotoCount(to: self.photoTaken.count)
        
        
        // Tirou todas as fotos
        if self.photoTaken.count == 4 {
            self.statusAR = .ended
            self.configureVariable()
            
            // Apresentando nova tela
            let vc = ResultViewController(photosTaken: self.photoTaken, delegate: self)
            vc.modalPresentationStyle = .popover
            
            let navBar = UINavigationController(rootViewController: vc)
            self.present(navBar, animated: true)
            return
        }
        
        // Att os novos emojis
        self.getRandomEmojis()
        view.setEmojis(with: MainViewController.emojisSelected)
        view.setTipsLabelVisibility(to: true)
        
        self.statusAR = .inProgress
    }
    

    /// Pega 3 emojis aleatórios
    private func getRandomEmojis() -> Void {
        self.emojisRecognized = []
        MainViewController.emojisSelected = []
        
        if self.allEmojis.count >= 3 {
            
            // Loop Unrolling
            MainViewController.emojisSelected.append( self.allEmojis.remove(at: 0) )
            MainViewController.emojisSelected.append( self.allEmojis.remove(at: 0) )
            MainViewController.emojisSelected.append( self.allEmojis.remove(at: 0) )
        }
    }
    
    
    /// Configura as variáveis da classe de acordo com o momento do jogo
    private func configureVariable() -> Void {
        switch self.statusAR {
        case .notStarted:
            self.photoTaken = []
            MainViewController.emojisSelected = []
            self.allEmojis = []
            self.setupMenu()
            guard let view = self.view as? MainView else {return}
            view.setPhotoCount(to: 0)
            
        case .inProgress:
            self.timerNumber = 3
            
            self.allEmojis = Emojis.allCases.shuffled()
            self.getRandomEmojis()
        
        case .takingPhoto:
            break
            
        case .ended:
            self.statusAR = .notStarted
            self.timerNumber = 3
            
            guard let view = self.view as? MainView else {return}
            view.setPhotoCount(to: 0)
        }
    }
    
    
    
    /* MARK: - UX */
    
    /// Faz a configuração da tela no momento inicial
    private func setupMenu() -> Void {
        guard let view = self.view as? MainView else {return}
        
        view.setupView(by: self.statusAR)
    }
    
    
    /// Faz a configuração das labels
    private func setupLabels() -> Void {
        guard let view = self.view as? MainView else {return}
        
        view.setupPhotoCountLabel(with: LabelConfiguration(initialText: "0/4", size: 20, weight: .bold))
        
        view.setupTipsLabel(with: LabelConfiguration(initialText: "Imite um dos emojis", size: 20, weight: .medium))
        
        view.setupEmojisLabel(with: LabelConfiguration(initialText: "", size: 60, weight: .black))
        
        view.setupTimerLabel(with: LabelConfiguration(initialText: "", size: 90, weight: .medium, familyName: "AvenirNext-Bold"))
    }
    
    
    /// Faz a configuração dos botões
    private func setupButtons() -> Void {
        guard let view = self.view as? MainView else {return}
        
        view.setupHelpButton(with:
            ButtonConfiguration(
                icon: "info.circle", size: 25, weight: .semibold, scale: .medium,
                target: self, action: #selector(self.helpAction))
        )
        
        view.setupCancelButton(with:
            ButtonConfiguration(
                icon: "x.circle", size: 25, weight: .semibold, scale: .medium,
                target: self, action: #selector(self.cancelAction))
        )
        
        view.setupStartButton(with:
            ButtonConfiguration(
                icon: "play.fill", size: 30, weight: .bold, scale: .medium,
                target: self, action: #selector(self.startAction))
        )
    }
}
