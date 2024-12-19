//
//  UIView+Extension.swift
//  MyProject
//
//  Created on 10/12/24.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var maskedCorners: CACornerMask {
        get { return layer.maskedCorners}
        set { layer.maskedCorners = newValue}
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius}
        set { layer.cornerRadius = newValue}
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {return layer.borderWidth}
        set {
            layer.borderWidth = newValue
        }
    }
}
