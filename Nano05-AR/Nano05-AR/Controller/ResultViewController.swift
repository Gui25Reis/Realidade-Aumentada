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
        
        self.isModalInPresentation = true
        self.configureNavBar()
        
        // guard let view = self.view as? ResultView else {return}
    }
    

    
    /* MARK: - Ações do Botão */

    /// Ação do botão de cancelar
    @objc func cancelAction() -> Void {
        // Criando alerta
        
        if self.photoSaved {
            self.closeView()
            return
        }
        
        let alert = UIAlertController(
            title: "Cancelar fotos",
            message: "Tem certeza de que deseja excluir?",
            preferredStyle: .actionSheet
        )
        
        // Botões do alerta
        let confirm = UIAlertAction(title: "Sair sem salvar", style: .destructive) { _ in
            self.closeView()
        }
        alert.addAction(confirm)
        
        let cancel = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        
        self.present(alert, animated: true)
    }
    
    
    /// Ação do botão de salvar
    @objc func saveAction() -> Void {
        guard let view = self.view as? ResultView else {return}
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.photoSaved = true
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
}
