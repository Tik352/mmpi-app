//
//  SpecialistRegistrationViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 19.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

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
        
        // MARK: - Testing
        loginTextField.text = "Specialist Registration"
        passwordTextField.text = "123456"
        repeatPasswordTextField.text = "123456"
        
//        let uploadModel = UploadModel()
        uploadModel.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        doneButton.isEnabled = false
        uploadModel.uploadSpecialistWithId(login: loginTextField.text!, password: passwordTextField.text!)
    }
    
    func itemsUploaded(items: NSArray) {
        doneButton.isEnabled = true
        if let errorCode = items[0] as? Int {
            if errorCode == 11000 {
                warningLabel.text = "This login is already used"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RegistrationCompleteViewController
        print("Segue prepare value -> \(specialistId)")
        destination.specialistId = self.specialistId
    }
}
