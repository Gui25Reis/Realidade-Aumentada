//
//  ARMainViewDelegate.swift
//  Nano05-AR
//
//  Created by Gui Reis on 01/06/22.
//

import ARKit


class ARMainViewDelegate: NSObject, ARSessionDelegate {
    
    /* MARK: - Atributos*/
    
    /// Protocolo de comunicação com a View Controller
    private var mainControllerDelegate: MainControllerDelegate?
    
    
    private let analysis = ExpressionAnalysis()
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Define o protocolo com a view controller
    public func setProtocol(with delegate: MainControllerDelegate) {
        self.mainControllerDelegate = delegate
    }
    
    
    
    /* MARK: - Delegate */
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if self.mainControllerDelegate?.getStatus() != .takingPhoto {
            var validation: Emojis? = nil
            
            for anchor in anchors {
                validation = self.analysis.getExpressionAnalysis(with: anchor)
                if let validation = validation {
                    self.mainControllerDelegate?.addEmojiRecognized(with: validation)
                }
            }
            
            if validation != nil {
                self.mainControllerDelegate?.startTimer()
            }
        }
    }
}
