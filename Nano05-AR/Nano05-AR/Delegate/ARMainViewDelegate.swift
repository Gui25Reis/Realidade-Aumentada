//
//  ARMainViewDelegate.swift
//  Nano05-AR
//
//  Created by Gui Reis on 01/06/22.
//

import ARKit


class ARMainViewDelegate: NSObject, ARSCNViewDelegate {
    
    /* MARK: - Atributos*/
    
    /// Analise da expressão
    private var analysis = ""
    
    /// Protocolo de comunicação com a View Controller
    private var mainControllerDelegate: MainControllerDelegate?
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Define o protocolo com a  view controller
    public func setProtocol(with delegate: MainControllerDelegate) {
        self.mainControllerDelegate = delegate
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Primeiro contato
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let device = renderer.device {
            let faceMeshGeometry = ARSCNFaceGeometry(device: device)
            let node = SCNNode(geometry: faceMeshGeometry)
            node.geometry?.firstMaterial?.fillMode = .lines
            
            return node
        } else {
            fatalError("No device found")
        }
    }
    
    
    /// O que acontece quando tem uma atualização na câmera
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if
            let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            
            self.expressionAnalysis(with: faceAnchor)
            
            DispatchQueue.main.async {
                self.mainControllerDelegate?.setTextLabel(with: self.analysis)
            }
        }
    }
    
    
    /* MARK: - Outros */
    
    /// Analisa uma determinada expressão
    private func expressionAnalysis(with anchor: ARFaceAnchor) {
        self.analysis = ""
    
        if self.getExpressionValue(with: .cheekPuff, for: anchor) > 0.1 {
            self.analysis += "You're cheeks are puffed!"
        }
        
        if self.getExpressionValue(with: .tongueOut, for: anchor) > 0.1 {
            self.analysis += "Don't stick your tonge out!"
        }
        
        // Bravo
        let eyeLeft = self.getExpressionValue(with: .browDownLeft, for: anchor) > 0.2
        let eyeRight = self.getExpressionValue(with: .browDownRight, for: anchor) > 0.2

        if eyeLeft && eyeRight {
            self.analysis += "Bravooo"
        }
        
        
        // Sorrindo
        let smileLeft = self.getExpressionValue(with: .mouthSmileLeft, for: anchor) > 0.1
        let smileRight = self.getExpressionValue(with: .mouthSmileRight, for: anchor) > 0.1
        let moutchOpen = self.getExpressionValue(with: .jawOpen, for: anchor) > 0.1

        if smileLeft && smileRight && moutchOpen {
            self.analysis += "MUITO FELIZZZZ"
        }
    }
    
    
    /// Pega o valor de uma determinada expressão
    private func getExpressionValue(with expression: ARFaceAnchor.BlendShapeLocation, for anchor: ARFaceAnchor) -> Decimal {
        let expression = anchor.blendShapes[expression]
        
        if let value = expression?.decimalValue {
            return value
        }
        return -1
    }
    
}
