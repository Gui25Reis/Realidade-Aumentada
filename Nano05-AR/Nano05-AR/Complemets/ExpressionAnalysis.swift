//
//  ExpressionAnalysis.swift
//  Nano05-AR
//
//  Created by Gui Reis on 08/06/22.
//
import ARKit


class ExpressionAnalysis {
    
    /* MARK: - Métodos */
    
    
    /// Compara se a expressão é o emoji em si
    private func compareExpression(to emoji: Emojis, with anchor: ARFaceAnchor) -> Bool {
        let innerUp = self.getExpressionValue(with: .browInnerUp, for: anchor) > 0.1
        let cheekPuff = self.getExpressionValue(with: .cheekPuff, for: anchor) > 0.1
        
        let frownLeft = self.getExpressionValue(with: .mouthFrownLeft, for: anchor) > 0.1
        let frownRight = self.getExpressionValue(with: .mouthFrownRight, for: anchor) > 0.1
        
        let tongueOut = self.getExpressionValue(with: .tongueOut, for: anchor) > 0.2
        
        let eyeLeft = self.getExpressionValue(with: .browDownLeft, for: anchor) > 0.4
        let eyeRight = self.getExpressionValue(with: .browDownRight, for: anchor) > 0.4
        let eyeSquinLeft = self.getExpressionValue(with: .eyeSquintLeft, for: anchor) > 0.1
        let eyeSquinRight = self.getExpressionValue(with: .eyeSquintRight, for: anchor) > 0.1
        let brownLeft = self.getExpressionValue(with: .browOuterUpRight, for: anchor) > 0.1
        let lookDownLeft = self.getExpressionValue(with: .eyeLookDownLeft, for: anchor) > 0.4
        let lookDownRight = self.getExpressionValue(with: .eyeLookDownRight, for: anchor) > 0.4
        
        let smileLeft = self.getExpressionValue(with: .mouthSmileLeft, for: anchor) > 0.4
        let smileRight = self.getExpressionValue(with: .mouthSmileRight, for: anchor) > 0.4
        let mouthClose = self.getExpressionValue(with: .mouthClose, for: anchor) > 0.1
        let jawOpen = self.getExpressionValue(with: .jawOpen, for: anchor) > 0.1
        
        let blinkRight = self.getExpressionValue(with: .eyeBlinkRight, for: anchor) > 0.2
        let blinkLeft = self.getExpressionValue(with: .eyeBlinkLeft, for: anchor) > 0.2
        
        let mouthPucker = self.getExpressionValue(with: .mouthPucker, for: anchor) > 0.4
        let mouthPucker2 = self.getExpressionValue(with: .mouthPucker, for: anchor) < 0.7
        
        let smileLeft2 = self.getExpressionValue(with: .mouthSmileLeft, for: anchor)
        
        
        //let tongueOut2 = self.getExpressionValue(with: .tongueOut, for: anchor) < 0.3
        
        switch emoji {
        case .dormindinho:
            return eyeSquinLeft && eyeSquinRight && mouthClose
        case .linguinha:
            return tongueOut
        case .beijinho:
            return mouthPucker && !jawOpen && !cheekPuff
        case .baguncadinho:
            return mouthClose && brownLeft && !jawOpen && !tongueOut
        case .contentizinho:
            return smileLeft && smileRight && jawOpen && !tongueOut
        case .surpresinho:
            return !tongueOut && !smileLeft && !smileRight && !(eyeLeft && eyeRight) &&
            self.getExpressionValue(with: .jawOpen, for: anchor) > 0.5
        case .boiolinha:
            return innerUp && blinkLeft && blinkRight && smileLeft && smileRight && !jawOpen && !(eyeLeft && eyeRight)
        case .dozinha:
            return innerUp && frownRight && frownLeft && !jawOpen && mouthPucker2 && !(eyeLeft && eyeRight)
        case .segredinho:
            return lookDownLeft && lookDownRight && mouthClose
        case .safadinho:
            return !smileRight && smileLeft2 > 0.24 && smileLeft2 < 4 && !jawOpen
        case .diabinho:
            return eyeLeft && eyeRight && !tongueOut &&
            (innerUp && blinkLeft && blinkRight && smileLeft && smileRight && !jawOpen)
        case .bravinho:
            return cheekPuff && innerUp && !mouthPucker
        }
        
        
    }
    
    
    /// Analisa uma determinada expressão
    public func getExpressionAnalysis(with anchor: ARAnchor) -> Emojis? {
        for emoji in MainViewController.emojisSelected {
            let faceAnchor = ARFaceAnchor(anchor: anchor)
            if self.compareExpression(to: emoji, with: faceAnchor) {
                return emoji
            }
        }
        return nil
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
