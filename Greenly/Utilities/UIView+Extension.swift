//
//  UIView+Extension.swift
//  Greenly
//
//  Created by BP-36-208-19 on 28/12/2024.
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
