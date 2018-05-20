//
//  UserModel.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 18.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

// Класс, представляющий собой контейнер для хранения информации о конкретном пользователе (клиенте)
class User: NSObject {
    
    var name: String?
    var sex: String?
    var dateOfBirth: String?
    var specialistId: String?
    
    override init() {}
     
    init(name: String, sex: String, dateOfBirth: String, specialistId: String) {
        self.name = name
        self.sex = sex
        self.dateOfBirth = dateOfBirth
        self.specialistId = specialistId
    }
    // конструктор для загрузки информации о пользователе без id специалиста
    init(name: String, sex: String, dateOfBirth: String) {
        self.name = name
        self.sex = sex
        self.dateOfBirth = dateOfBirth
    }
    // Функция возращающая описание пользователя
    func userDescription() -> String {
        return "\(name!), \(sex!), \(dateOfBirth!)"
    }
}
