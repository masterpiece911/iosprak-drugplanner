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
    
    let datePicker = UIDatePicker()
    
    var expiryDate : Date?
    
    var item : InventoryItem!
    
    let dateF : DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateF.dateStyle = .medium
        dateF.timeStyle = .none
        
        nameField.text = item.InventoryItemName
        amountField.text = String(item.InventoryItemAmount)
        doseField.text = String(item.InventoryItemDose)
        expiryDatePicker.text = dateF.string(from: item.InventoryItemExpiryDate)
        notesField.text = item.InventoryItemNotes
        
        let descriptions = getDrugTypeDescriptions(for: item.InventoryItemType)
        
        amountLabel.text = descriptions["amountUnit"]!
        doseLabel.text = descriptions["doseUnit"]!
        
        self.title = "Edit " + item.InventoryItemName
        
        createDatePicker()
        
        expiryDatePicker.addTarget(self, action: #selector(datePickerSelected), for: .editingDidBegin)
        expiryDatePicker.addTarget(self, action: #selector(datePickerUnselected), for: .editingDidEnd)
        expiryDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
        expiryDatePicker.inputView = datePicker
    }
    
    func datePickerChanged() {
        expiryDatePicker.text = dateF.string(from: datePicker.date)
        expiryDate = datePicker.date
    }
    
    func datePickerSelected() {
        if let dPtext = expiryDatePicker.text {
            
            if let previousDate = dateF.date(from : dPtext) {
                datePicker.setDate(previousDate, animated: false)
            } else {
                datePicker.setDate(datePicker.minimumDate!, animated: false)
                expiryDatePicker.text = dateF.string(from: datePicker.date)
            }
        }
    }
    
    func datePickerUnselected() {
        if expiryDatePicker.text != "" && expiryDate != nil {
            expiryDate = datePicker.date
        } else {
            expiryDate = nil
        }
    }

    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
