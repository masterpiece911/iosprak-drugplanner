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
        }
    }
    
    var expiryDate : Date?
    
   let datePicker = UIDatePicker()
    var selDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()

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
        }
        
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
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([done], animated: false)
        expiryDatePicker.inputAccessoryView = toolBar
        expiryDatePicker.inputView = datePicker
   
    }
    
    
    func donePressed(){
        let dateF = DateFormatter()
        dateF.dateStyle = .medium
        dateF.timeStyle = .none
        expiryDatePicker.text = dateF.string(from: datePicker.date)
        expiryDate = datePicker.date
        self.view.endEditing(true)
    }

    @IBAction func unwindWithSelectedType(segue : UIStoryboardSegue) {
        if let typePickerViewController = segue.source as? ChooseTypeTableViewController {
            if let selectedType = typePickerViewController.selectedType {
                type = selectedType
            }
        }
    }
}



