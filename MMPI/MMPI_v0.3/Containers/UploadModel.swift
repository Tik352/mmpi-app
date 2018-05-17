//
//  UploadModel.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 15.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import Foundation

protocol UploadModelProtocol: class {
    func itemsUploaded(items: NSArray)
}

class UploadModel: NSObject, URLSessionDelegate {
    
    weak var delegate: UploadModelProtocol!
    
    // Функция, загружающая информацию о новом пользователе
    func uploadUser(name: String, dateOfBirth: String, sex: String, specialistId: String) {
    
//        let requestUrl = URL(string: "http://mmpitest.tech/api/addUser.php")!
//        let requestUrl = URL(string: "http://localhost:3000/api/register/user")!
        let requestUrl = URL(string: "https://mmpi-server.herokuapp.com/api/register/user")!

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
//        let postParams = "name=" + name + "&sex=" + sex + "&dateOfBirth=" + dateOfBirth + "&specialistId=" + specialistId
        let postParams = "name=\(name)&sex=\(sex)&dateOfBirth=\(dateOfBirth)&specialistId=\(specialistId)"
//        let postParams = "name=" + name + "&sex=" + sex + "&date=" + dateOfBirth + "&spid=" + specialistId
        print(postParams)
        request.httpBody = postParams.data(using: String.Encoding.utf8)
    
        let task = URLSession.shared.dataTask(with: request) {(data, response, error)
            in
            if (error != nil) {
                print("error -> \(error!.localizedDescription)")
            } else {
                self.parseJSONUser(data: data!)
            }
        }
        task.resume()
    }
    
    // Функция, реализующая парсинг информации, полученной от сервера при попытке добавления нового пользователя
    func parseJSONUser(data: Data) {
        var dataJSON = NSDictionary()
        
        do {
            dataJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
            
                if let user: NSDictionary = dataJSON["user"] as? NSDictionary {
                    print(user["name"] as! String, user["dateOfBirth"] as! String, user["sex"] as! String, user["specialistId"] as! String)
                }
        }
        catch {
            print("error -> \(error.localizedDescription)")
        }
        let items = NSMutableArray()
        let specialistId = dataJSON["_id"] as! String
        
        items.add(specialistId)
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsUploaded(items: items)
        })
    }
    
    // Функция, регистрирующая нового специалиста
    func uploadSpecialistWithId(login: String, password: String) {
//        let requestUrl = URL(string: "http://localhost:3000/api/register/specialist")!
        let requestUrl = URL(string: "https://mmpi-server.herokuapp.com/api/register/specialist")!

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postParams = "login=\(login)&password=\(password)"
        print(postParams)
        request.httpBody = postParams.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error)
            in
            if(error != nil) {
                print("error -> \(error!.localizedDescription)")
            } else {
                print("data uploaded")
                self.parseJSONSpecialistResponse(data: data!)
            }
        }
        task.resume()
    }
    
    // Функция, реализующая парсинг информации, полученной от сервера при попытке добавления нового специалиста
    func parseJSONSpecialistResponse(data: Data) {
        
        var jsonResult = NSDictionary()
        let specialist = Specialist()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        } catch let error as NSError {
            print("error -> \(error.localizedDescription)")
        }
        
        let items = NSMutableArray()
        
        if let login = jsonResult["login"] as? String,
            let specialistId = jsonResult["_id"] as? String {
            specialist.login = login
            specialist.specialistId = specialistId
            print("Added \(specialist.itemDescribtion())")
            items.add(specialist)
        } else {
            let errorCode = jsonResult["code"] as! Int
            print("Erorr with code -> \(errorCode)")
            items.add(errorCode)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsUploaded(items: items)
        })
    }
    
    func uploadResult(resultId: String, scales: [Scale], missedQuestionsCount: Int) {
//        let requestUrl = URL(string: "http://localhost:3000/api/result")!
        let requestUrl = URL(string: "https://mmpi-server.herokuapp.com/api/result")!

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var postParams: NSString = "id=\(resultId)&dateOfTesting=\(gettingCurrentDate())&missedQuestionsCount=\(missedQuestionsCount)" as NSString
        var nameOfScalesParams = "&scales="
        var valuesOfScalesParams = "&tValues="
        for i in 0...scales.count - 2 {
            nameOfScalesParams += "\(scales[i].name!)%"
            valuesOfScalesParams += "\(scales[i].TScore!)%"
        }; nameOfScalesParams += "\(scales[scales.count - 1].name!)"; valuesOfScalesParams += "\(scales[scales.count - 1].TScore!)"
        postParams = (postParams as String) + nameOfScalesParams + valuesOfScalesParams as NSString
        print(postParams)
        let escapeAdress = postParams.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(escapeAdress!)
        request.httpBody = escapeAdress!.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error)
            in
            if(error != nil) {
                print("error -> \(error!.localizedDescription)")
            } else {
                self.parseJSONResult(data: data!)
            }
        }
        task.resume()
        
        
    }
    
    func parseJSONResult(data: Data) {
        var jsonResult = NSDictionary()
        let items = NSMutableArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
            if let ok = jsonResult["ok"] as? Int {
                print("Успешно добавлены результаты для \(ok) пользователя")
                items.add(ok)
            }
        } catch {
            print("error -> \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsUploaded(items: items)
        })
        
    }
    
    // Функция, возвращающая текущую дату в формате "dd.MM.yyyy"
    func gettingCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
}


