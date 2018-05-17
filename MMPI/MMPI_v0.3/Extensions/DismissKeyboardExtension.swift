//
//  DismissKeyboardExtension.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 16.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

// Расширение UIViewController, которое позволяет скрывать системную клавиатуру при нажатии на View
extension UIViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
}
