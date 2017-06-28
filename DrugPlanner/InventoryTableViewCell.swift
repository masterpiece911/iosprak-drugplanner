//
//  InventoryTableViewCell.swift
//  DrugPlanner
//
//  Created by Elena Karypidou on 14.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var drugNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
