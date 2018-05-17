//
//  ScaleDescribtion.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 16.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

class ScaleDescribtion: NSObject {
    
    var interpretationName: String?
    var interpretationText: String?
    var interpretationDescribtion: String?
    
    override init() {}
    
    init(interpretationName name: String, interpretationText text: String, interpretationDescribtion descr: String) {
        self.interpretationName = name
        self.interpretationText = text
        self.interpretationDescribtion = descr
    }
}
