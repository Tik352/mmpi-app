//
//  SpecialistRegistrationViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 19.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

// Класс, представляющий собой UIViewController, содержащий в себе интерфейс и логику, сопровождающую процесс регистрации нового специалиста в системе
class SpecialistRegistrationViewController: UIViewController, UploadModelProtocol {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var warningLabel: UILabel!
    
    var uploadModel = UploadModel()
    var specialist = Specialist()
    var specialistId: String = String()
    var error = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.text = ""
        uploadModel.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        if checkRegistrationInfo() == true {
            doneButton.isEnabled = false
            uploadModel.uploadSpecialistWithId(login: loginTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func itemsUploaded(items: NSArray) {
        doneButton.isEnabled = true
        if let errorCode = items[0] as? Int {
            if errorCode == 11000 {
                warningLabel.text = "Этот логин уже используется"
                error = true
            }
        }
        if let specialist = items[0] as? Specialist {
            self.specialistId = specialist.specialistId!
            print("Value after itemsUploaded --> \(self.specialistId)")
            error = false
        }
        
        if(error == false) {
            print("Segue perform value -> \(specialistId)")
            performSegue(withIdentifier: "regToRegCompleteSegue", sender: self)
        }
    }
    
    // Функция, проверяющую информацию, введенную пользователем при регистрации 
    func checkRegistrationInfo() -> Bool {
        if (loginTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "") {
            if (loginTextField.text!.split(separator: " ").count) > 1 {
                warningLabel.text = "Пробелы недопустимы в логине"
                return false
            } else {
                if (passwordTextField.text!.count > 5) {
                    if passwordTextField.text!.latinCharactersAndNumbersOnly == true && loginTextField.text!.latinCharactersAndNumbersOnly == true {
                        if (passwordTextField.text == repeatPasswordTextField.text) {
                        return true
                        } else {
                            warningLabel.text = "Введенные пароли не совпадают"
                            return false
                        }
                    } else {
                        warningLabel.text = "Логин и пароль могут содержать только латинские буквы, цифры и знаки подчеркивания"

                        return false
                    }
                } else {
                    warningLabel.text = "Пароль должен содержать хотя бы 6 символов"
                    return false
                }
            }
        } else {
            warningLabel.text = "Не все необходимые поля заполнены"
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RegistrationCompleteViewController
        print("Segue prepare value -> \(specialistId)")
        destination.specialistId = self.specialistId
    }
}

extension String {
    var latinCharactersAndNumbersOnly: Bool {
        return self.range(of: "[^0-9a-zA-Z_]", options: .regularExpression) == nil
    }
}
