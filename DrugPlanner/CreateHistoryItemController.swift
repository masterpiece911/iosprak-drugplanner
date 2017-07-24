//
//  CreateHistoryItemController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 23.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class CreateHistoryItemController: UITableViewController {

    @IBOutlet weak var DrugNameLabel: UILabel!
    @IBOutlet weak var DateOfTakeLabel: UITextField!
    @IBOutlet weak var DoseLabel: UITextField!
    @IBOutlet weak var NotesLabel: UITextField!
    
    let datePicker = UIDatePicker()
    var dateF : DateFormatter = DateFormatter()
    var dateofTaken : Date?
    var drugName : String?
    var dose     : Int?
    var notes    : String?
    
    let drugsLabelDefault = "Select a drug"
    
    var drug : InventoryItem? {
        didSet{
                drugName = drug?.InventoryItemName
                let drugType = drug?.InventoryItemType
                DrugNameLabel.text? = drugName!
                DoseLabel.text? = getDrugTypeDescriptions(for: drugType!)["doseUnit"]!
            
        }
    }
    
    var historyItem : HistoryItem?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateF = DateFormatter()
        dateF.dateStyle = .medium
        dateF.timeStyle = .medium
        
        createDatePicker()
        DateOfTakeLabel.addTarget(self, action: #selector(datePickerSelected), for: .editingDidBegin)
        DateOfTakeLabel.addTarget(self, action: #selector(datePickerUnselected), for: .editingDidEnd)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        DrugNameLabel.text = drugsLabelDefault

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    func createDatePicker(){
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date(timeIntervalSinceNow: 12 * 60 * 60)
        let currentCalendar = NSCalendar.current
        let dateComponents = NSDateComponents()
        dateComponents.month = -1
        let oneMonthBack = currentCalendar.date(byAdding: dateComponents as DateComponents, to: NSDate() as Date)!
        //minimum day is set to one month ago, in case you remember that you took a pill in a specific day
        datePicker.minimumDate = oneMonthBack
        
        DateOfTakeLabel.inputView = datePicker
    }
    
    func datePickerChanged() {
        DateOfTakeLabel.text = dateF.string(from: datePicker.date)
        dateofTaken = datePicker.date
    }
    
    func datePickerSelected() {
        if let dPtext = DateOfTakeLabel.text {
            
            if let previousDate = dateF.date(from: dPtext) {
                datePicker.setDate(previousDate, animated: false)
                dateofTaken = datePicker.date
            } else {
                datePicker.setDate(Date(), animated: false)
                DateOfTakeLabel.text = dateF.string(from: datePicker.date)
                dateofTaken = datePicker.date
            }
        }
    }
    
    func datePickerUnselected() {
        if DateOfTakeLabel.text != "" && dateofTaken != nil {
            dateofTaken = datePicker.date
        } else {
            dateofTaken = nil
        }
    }
    
    @IBAction func saveHistoryItem(_ sender: Any) {
        dose = Int(DoseLabel.text!)
        notes = NotesLabel.text
        // TO MODIFY!!!!!!!!!!!!
        drugName = "a"
        
        
        performSegue(withIdentifier: "saveHistoryItem", sender: self)
    }
    
    @IBAction func undwindWithSelectedDrugHistory (segue: UIStoryboardSegue) {
        if let drugPickerController = segue.source as? HistoryDrugChooseTableViewController {
            if let selectedDrug = drugPickerController.selectedDrug {
                self.drugName = selectedDrug.InventoryItemName
                self.drug = selectedDrug
            }
        }
        
    }
   
}
