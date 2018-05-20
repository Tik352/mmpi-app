//
//  RegistrationCompleteViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 12.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

// Класс, представляющий собой UIViewController, содержащий в себе информацию о только что зарегистрированном специалисте, а также дальнейшие инструкции по использованию приложения
class RegistrationCompleteViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    
    var specialistId: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.text = specialistId
    }
}
