//
//  SpecialistModel.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 13.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

class Specialist: NSObject {
    var login: String?
    var specialistId: String?
    
    override init() {}
    
    init(login: String, specialistId: String) {
        self.login = login
        self.specialistId = specialistId
    }
    
    // Функция, возвращающая описание специалиста
    func itemDescribtion() -> String {
        return "специалист с логином: \(login!) и id: \(specialistId!)"
    }
}
