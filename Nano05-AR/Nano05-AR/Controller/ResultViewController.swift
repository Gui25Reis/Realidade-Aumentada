/* Gui Reis & Gabi Namie     -    Created on 07/06/22 */


import UIKit
import ARKit

class ResultViewController: UIViewController {
    
    /* MARK: - Atributos */
    
    /// Emojis selecionados das fotos
    private let photosTaken: [PhotoTaken]
            
    
    
    /* MARK: - Construtor */
    
    init(photosTaken: [PhotoTaken]) {
        self.photosTaken = photosTaken

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
        
        guard let view = self.view as? ResultView else {
            return
        }
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) -> Void {
        super.viewWillDisappear(animated)
        
        if let view = self.view as? ResultView {
        }
    }
    
    
    
    /* MARK: - Açoes do Botão */
    
    @objc func shareAction() -> Void {
        guard let view = self.view as? ResultView else {return}
    }
}



