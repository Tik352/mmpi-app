//
//  CheckResultViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 13.03.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class CheckResultViewController: UIViewController, DownloadModelProtocol {
    
    @IBOutlet weak var resultIdTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let downloadModel = DownloadModel()
    var result: Result = Result()
//    var countedScales: [Scale] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.text = ""

        downloadModel.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func itemsDownloaded(items: NSArray) {
        print("Items.count ---> \(items.count)")
        if(items.count != 0) {
//            countedScales = items as! [Scale]
            result = items[0] as! Result
            performSegue(withIdentifier: "checkToResultInterpretationSegue", sender: self)
        } else {
            warningLabel.text = "Результат тестирования с указанным id не найден"
        }
    }
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        if (resultIdTextField.text == "") {
            warningLabel.text = "Необходимо ввести ID"
        } else {
//            downloadModel.downloadItems(url: "http://localhost:3000/api/results/\(resultIdTextField.text!)", mode: "r")
            downloadModel.downloadItems(url: "https://lmmpi-server.herokuapp.com/api/results/\(resultIdTextField.text!)", mode: "r")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ResultInterpretationViewController
        destination.result = self.result
        destination.countedScales = self.result.convertedTScales!
    }


}
