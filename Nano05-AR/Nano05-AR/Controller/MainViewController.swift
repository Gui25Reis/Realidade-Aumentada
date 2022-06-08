/* Gui Reis & Gabi Namie     -    Created on 01/06/22 */


import UIKit
import ARKit

class MainViewController: UIViewController, MainControllerDelegate {
    
    /* MARK: - Atributos */
    
    /// Delegate da view AR
    private let viewDelegate = ARMainViewDelegate()
    
    /// Capturas de tela e  emojis
    private var photoTaken: [PhotoTaken] = []
    
    /// Timer
    private var timer: Timer?
    
    /// Valor do timer
    private var timerNumber: Int = 3
    
    /// Status
    private var statusAR: ARStatus = .notStarted
    
    
    
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
        
        // TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE
        self.starTimer()
        
        view.setEmojis(with: [.chateadinho, .enjoadinho, .beijinho])
        // TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE
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
    
    internal func setTextLabel(with text: String) -> Void {
        if let _ = self.view as? MainView {
            // view.setText(with: text)
        }
    }
    
    
    
    /* MARK: - Ações */
    
    /// Ação do botão de ajuda
    @objc func helpAction() -> Void {
        guard let view = self.view as? MainView else {return}
        
        
        // TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE
        for _ in 0..<4 {
            let photo = PhotoTaken(image: view.takeScreenShot(), emojis: [Emojis.enjoadinho, Emojis.chateadinho])
            
            self.photoTaken.append(photo)
        }
        // TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE TESTE
        
        
        // Apresentando nova tela
        let vc = ResultViewController(photosTaken: self.photoTaken)
        vc.modalPresentationStyle = .popover
        
        let navBar = UINavigationController(rootViewController: vc)
        self.present(navBar, animated: true)
        
        // Configurando tela de inicio
        self.statusAR = .notStarted
        self.photoTaken = []
        self.setupMenu()
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
        
        view.setupView(by: self.statusAR)
    }
    
    
    /// Ação do timer
    @objc func timerAction() -> Void {
        guard let view = self.view as? MainView else {return}
        
        self.timerNumber -= 1
        view.setTimerText(to: self.timerNumber)
        
        
        if self.timerNumber == 0 {
            self.timer?.invalidate()
            view.setTimerVisibility(to: false)
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
        
        let _ = view.takeScreenShot()
    }
    
    
    /// Começa um timer
    private func starTimer() -> Void {
        guard let view = self.view as? MainView else {return}
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self, selector: #selector(self.timerAction),
            userInfo: nil,
            repeats: true
        )
        
        self.timerNumber = 3
        view.setTimerText(to: self.timerNumber)
        view.setTimerVisibility(to: true)
        
        self.statusAR = .inProgress
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
                icon: "info.circle", size: 25, weight: .bold, scale: .medium,
                target: self, action: #selector(self.startAction))
        )
    }
}
