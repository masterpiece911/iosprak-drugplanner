//
//  InventoryDetailTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 28.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class InventoryEditController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var doseField: UITextField!
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var expiryDatePicker: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    
    
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
        
        print(item.InventoryItemName)
        // SET FIELDS TO INVENTORY ITEM VALUES
        nameField.text = item.InventoryItemName
        amountField.text = String(item.InventoryItemAmount)
        
        doseField.text = String(item.InventoryItemDose)
        expiryDatePicker.text = dateF.string(from: item.InventoryItemExpiryDate)
        if (item.InventoryItemExpiryDate < Date(timeIntervalSinceNow: 0)) {
            expiryDatePicker.isEnabled = false
        }
        
        notesField.text = item.InventoryItemNotes
        
        // GET DESCRIPTIONS FOR INVENTORY ITEM TYPE
        let descriptions = getDrugTypeDescriptions(for: item.InventoryItemType)
        
        amountLabel.text = descriptions["amountUnit"]!
        doseLabel.text = descriptions["doseUnit"]!
        
        // SET TITLE
        self.title = "Edit " + item.InventoryItemName
        
        // SETUP FOR UI ELEMENTS
        createDatePicker()
        
        setupAlerts()
        
        expiryDatePicker.addTarget(self, action: #selector(detailDatePickerSelected), for: .editingDidBegin)
        expiryDatePicker.addTarget(self, action: #selector(detailDatePickerUnselected), for: .editingDidEnd)
        datePicker.addTarget(self, action: #selector(detailDatePickerChanged), for: .valueChanged)
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            nameField.becomeFirstResponder()
        case 1:
            amountField.becomeFirstResponder()
        case 2:
            doseField.becomeFirstResponder()
        case 3:
            expiryDatePicker.becomeFirstResponder()
        case 4:
            notesField.becomeFirstResponder()
        default:
            break
        }
    }
    
    // SETUP FUNCTIONS FOR DATE PICKER
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
        expiryDatePicker.inputView = datePicker
    }
    
    func detailDatePickerChanged() {
        expiryDatePicker.text = dateF.string(from: datePicker.date)
        expiryDate = datePicker.date
    }
    
    func detailDatePickerSelected() {
        if let dPtext = expiryDatePicker.text {
            
            if let previousDate = dateF.date(from : dPtext) {
                datePicker.setDate(previousDate, animated: false)
            } else {
                datePicker.setDate(datePicker.minimumDate!, animated: false)
                expiryDatePicker.text = dateF.string(from: datePicker.date)
            }
        }
    }
    
    func detailDatePickerUnselected() {
        if expiryDatePicker.text != "" && expiryDate != nil {
            expiryDate = datePicker.date
        } else {
            expiryDate = nil
        }
    }
    
    // SETUP FUNCTIONS FOR ALERTS
    
    func setupAlerts() {
        
        let returnToListAction = UIAlertAction(title: "Yes", style: .destructive, handler: self.cancelWithoutSaveConfirmed)
        let cancelReturnAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        cancelAlert.addAction(returnToListAction)
        cancelAlert.addAction(cancelReturnAction)
        
        let confirmDeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.deleteConfirmed)
        let cancelDeleteAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        deleteAlert.addAction(confirmDeleteAction)
        deleteAlert.addAction(cancelDeleteAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        editAlert.addAction(okAction)
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "CancelInventory" :
                break;
            case "DeleteInventory" :
                break;
            case "EditInventory" :
                item.InventoryItemName       = nameField.text!
                item.InventoryItemAmount     = Int(amountField.text!)!
                item.InventoryItemDose       = Int(doseField.text!)!
                item.InventoryItemExpiryDate = dateF.date(from: expiryDatePicker.text!)!
                if let notes = notesField.text {
                    item.InventoryItemNotes = notes
                }
            default:
                break;
            }
        }
    }
    
    // CANCEL ACTIONS
    
    @IBAction func cancelButtonPressed (_ sender : Any) {
        if (isValidEntry()) {
            
            if (isEdited()) {
                
                present(cancelAlert, animated: true, completion: nil)
                
            } else {
                performSegue(withIdentifier: "CancelInventory", sender: self)
            }
        } else {
            performSegue(withIdentifier: "CancelInventory", sender: self)
        }
    }
    
    func cancelWithoutSaveConfirmed (action : UIAlertAction) {
        performSegue(withIdentifier: "CancelInventory", sender: self)
    }
    
    // DONE ACTIONS
    
    @IBAction func doneButtonPressed (_ sender : Any) {
        if (isValidEntry()) {
            
            if (isEdited()) {
                
                performSegue(withIdentifier: "EditInventory", sender: self)
                
            } else {
                performSegue(withIdentifier: "CancelInventory", sender: self)
            }
        } else {
            present(editAlert, animated: true, completion: nil)
        }
    }
    
    // DELETE ACTIONS
    
    @IBAction func deleteButtonPressed (_ sender : Any) {
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func deleteConfirmed (action : UIAlertAction) {
        performSegue(withIdentifier: "DeleteInventory", sender: self)
    }
    
    // HELPER FUNCTIONS FOR ACTIONS
    
    func isEdited() -> Bool {
        var edited = false
        
        let currentName       = nameField.text!
        let currentAmount     = Int(amountField.text!)!
        let currentDose       = Int(doseField.text!)!
        let currentExpiryDate = dateF.date(from: expiryDatePicker.text!)!
        
        if (
            currentName       != item.InventoryItemName   ||
                currentAmount     != item.InventoryItemAmount ||
                currentDose       != item.InventoryItemDose   ||
                currentExpiryDate != item.InventoryItemExpiryDate
            ) {
            edited = true
        }
        
        return edited
        
        
    }
    
    func isValidEntry() -> Bool {
        
        var textFieldEmpty = true
        var validEntry = false
        
        if  let name       = nameField.text,
            let amount     = amountField.text,
            let dose       = doseField.text,
            let expiryDate = expiryDatePicker.text
        {
            
            if (name != "" &&
                amount != "" &&
                dose != "" &&
                expiryDate != "")
            {
                textFieldEmpty = false
            }
            
        }
        
        if (!textFieldEmpty) {
            if  let _ = Int(amountField.text!),
                let _ = Int(doseField.text!) {
                validEntry = true
            }
        }
        
        return validEntry
    }
    
}
