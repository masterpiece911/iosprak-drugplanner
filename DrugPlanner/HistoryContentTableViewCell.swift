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
    
    @IBOutlet weak var historyDetailCell: UIView!
    @IBOutlet weak var historyEditHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var takenSwitch: UISwitch!
    @IBOutlet weak var historyNoteTextField: UITextField!
    
    var historyitem : HistoryItem?
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.historyEditHeightConstraint.constant = 0.0
                
            } else {
                self.historyEditHeightConstraint.constant = 128.0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
