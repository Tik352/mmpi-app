//
//  ResultModel.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 13.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

// Класс, представляющий собой контейнер для хранения информации о результате конкретного тестирования
class Result: NSObject {
    
    var id: String?
    var user: User?
    var convertedTScales: [Scale]?
    var missedQuestionsCount: Int?
    var dateOfTesting: String?
    
    override init() {}
    
    init(user: User, convertedTScales: [Scale], missedQuestionsCount: Int, dateOfTesting: String, id: String) {
        self.user = user
        self.convertedTScales = convertedTScales
        self.missedQuestionsCount = missedQuestionsCount
        self.dateOfTesting = dateOfTesting
        self.id = id
    }
}
