//
//  TextFieldExtension.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 12.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

// Расширение, предоставляющие доступ к редактированию визуальных границ UITextField

import UIKit

extension UITextField {
    
    // Радиус скругления границы объека UIView
    @IBInspectable
    var cornerRadius: CGFloat {
        get {return layer.cornerRadius}
        set {layer.cornerRadius = newValue}
    }
    
    // Толщина границ объекта UIView
    @IBInspectable
    var borderWidth: CGFloat {
        get {return layer.borderWidth}
        set {layer.borderWidth = newValue}
    }
    
    // Цвет границ объека UIView
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            }
            else {
                layer.borderColor = nil
            }
        }
    }
}
