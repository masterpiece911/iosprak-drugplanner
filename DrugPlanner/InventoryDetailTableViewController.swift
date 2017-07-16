//
//  InventoryDetailTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 28.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class InventoryDetailTableViewController: UITableViewController {


    
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var amountDetail: UILabel!
    @IBOutlet weak var amountDetailLabel: UILabel!
    @IBOutlet weak var expiryDateDetail: UILabel!
    @IBOutlet weak var doseDetail: UILabel!
    @IBOutlet weak var doseDetailLabel: UILabel!
    @IBOutlet weak var notesDetail: UILabel!

    
    
    let datePicker = UIDatePicker()

    let cancelAlert = UIAlertController(title: "Confirm Cancel?", message: "You have unsaved changes.", preferredStyle: .alert)
    let deleteAlert = UIAlertController(title: "Confirm Delete?", message: "This action can not be undone.", preferredStyle: .alert)
    let editAlert   = UIAlertController(title: "Incomplete Information", message: "Please fill out all fields before proceeding.", preferredStyle: .alert)
    
    var expiryDate : Date?
    
    var item : InventoryItem!
    
    let dateF : DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // CONFIGURE DATE FORMATTER
        dateF.dateStyle = .medium
        dateF.timeStyle = .none
        
        // SET FIELDS TO INVENTORY ITEM VALUES
        nameDetail.text = item.InventoryItemName
        amountDetail.text = String(item.InventoryItemAmount)
        doseDetail.text = String(item.InventoryItemDose)
        expiryDateDetail.text = dateF.string(from: item.InventoryItemExpiryDate)
        notesDetail.text = item.InventoryItemNotes

        // GET DESCRIPTIONS FOR INVENTORY ITEM TYPE
        let descriptions = getDrugTypeDescriptions(for: item.InventoryItemType)
        
        amountDetailLabel.text = descriptions["amountUnit"]!
        doseDetailLabel.text = descriptions["doseUnit"]!
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.ITEM_UPDATE.appending(item.InventoryItemKey)), object: nil, queue: nil, using: inventoryItemDidChange)
        
        Inventory.instance.listenToChanges(in: self.item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        Inventory.instance.stopListening(to: self.item)
        
        if(segue.identifier == "InventoryEdit") {
            let selectedItem = item
            if let destination = segue.destination as? UINavigationController {
                if let topDestination = destination.topViewController as? InventoryEditController{
                    topDestination.item = selectedItem
                }
            }
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelInventoryItemEdit(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func editInventoryItem(segue: UIStoryboardSegue) {
        
        if let inventoryEditController = segue.source as? InventoryEditController {
            
            Inventory.instance.edit(inventory: inventoryEditController.item)
            
        }
        
    }
    
    func inventoryItemDidChange(notification: Notification) {
        
        self.item = Inventory.instance.items?.getItem(with: self.item.InventoryItemKey)
        
        nameDetail.text = item.InventoryItemName
        amountDetail.text = String(item.InventoryItemAmount)
        doseDetail.text = String(item.InventoryItemDose)
        expiryDateDetail.text = dateF.string(from: item.InventoryItemExpiryDate)
        notesDetail.text = item.InventoryItemNotes
        
    }
    
}
