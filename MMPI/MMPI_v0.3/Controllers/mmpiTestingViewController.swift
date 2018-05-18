//
//  mmpiTestingViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 13.03.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class mmpiTestingViewController: UIViewController, DownloadModelProtocol {
    
    

    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var trueAnswerButton: UIButton!
    @IBOutlet weak var falseAnswerButton: UIButton!
    @IBOutlet weak var idkAnswerButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var waringLabel: UILabel!
    
    var name: String = String()
    var dateOfBirth: String = String()
    var specialistId: String = String()
    var sex: String = String()
    var resultId: String = String()
//    var questionItems: NSArray = NSArray()
    var currentQuestion: QuestionsModel = QuestionsModel()
//    var currentQuestion = QuestionsModel()
    var answers: Array = Array(repeating: 0, count: 566)
    var itemsDownloaded = false
    var sexL: String = String()
    let downloadModel = DownloadModel()
//    var currentQuestionNumber = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressLabel.text = "Вопрос 1/566"
        waringLabel.text = ""
        
        // инициализация объекта класса DownloadModel
//        let downloadModel = DownloadModel()
        downloadModel.delegate = self
        if (sex == "Мужской") {
//            downloadModel.downloadItems(url: "http://mmpitest.tech/Questions_men.php", mode: "q" ) PHP+SQL ----> MONGO+NODE.js
//            downloadModel.downloadItems(url: "http://localhost:3000/api/questions/M", mode: "q")
            sexL = "M"
            downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/questions/\(sexL)/1", mode: "q")

        }
        else {
//            downloadModel.downloadItems(url: "http://mmpitest.tech/Questions_women.php", mode: "q") PHP+SQL ----> MONGO+NODE.JS
//            downloadModel.downloadItems(url: "http://localhost:3000/api/questions/W", mode: "q")
            sexL = "W"
            downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/questions/\(sexL)/1", mode: "q")

        }
    }
    
    // Загрузка вопросов и инициализация переменных
    func itemsDownloaded(items: NSArray) {
        if (items.count > 0) {
            waringLabel.text = ""
            currentQuestion = items[0] as! QuestionsModel
            progressLabel.text = "Вопрос \(currentQuestion.number!)/566"
            currentQuestionLabel.text = currentQuestion.questionText!
            itemsDownloaded = true
            trueAnswerButton.isEnabled = true
            falseAnswerButton.isEnabled = true
            idkAnswerButton.isEnabled = true
        } else {
            waringLabel.text = "Не удалось загрузить вопрос"
        }
    }
    
    //MARK: -  Обработка нажатий пользователя на кнопки выбора ответа
    
    @IBAction func trueButtonTouched(_ sender: Any) {
        trueAnswerButton.isEnabled = false
        falseAnswerButton.isEnabled = false
        idkAnswerButton.isEnabled = false
        if(itemsDownloaded == true) {
            answers[currentQuestion.number! - 1] = 1
            nextQuestion()
        }
    }
    
    @IBAction func falseButtonTouched(_ sender: Any) {
        trueAnswerButton.isEnabled = false
        falseAnswerButton.isEnabled = false
        idkAnswerButton.isEnabled = false
        if(itemsDownloaded == true) {
            answers[currentQuestion.number! - 1] = -1
            nextQuestion()
        }
        
    }
    
    @IBAction func idkButtonTouched(_ sender: Any) {
        trueAnswerButton.isEnabled = false
        falseAnswerButton.isEnabled = false
        idkAnswerButton.isEnabled = false
        if (itemsDownloaded == true) {
          nextQuestion()
        }
    }
    
    //Функция, реализующая переход к следующему вопросу теста
    func nextQuestion() {
        if (currentQuestion.number! < 566) {
            downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/questions/\(sexL)/\(currentQuestion.number! + 1)", mode: "q")
//            progressLabel.text = "Вопрос \(currentQuestion.number!)/\(questionItems.count)"
//            currentQuestionLabel.text = currentQuestion.questionText
        }
        else {
            performSegue(withIdentifier: "testToEndSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TheEndOfTheTestingViewController
        destination.answers = self.answers
        destination.sex = self.sex
        destination.dateOfBirth = self.dateOfBirth
        destination.name = self.name
        destination.specialistId = self.specialistId
        destination.resultId = resultId
    }
    
}

