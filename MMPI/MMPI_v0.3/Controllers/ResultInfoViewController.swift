//
//  ResultInfoViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 16.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class ResultInfoViewController: UIViewController {
    
    var result: Result = Result()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var dateOfTestingTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var missedQuestionsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.text = result.id!
        dateOfTestingTextField.text = result.dateOfTesting!
        nameTextField.text = result.user!.name!
        dateOfBirthTextField.text = result.user!.dateOfBirth!
        missedQuestionsTextField.text = String( result.missedQuestionsCount!)
    }
}
