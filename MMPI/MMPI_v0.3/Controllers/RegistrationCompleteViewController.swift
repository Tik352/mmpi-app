//
//  RegistrationCompleteViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 12.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class RegistrationCompleteViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    
    var specialistId: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.text = specialistId

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
