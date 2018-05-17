//
//  InstructionsViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 11.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    var sex: String = String()
    var name: String = String()
    var specialistId: String = String()
    var dateOfBirth: String = String()
    var resultId: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "instructionsToTestingSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! mmpiTestingViewController
        destination.sex = self.sex
        destination.dateOfBirth = self.dateOfBirth
        destination.name = self.name
        destination.specialistId = self.specialistId
        destination.resultId = resultId
    }


}
