//
//  DownloadModel.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 11.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

protocol DownloadModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class DownloadModel: NSObject, URLSessionDataDelegate {
    
    weak var delegate: DownloadModelProtocol!
    
    var session = URLSession(configuration: .default)
    
    // Функция, реализующая выгрузку данных с сервера
    func downloadItems(url: String, mode: String) {
        let urlPath = URL(string: url)!
        let task = session.dataTask(with: urlPath) { (data, response, error)
            in
            if error != nil {
                print("error -> \(error!.localizedDescription)")
            }
            else {
//                print("data downloaded")
                if (mode == "q") {
                    self.parseJSONQuestions(data: data!)
                    print("data downloaded")
                }
                else if (mode == "s") {
                    self.parseJSONScales(data: data!)
                    print("data downloaded")
                }
//                else if (mode == "u") {
//                    self.parseJSONUsers(data: data!)
//                }
                else if (mode == "l") {
                    self.parseJSONSpecialist(data: data!)
                    print("data downloaded")
                }
                else if (mode == "r") {
                    self.parseJSONResult(data: data!)
                    print("data downloaded")
                }
                else if (mode == "rs") {
                    self.parseJSONResultBySpecialistId(data: data!)
                    print("data downloaded")
                }
                else if (mode == "sd") {
                    self.parseJSONScalesDescribtions(data: data!)
                    print("data downloaded")
                }
            }
        }
        task.resume()
    }
    
    // Функция, реализующая парсинг полученного описания шкалы
    func parseJSONScalesDescribtions(data: Data) {
        var jsonResult = NSDictionary()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
        }
        catch let error as NSError {
            print("error --> \(error.localizedDescription)")
        }
        
        let items = NSMutableArray()
        
        if let name = jsonResult["interpretationName"] as? String,
        let text = jsonResult["interpretationText"] as? String,
            let desc = jsonResult["interpretationDescribtion"] as? String {
            let scaleDescribtion = ScaleDescribtion(interpretationName: name, interpretationText: text, interpretationDescribtion: desc)
            items.add(scaleDescribtion)
        }
        DispatchQueue.main.async {
            self.delegate.itemsDownloaded(items: items)
        }
    }
    
    // Функция, реализующая парсинг результатов, полученных по id специалиста
    func parseJSONResultBySpecialistId(data: Data) {
        var jsonResult = NSArray()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray
        }
        catch {
            print("error -> \(error.localizedDescription)")
        }
        let results = NSMutableArray()
        
        if jsonResult.count != 0 {
            for i in 0...(jsonResult.count - 1) {
                let currentResult = jsonResult[i] as! NSDictionary
                if let user = currentResult["user"] as? NSDictionary,
                    let dateOfTesting = currentResult["dateOfTesting"] as? String,
                    let id = currentResult["_id"] as? String,
                    let missedQuestionsCount = currentResult["missedQuestionsCount"] as? Int,
                    let scales = currentResult["convertedTScales"] as? NSArray  {
                    var result = Result()
                    print("Setuping info for result")
                    var currentUser = User()
                    var countedScales: [Scale] = []
                    
                    if let name = user["name"] as? String,
                    let dateOfBirth = user["dateOfBirth"] as? String,
                        let sex = user["sex"] as? String{
                        print("Setuping info for new user")
                        currentUser = User(name: name, sex: sex, dateOfBirth: dateOfBirth)
                    }
                    
                    if(scales.count != 0) {
                        for i in 0...(scales.count - 1) {
                            let scale = Scale()
                            let currentScale = scales[i] as! NSDictionary
                            if let scaleName = currentScale["name"] as? String,
                                let tValue = currentScale["tValue"] as? Int {
                                scale.TScore = tValue
                                scale.name = scaleName
                            }
                            countedScales.append(scale)
                        }
                    }
                    print(currentUser.userDescription())
                    result = Result(user: currentUser, convertedTScales: countedScales, missedQuestionsCount: missedQuestionsCount, dateOfTesting: dateOfTesting, id: id)
                    results.add(result)
                }
            }
        }
        DispatchQueue.main.async {
            self.delegate.itemsDownloaded(items: results)
        }
    }
    
    // Функция, производящая парсинг запрошенного результата
    func parseJSONResult(data: Data) {
        var jsonResult = NSDictionary()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
        }
        catch {
            print("error -> \(error.localizedDescription)")
        }
        let items = NSMutableArray()
        var result = Result()
        let currentResult = jsonResult
        if let user = currentResult["user"] as? NSDictionary,
        let dateOfTesting = currentResult["dateOfTesting"] as? String,
        let id = currentResult["_id"] as? String,
        let missedQuestionsCount = currentResult["missedQuestionsCount"] as? Int,
        let scales = currentResult["convertedTScales"] as? NSArray {
            let currentUser = User()
            var countedScales: [Scale] = []
            if let name = user["name"] as? String,
                let dateOfBirth = user["dateOfBirth"] as? String{
                currentUser.name = name
                currentUser.dateOfBirth = dateOfBirth
            }
            if(scales.count != 0) {
                for i in 0...(scales.count - 1) {
                    var scale = Scale()
                    let currentScale = scales[i] as! NSDictionary
                    if let scaleName = currentScale["name"] as? String,
                        let tValue = currentScale["tValue"] as? Int {
                        scale = Scale(name: scaleName, TScore: tValue)
                        print("\(scaleName) ---> \(tValue)")
                    }
                    countedScales.append(scale)
                }
            }
            result = Result(user: currentUser, convertedTScales: countedScales, missedQuestionsCount: missedQuestionsCount, dateOfTesting: dateOfTesting, id: id)
        }
        items.add(result)
        DispatchQueue.main.async {
            self.delegate.itemsDownloaded(items: items)
        }
    }
    
    // Функция, реализующая парсинг ответа от сервера при попытки авторизации специалиста
    func parseJSONSpecialist(data: Data) {
        var jsonResult = NSDictionary()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }
        catch let error as NSError {
            print("error -> \(error.localizedDescription)")
        }
        let items = NSMutableArray()
        if let specialistId = jsonResult["_id"] as? String {
            print("Авторизация прошла успешно для специалиста с id: \(specialistId)")
            items.add(specialistId)
        }
        DispatchQueue.main.async {
            self.delegate.itemsDownloaded(items: items)
        }
    }
    
    
    // Функция, реализующая парсинг полученной информации в формате JSON
    func parseJSONQuestions(data: Data) {
        var jsonResult = NSDictionary()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }
        catch let error as NSError {
            print("error -> \(error.localizedDescription)")
        }
//         jsonElement = NSDictionary()
        let questions = NSMutableArray()
//        for i in 0..<jsonResult.count {
//            jsonElement = jsonResult as! NSDictionary
            let question = QuestionsModel()
            
            if let number = jsonResult["number"] as? String,
                let questionText = jsonResult["text"] as? String
            {
                question.number = Int(number)
                question.questionText = questionText
                // Вывод представления загруженной информации в консоль
                print(question.itemDescription())
                
            }
            questions.add(question)
//        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: questions)
        })
    }
    
    func parseJSONScales(data: Data) {
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }
        catch let error as NSError
        {
            print("error -> \(error.localizedDescription)")
        }
        var jsonElement = NSDictionary()
        let scales = NSMutableArray()
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let scale = Scale()
            if let name = jsonElement["name"] as? String,
                let tQuestionsIndexes = jsonElement["tQuestionIndexes"] as? String,
                let fQuestionsIndexes = jsonElement["fQuestionIndexes"] as? String,
                let M = jsonElement["M"] as? String,
                let Sigma = jsonElement["Sigma"] as? String
                {
                    scale.name = name
                    scale.tQuestionsIndexes = tQuestionsIndexes
                    scale.fQuestionsIndexes = fQuestionsIndexes
                    scale.M = Double(M)
                    scale.Sigma = Double(Sigma)
                    scales.add(scale)
                    print("Добавлена шкала с именем: \(name)")
            }
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: scales)
        })
    }
}
