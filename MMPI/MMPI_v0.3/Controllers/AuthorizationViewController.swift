//
//  AuthorizationViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 13.03.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController, DownloadModelProtocol {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIBarButtonItem!
    @IBOutlet weak var warningLabel: UILabel!
    
    var specialistId: String = String()
    var downloadModel = DownloadModel()
    
    @IBAction func enterButtonTouchDown(_ sender: Any) {
        warningLabel.text = ""
        enterButton.isEnabled = false
        func loginInformationCheck(id: String, password: String) -> Bool{
            if (id == "") || (password == "") {
                warningLabel.text = "Не вся необходимая информация введена пользователем"
                return false
            } else {
                if URL(string: "https://mmpi-server.herokuapp.com/api/login/\(idTextField.text!)/\(passwordTextField.text!)") != nil {
                    return true
                } else {
                    warningLabel.text = "Недопустимые символы в поле логин или пароль"
                    return false
                }
            }
        }
        let condition = loginInformationCheck(id: idTextField.text!, password: passwordTextField.text!)
        if (condition == true) {
//            downloadModel.downloadItems(url: "http://localhost:3000/api/login/\(idTextField.text!)/\(passwordTextField.text!)", mode: "l")
            downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/login/\(idTextField.text!)/\(passwordTextField.text!)", mode: "l")
        } else {
            enterButton.isEnabled = true
        }
    }
    
    func itemsDownloaded(items: NSArray) {
        enterButton.isEnabled = true
        if (items.count > 0) {
            specialistId = items[0] as! String
            performSegue(withIdentifier: "authorizationSegue", sender: self)
        } else {
            warningLabel.text = "Пользователь не найден"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadModel.delegate = self
        
        warningLabel.text = ""
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "authorizationSegue") {
        let destination = segue.destination as! ResultTableViewController
        destination.specialistId = specialistId
        }
        self.hideKeyboardWhenTappedAround()
    }
}
