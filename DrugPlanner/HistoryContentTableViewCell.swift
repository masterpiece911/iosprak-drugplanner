//
//  HistoryContentTableViewCell.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class HistoryContentTableViewCell: UITableViewCell {

    @IBOutlet weak var dateOfIntakeLabel: UILabel!
    
    @IBOutlet weak var drugNameLabel: UILabel!
    
    @IBOutlet weak var doseLabel: UILabel!
    
    @IBOutlet weak var takeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
