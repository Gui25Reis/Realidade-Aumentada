//
//  UIImage+Resize.swift
//  Nano05-AR
//
//  Created by Gui Reis on 08/06/22.
//

import UIKit


extension UIImage {
    
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

