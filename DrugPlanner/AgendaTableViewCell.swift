//
//  AgendaTableViewCell.swift
//  DrugPlanner
//
//  Created by admin on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class AgendaTableViewCell: UITableViewCell {
    
    @IBOutlet var drugImage : UIImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var hintLabel : UILabel?
    
    var scheduleID : Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
