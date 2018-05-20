//
//  ResultTableViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 13.03.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

// Класс, представляющий собой UITableViewController, элементы которого являются своеобразными ссылками на результаты завершенных пользователями тестирования
class ResultTableViewController: UITableViewController, DownloadModelProtocol {
    
    var specialistId: String = String()
    let downloadModel = DownloadModel()
    var results: [Result] = []
    var selectedResult = Result()
    var countedScales: [Scale] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadModel.delegate = self
//        downloadModel.downloadItems(url: "http://localhost:3000/api/resultById/\(specialistId)", mode: "rs")
        downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/resultById/\(specialistId)", mode: "rs")
    }
    
    func itemsDownloaded(items: NSArray) {
        if (items.count != 0) {
            print(items.count)
            results = items as! [Result]
            self.tableView.reloadData()
        } else {
            print("Не удалось найти ни одного результата тетсирования, привязанного к данному специалисту")
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultMenuItemCell", for: indexPath) as! ResultMenuTableViewCell
        cell.nameLabel.text = results[indexPath.row].user!.name!
        cell.dateOfTestingLabel.text = results[indexPath.row].dateOfTesting!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedResult = results[indexPath.row]
        countedScales = selectedResult.convertedTScales!
        performSegue(withIdentifier: "resultTableToResultInterpretationSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ResultInterpretationViewController
        destination.countedScales = countedScales
        destination.result = selectedResult
    }

}
