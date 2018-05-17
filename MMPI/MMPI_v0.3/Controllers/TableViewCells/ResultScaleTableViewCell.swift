//
//  ResultScaleTableViewCell.swift
//  MMPI_v0.3
//
//  Created by Алексей Лямзин on 15.05.2018.
//  Copyright © 2018 National Research University Higher School of Economics. All rights reserved.
//

import UIKit

class ResultScaleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var scaleNameLabel: UILabel!
    @IBOutlet weak var scaleValueLabel: UILabel!
    
    // created from Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
