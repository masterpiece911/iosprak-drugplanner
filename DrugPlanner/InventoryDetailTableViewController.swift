//
//  InventoryDetailTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 28.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class InventoryDetailTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var doseField: UITextField!
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var expiryDatePicker: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    var item : InventoryItem = InventoryItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        nameField.text = item.InventoryItemName
        amountField.text = String(item.InventoryItemAmount)
        doseField.text = String(item.InventoryItemDose)
        expiryDatePicker.text = formatter.string(from: item.InventoryItemExpiryDate)
        notesField.text = item.InventoryItemNotes
        
        let descriptions = getDrugTypeDescriptions(for: item.InventoryItemType)
        
        amountLabel.text = descriptions["amountUnit"]!
        doseLabel.text = descriptions["doseUnit"]!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
