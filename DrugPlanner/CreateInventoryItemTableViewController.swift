//
//  CreateInventoryItemTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class CreateInventoryItemTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var doseField: UITextField!
    @IBOutlet weak var amountUnitLabel: UILabel!
    @IBOutlet weak var doseUnitLabel: UILabel!
    @IBOutlet weak var expiryDatePicker: UITextField!
    @IBOutlet weak var noteField: UITextField!
    
    var type:String = "" {
        didSet {
            typeLabel.text? = type
            
            let descriptions = getDrugTypeDescriptions(for: DrugType(rawValue: type)!)
            
            amountUnitLabel.text = descriptions["amountUnit"]
            doseUnitLabel.text = descriptions["doseUnit"]
            
        }
    }
    
    var expiryDate : Date?
    
    let datePicker = UIDatePicker()
    var selDate: String?
    
    private var item : InventoryItem!
    
    var inventoryItem : InventoryItem {
        get {
            return item
        }
        set {
            item = newValue
        }
    }
    
    var dateF : DateFormatter = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateF = DateFormatter()
        dateF.dateStyle = .medium
        dateF.timeStyle = .none
        
        createDatePicker()
        
        amountUnitLabel.text = ""
        doseUnitLabel.text = ""
        
        expiryDatePicker.addTarget(self, action: #selector(datePickerSelected), for: .editingDidBegin)
        expiryDatePicker.addTarget(self, action: #selector(datePickerUnselected), for: .editingDidEnd)

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "PickType") {
            if let typePickerViewController = segue.destination as? ChooseTypeTableViewController {
                typePickerViewController.selectedType = type
            }
        } else if (segue.identifier == "SaveInventoryItem") {
            item = InventoryItem(name: nameField.text!, type: DrugType(rawValue: typeLabel.text!)!, amount: Int(amountField.text!)!, dose: Int(doseField.text!)!, expiryDate: expiryDate!, notes: noteField.text!)
        }
        
    }
    
    func inventoryItemEntered() -> Bool {
        
        var entered = true
        
        if let text = nameField.text, !text.isEmpty{
        } else {
            entered = false
        }
        if let text = amountField.text, !text.isEmpty {
        } else {
            entered = false
        }
        if let text = doseField.text, !text.isEmpty {
        } else {
            entered = false
        }
        if let text = expiryDatePicker.text, !text.isEmpty {
        } else {
            entered = false
        }
        if type == "" {
            entered = false
        }
        
        return entered
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            nameField.becomeFirstResponder()

        case 2:
            amountField.becomeFirstResponder()
        case 3:
            doseField.becomeFirstResponder()
        case 4:
            expiryDatePicker.becomeFirstResponder()
        case 5:
            noteField.becomeFirstResponder()
        default:
            break
        }
    }
    

    func createDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        expiryDatePicker.inputView = datePicker
    }
    
    func datePickerChanged() {
        expiryDatePicker.text = dateF.string(from: datePicker.date)
    }
    
    func datePickerSelected() {
        if let dPtext = expiryDatePicker.text {
            dateF.dateStyle = .medium
            dateF.timeStyle = .none
            
            if let previousDate = dateF.date(from: dPtext) {
                datePicker.setDate(previousDate, animated: false)
            } else {
                datePicker.setDate(datePicker.minimumDate!, animated: false)
            }
        }
    }
    
    func datePickerUnselected() {
        if expiryDatePicker.text != nil {
           expiryDate = datePicker.date
        }
    }
    

    @IBAction func unwindWithSelectedType(segue : UIStoryboardSegue) {
        if let typePickerViewController = segue.source as? ChooseTypeTableViewController {
            if let selectedType = typePickerViewController.selectedType {
                type = selectedType
                let descriptions = getDrugTypeDescriptions(for: DrugType(rawValue: type)!)
                amountUnitLabel.text = descriptions["amountUnit"]!
                doseUnitLabel.text = descriptions["doseUnit"]!
                
            }
        }
    }
    
    @IBAction func confirmInventory(_ sender: Any) {
        
        if (inventoryItemEntered()) {
            performSegue(withIdentifier: "SaveInventoryItem", sender: self)
        } else {
            let incompleteInventoryItemController = UIAlertController(title: "Incomplete Information", message: "Please fill out all fields before proceeding.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            incompleteInventoryItemController.addAction(okAction)
            
            present(incompleteInventoryItemController, animated: true, completion: nil)
        }
        
    }
    
}



