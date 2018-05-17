//
//  QuestionsModel.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 11.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

// Класс, представляющий контейнер, для хранения информации о задаваемом вопросе
class QuestionsModel: NSObject {
    
    var number: Int?
    var questionText: String?
    
    override init() {}
    
    init(number: Int, questionText: String) {
        self.number = number
        self.questionText = questionText
    }
    
    // Функция, возвращающая представление конкретного вопроса в формате [номер: текст]
    func itemDescription() -> String {
        return "\(number!): \(questionText!)"
    }
}
