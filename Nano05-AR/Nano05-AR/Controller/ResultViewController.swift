/* Gui Reis & Gabi Namie     -    Created on 07/06/22 */


import UIKit
import ARKit

class ResultViewController: UIViewController {
    
    /* MARK: - Atributos */
    
    /// Emojis selecionados das fotos
    private let photosTaken: [PhotoTaken]
    
    /// Verifica se os emojis estão aparecendo na foto ou não
    private var emojiOnPhoto: Bool = true
    
    /// Protocolo com a controller
    private var mainProtocol: MainControllerDelegate
    
    /// Caso para quando a foto for salva
    private var photoSaved: Bool = false
    
    
    
    /* MARK: - Construtor */
    
    init(photosTaken: [PhotoTaken], delegate: MainControllerDelegate) {
        self.photosTaken = photosTaken
        self.mainProtocol = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func loadView() -> Void {
        super.loadView()
        
        let myView = ResultView(photosTaken: self.photosTaken)
        self.view = myView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        // Bloqueia fechar modal por toque
        self.isModalInPresentation = true
        
        self.configureNavBar()
    }
    

    
    /* MARK: - Ações do Botão */

    /// Ação do botão de cancelar
    @objc func cancelAction() -> Void {
        if self.photoSaved {
            self.closeView()
            return
        }
        
        // Criando alerta
        let alertInfo = AlarmSettings(
            title: "Cancelar fotos",
            description: "Tem certeza de que deseja excluir?",
            cancelText: "Voltar",
            style: .alert
        )
        
        let alert: UIAlertController = self.crateAlert(with: alertInfo)
        
        // Botões do alerta
        let confirm = UIAlertAction(title: "Sair sem salvar", style: .destructive) { _ in
            self.closeView()
        }
        alert.addAction(confirm)
            
        self.present(alert, animated: true)
    }
    
    
    /// Ação do botão de salvar
    @objc func saveAction() -> Void {
        // Cria a imagem
        guard let view = self.view as? ResultView else {return}
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let imagesCaptured = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        // Cria o alerta
        let alertInfo = AlarmSettings(
            title: nil,
            description: nil,
            cancelText: "Voltar",
            style: .actionSheet
        )
        
        let alert = self.crateAlert(with: alertInfo)
        
        // Botões do alerta
        let saveAndLeave = UIAlertAction(title: "Salvar e sair", style: .default) { _ in
            self.saveAndLeaveAction(image: imagesCaptured)
        }
        alert.addAction(saveAndLeave)
        
        
        let share = UIAlertAction(title: "Compartilhar", style: .default) { _ in
            self.shareAction(image: imagesCaptured)
        }
        
        alert.addAction(share)
        self.present(alert, animated: true)
    }
    
    
    /// Salva a imagem no dispositivo e fecha a view
    private func saveAndLeaveAction(image: UIImage) -> Void {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.photoSaved = true
        self.closeView()
    }
    
    
    /// Abre a área de compartilhamento
    private func shareAction(image: UIImage) -> Void {
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem     // Ipad
        
        self.present(vc, animated: true)
    }
    
    
    /// Define e atualiza oos botões do lado direito da navigation
    @objc private func updateRightBarButton() -> Void {
        // Direita
        let emojiImage = self.updateEmojiButton()
        
        let emojiButton = UIBarButtonItem(
            image: emojiImage,
            landscapeImagePhone: emojiImage,
            style: .plain,
            target: self,
            action: #selector(self.updateRightBarButton)
        )
        
        let saveButton = UIBarButtonItem(
            title: "Salvar",
            style: .done,
            target: self,
            action: #selector(self.saveAction)
        )
        
        self.navigationItem.rightBarButtonItems = [saveButton, emojiButton]
    }
    
    
    
    /* MARK: - Configurações */
        
    
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.alpha = 0.5
        
        // Esquerda
        let cancelButton = UIBarButtonItem(
            title: "Sair",
            style: .plain,
            target: self,
            action: #selector(self.cancelAction)
        )
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
        
        
        // Direita
        self.emojiOnPhoto.toggle()
        self.updateRightBarButton()
    }
    
    
    /// Atualiza/Cria os botões da navigation
    private func updateEmojiButton() -> UIImage? {
        self.emojiOnPhoto.toggle()
        
        guard let view = self.view as? ResultView else {return UIImage()}
        
        view.setEmojisVisualization(to: self.emojiOnPhoto)
        
        switch self.emojiOnPhoto {
        case true:
            return UIImage(systemName: "face.smiling")
        case false:
            return UIImage(named: "EmojiDisabled.png")?.resize(to: CGSize(width: 22, height: 22))
        }
    }
    
    
    /// Fecha a  janela
    private func closeView() -> Void {
        self.mainProtocol.updateStatus(to: .notStarted)
        self.dismiss(animated: true)
    }
    
    
    /// Cria um alerta já com o botão de cancelar
    private func crateAlert(with settings: AlarmSettings) -> UIAlertController {
        let alert = UIAlertController(
            title: settings.title,
            message: settings.description,
            preferredStyle: settings.style
        )

        let cancel = UIAlertAction(title: settings.cancelText, style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        return alert
    }
}
