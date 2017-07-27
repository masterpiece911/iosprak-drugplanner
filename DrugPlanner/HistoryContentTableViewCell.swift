//
//  HistoryContentTableViewCell.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class HistoryContentTableViewCell: UITableViewCell {

    @IBOutlet weak var DateOfTakeLabel: UILabel!
    
    @IBOutlet weak var TimeOfTakeLabel: UILabel!
    
    @IBOutlet weak var DrugNameLabel: UILabel!
    
    @IBOutlet weak var DoseLabel: UILabel!
    
    @IBOutlet weak var DoseUnitLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
