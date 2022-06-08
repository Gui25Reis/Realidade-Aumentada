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
        
        
        let innerUp = self.getExpressionValue(with: .browInnerUp, for: anchor) > 0.1
        let cheekPuff = self.getExpressionValue(with: .cheekPuff, for: anchor) > 0.1
        
        // 😗
        let mouthPucker = self.getExpressionValue(with: .mouthPucker, for: anchor) > 0.3
        
        if mouthPucker && !innerUp {
            self.analysis += "beijinho"
        }
        
        
        // 😛
        let tongueOut = self.getExpressionValue(with: .tongueOut, for: anchor) > 0.3
        if tongueOut{
            self.analysis += "linguinha"
        }
        
        
        // ☹️
        let frownLeft = self.getExpressionValue(with: .mouthFrownLeft, for: anchor) > 0.1
        let frownRight = self.getExpressionValue(with: .mouthFrownRight, for: anchor) > 0.1

        if frownLeft && frownRight && !innerUp {
            self.analysis += "tristinho"
        }
         
        
        // 😃
        let smileLeft = self.getExpressionValue(with: .mouthSmileLeft, for: anchor) > 0.2
        let smileRight = self.getExpressionValue(with: .mouthSmileRight, for: anchor) > 0.2
        let jawOpen = self.getExpressionValue(with: .jawOpen, for: anchor) > 0.2

        if smileLeft && smileRight && jawOpen && !tongueOut {
            self.analysis += "risadinha"
        }
        
        
        // 😏
        let lookInLeft = self.getExpressionValue(with: .eyeLookInLeft, for: anchor) > 0.1
        let lookInRight = self.getExpressionValue(with: .eyeLookInRight, for: anchor) > 0.1

        if smileRight && lookInLeft && lookInRight {
            self.analysis += "safadinho"
        }
        
        
        // 😒
        if lookInLeft && lookInRight && frownLeft && frownRight {
            self.analysis += "rancorozinho"
        }
        
        
        // 😮
        if self.getExpressionValue(with: .jawOpen, for: anchor) > 0.5 {
            self.analysis += "assustadinho"
        }
        
        
        // 🤔
        let outerUpLeft = self.getExpressionValue(with: .browOuterUpLeft, for: anchor) > 0.1
        let outerUpRight = self.getExpressionValue(with: .browOuterUpRight, for: anchor) > 0.1

        if outerUpLeft && outerUpRight && frownLeft && frownRight && !innerUp {
            self.analysis += "pensandinho"
        }
        
        
        // ☺️
        let blinkRight = self.getExpressionValue(with: .eyeBlinkRight, for: anchor) > 0.1
        let blinkLeft = self.getExpressionValue(with: .eyeBlinkLeft, for: anchor) > 0.1
        
        if innerUp && blinkLeft && blinkRight && smileLeft && smileRight {
            self.analysis += "sorrisinho"
        }
        
        
        // 🙄
        let lookUpLeft = self.getExpressionValue(with: .eyeLookUpLeft, for: anchor) > 0.1
        let lookUpRight = self.getExpressionValue(with: .eyeLookUpRight, for: anchor) > 0.1

        if innerUp && lookUpLeft && lookUpRight {
            self.analysis += "bravinho"
        }
        
        
        // 🥺
        if innerUp && frownRight && frownLeft {
            self.analysis += "chateadinho"
        }

        
        // 🤢
        if cheekPuff && innerUp && !mouthPucker {
            self.analysis += "nojentinho"
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
