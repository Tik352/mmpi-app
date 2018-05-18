//
//  ScaleDescribtionViewController.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 15.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class ScaleDescribtionViewController: UIViewController, DownloadModelProtocol {
    
    @IBOutlet weak var scaleTitleLabel: UILabel!
    @IBOutlet weak var scaleValueLabel: UITextField!
    @IBOutlet weak var scaleDescribtionTextView: UITextView!
    
    var scaleName: String = String()
    var scaleValue: Int = Int()
    var scaleDescribtion: ScaleDescribtion = ScaleDescribtion()
    var downloadModel = DownloadModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let labelName = view.viewWithTag(1) as! UILabel
//        let labelValue = view.viewWithTag(2) as! UILabel
        
//        labelName.text = scaleName
//        labelValue.text = String(scaleValue)
        // Do any additional setup after loading the view.
        downloadModel.delegate = self
//        downloadModel.downloadItems(url: "http://localhost:3000/api/scalesDescribtion/\(scaleName)", mode: "sd")
        downloadModel.downloadItems(url: "https://mmpi-server.herokuapp.com/api/scalesDescribtion/\(scaleName)", mode: "sd")

    }
    
    func itemsDownloaded(items: NSArray) {
        if (items.count != 0) {
            var describtion: String = "Краткое описание шкалы: "
            scaleDescribtion = items[0] as! ScaleDescribtion
            scaleTitleLabel.text = scaleDescribtion.interpretationName!
            scaleValueLabel.text = String(scaleValue)
            let shortDescribtion = scaleDescribtion.interpretationDescribtion!
            describtion += "\(shortDescribtion)\nВозможные показатели:"
            let descriptionsCases = scaleDescribtion.interpretationText!.split(separator: "%")
            for descr in descriptionsCases {
                describtion += "\n\(descr)"
            }
            scaleDescribtionTextView.text = describtion
        }
        else {
            scaleDescribtionTextView.text = "Не удалось загрузить описание"
        }
        
    }

}
