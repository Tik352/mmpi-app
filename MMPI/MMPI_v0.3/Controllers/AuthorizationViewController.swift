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
        // НЕДОРАБОТАННАЯ функция, осуществляющая проверку введенных данных (на непустоту + обращение к базе данных)
        func loginInformationCheck(id: String, password: String) -> Bool{
            if (id == "") || (password == "") {
                warningLabel.text = "Не вся необходимая информация введена пользователем"
                return false
            }
            return true
        }
        
        let condition = loginInformationCheck(id: idTextField.text!, password: passwordTextField.text!)
        if (condition == true) {
//            downloadModel.downloadItems(url: "http://localhost:3000/api/login/\(idTextField.text!)/\(passwordTextField.text!)", mode: "l")
            downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/login/\(idTextField.text!)/\(passwordTextField.text!)", mode: "l")

        }
        
    }
    
    func itemsDownloaded(items: NSArray) {
        if (items[0] as? String != "") {
            specialistId = items[0] as! String
            performSegue(withIdentifier: "authorizationSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadModel.delegate = self
        
        warningLabel.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "authorizationSegue") {
        let destination = segue.destination as! ResultTableViewController
        destination.specialistId = specialistId
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
