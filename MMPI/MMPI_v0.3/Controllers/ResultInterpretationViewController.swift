//
//  ResultInterpretationViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 16.04.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

// Класс, представляющий собой UIViewController, содержащий в себе интерфейс и логику для визуализации информации о пройденном тестировании, включающей в себя в список подсчитанных шкал
class ResultInterpretationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableItems: UITableView!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    
    var countedScales: [Scale] = []
    var result: Result = Result()
    var scaleName: String = String()
    var scaleValue: Int = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableItems.delegate = self
        tableItems.dataSource = self
    }
    
    // MARK: - UITableViewCell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countedScales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scale = countedScales[indexPath.row]
        let cell = tableItems.dequeueReusableCell(withIdentifier: "ResultScaleItemCell") as! ResultScaleTableViewCell
        cell.scaleNameLabel.text = scale.name!
        cell.scaleValueLabel.text = String(scale.TScore!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.scaleName = countedScales[indexPath.row].name!
        self.scaleValue = countedScales[indexPath.row].TScore!
        performSegue(withIdentifier: "ResultInterpretationToScaleDescribtion", sender: self)
    }
    
    @IBAction func infoButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "resultToInfoSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ResultInterpretationToScaleDescribtion") {
            let destination = segue.destination as! ScaleDescribtionViewController
            destination.scaleName = self.scaleName
            destination.scaleValue = self.scaleValue
        } else if (segue.identifier == "resultToInfoSegue") {
            let destination = segue.destination as! ResultInfoViewController
            destination.result = self.result
        }
        
    }
}
