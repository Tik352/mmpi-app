//
//  ScaleModel.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 15.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

// Класс, представляющий контейнер для представления конкретной шкалы
class Scale: NSObject {
    
    var name: String?
    var tQuestionsIndexes: String?
    var fQuestionsIndexes: String?
    var scaleValue: Int? // сырые баллы
    var M: Double?
    var Sigma: Double?
    var TScore: Int? // Т-баллы
    
    override init() {}
    
    
    init(name: String, tQuestionsIndexes: String, fQuestionsIndexes: String, M: Double, Sigma: Double) {
        self.name = name
        self.tQuestionsIndexes = tQuestionsIndexes
        self.fQuestionsIndexes = fQuestionsIndexes
        self.M = M
        self.Sigma = Sigma
    }
    
    init(name: String, TScore: Int) {
        self.name = name
        self.TScore = TScore
    }
    
    // Фукнция, вычисляющая значение шкалы по индексам "верных" и "неверных" вопросов в сырых баллах
    func scaleValueCalculating(answers: [Int]){
        var sum = 0 // в переменной записано подсчитанная сумма "сырых" баллов
        let tArr = tQuestionsIndexes!.split(separator: ","),
        fArr = fQuestionsIndexes!.split(separator: ",")
        for index in tArr {
            // удаляем пробелы перед индексами
            let clearIndex = index.trimmingCharacters(in: .whitespaces)
            if answers[Int(clearIndex)!] == 1 {
                sum += 1
            }
        }
        for index in fArr {
            // удаляем пробелы перед индексами
            let clearIndex = index.trimmingCharacters(in: .whitespaces)
            if answers[Int(clearIndex)!] == -1 {
                sum += 1
            }
        }
        scaleValue = sum
        if(name == "KScale") {
            print("KScale value ---> \(scaleValue!)")
        }
    }
    
    // Функция, переводящая значения шкалы из "сырых" баллов в Т-баллы
    func convertToTScores() {
        TScore = Int(50.0 + 10.0 * (Double(scaleValue!) - M!) / Sigma!)
    }
    
    // Функция, выполняющая коррекцию шкалы по значению заданной шкале коррекции (KScale)
    func correctScale(KScaleValue: Int) {
        if name! == "HsScale" {
            scaleValue = scaleValue! + Int(Double(KScaleValue) * 0.5)
        }
        else if name! == "PdScale" {
            scaleValue = scaleValue! + Int(Double(KScaleValue) * 0.4)
        }
        else if name! == "MaScale" {
            scaleValue = scaleValue! + Int(Double(KScaleValue) * 0.2)
        }
        else {
            scaleValue = scaleValue! + KScaleValue
        }
    }
}
