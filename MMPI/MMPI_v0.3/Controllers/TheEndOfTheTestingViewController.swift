//
//  TheEndOfTheTestingViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 11.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class TheEndOfTheTestingViewController: UIViewController, DownloadModelProtocol, UploadModelProtocol {
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var missedQuestionsCountTextField: UITextField!
    @IBOutlet weak var returnToMenuButton: UIButton!
    
    var uploadModel = UploadModel()
    
    var answers: Array<Int> = Array<Int>()
    var dateOfBirth: String = String()
    var sex: String = String()
    var specialistId: String = String()
    var name: String = String()
    var scales: NSArray = NSArray()
    var countedScales: [Scale] = []
    var resultId: String = String()
    var route = ""
    
    
    func itemsDownloaded(items: NSArray) {
        scales = items
        var KScaleValue: Int = Int()
        for i in 0...(scales.count - 1) {
            let currentScale = scales[i] as! Scale
            countedScales.append(Scale(name: currentScale.name!, tQuestionsIndexes: currentScale.tQuestionsIndexes!, fQuestionsIndexes: currentScale.fQuestionsIndexes!, M: currentScale.M!, Sigma: currentScale.Sigma!))
            countedScales[i].scaleValueCalculating(answers: answers)
            print(countedScales[i].scaleValue!)
        }
        // Поиск шкалы коррекции
        for i in 0...(countedScales.count - 1) {
            let currentScale = countedScales[i]
            if (currentScale.name! == "KScale") {
                KScaleValue = currentScale.scaleValue!
                print(KScaleValue)
                break
            }
        }
        
        for i in 0...(countedScales.count - 1) {
            countedScales[i].correctScale(KScaleValue: KScaleValue)
        }
        
        for i in 0...(countedScales.count - 1) {
            countedScales[i].convertToTScores()
        }
        
        
//        uploadModel.uploadResult(resultId: resultId, scales: countedScales, missedQuestionsCount: missedQuestionsCount())
    }
    
    func itemsUploaded(items: NSArray) {
        nextButton.isEnabled = true
        returnToMenuButton.isEnabled = true
        print("yo")
        if (items[0] as? Int != nil) {
//            let result = Result(user: User(name: name, sex: sex, dateOfBirth: dateOfBirth, specialistId: specialistId), convertedTScales: countedScales, missedQuestionsCount: missedQuestionsCount(), dateOfTesting: gettingCurrentDate(), id: resultId)
            if route == "toMenu" {
                performSegue(withIdentifier: "theEndToMenuSegue", sender: self)
            } else {
              performSegue(withIdentifier: "endToResultInterpretationSegue", sender: self)
            }
        }
        
    }

    @IBAction func nextButtonTouched(_ sender: Any) {
        nextButton.isEnabled = false
        uploadModel.uploadResult(resultId: resultId, scales: countedScales, missedQuestionsCount: missedQuestionsCount())
    }
    
    
    @IBAction func returnToMenuButtonTouched(_ sender: Any) {
        returnToMenuButton.isEnabled = false
        route = "toMenu"
        uploadModel.uploadResult(resultId: resultId, scales: countedScales, missedQuestionsCount: missedQuestionsCount())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missedQuestionsCountTextField.text = String(missedQuestionsCount())
        
        let downloadModel = DownloadModel()
        downloadModel.delegate = self
//        downloadModel.downloadItems(url: "http://mmpitest.tech/Scales.php", mode: "s")
        if(sex == "Мужской") {
//            downloadModel.downloadItems(url: "http://localhost:3000/api/scales/M", mode: "s")
            downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/scales/M", mode: "s")

        } else {
//            downloadModel.downloadItems(url: "http://localhost:3000/api/scales/W", mode: "s")
            downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/scales/W", mode: "s")

        }
        
        uploadModel.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "endToResultInterpretationSegue") {
            let destination = segue.destination as! ResultInterpretationViewController
            destination.countedScales = self.countedScales
            let result = Result(user: User(name: name, sex: sex, dateOfBirth: dateOfBirth, specialistId: specialistId), convertedTScales: countedScales, missedQuestionsCount: missedQuestionsCount(), dateOfTesting: gettingCurrentDate(), id: resultId)
            destination.result = result
        }
    }
    
    func missedQuestionsCount() -> Int {
        var count = 0
        for i in 0...(answers.count-1) {
            if answers[i] == 0
            {count += 1}
        }
        return count
    }
    
    func gettingCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
