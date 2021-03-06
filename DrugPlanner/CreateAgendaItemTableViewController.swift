//
//  CreateAgendaItemTableViewController.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 05.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class CreateAgendaItemTableViewController: UITableViewController {
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var drugNameLabel : UILabel!
    @IBOutlet weak var doseField : UITextField!
    @IBOutlet weak var doseUnitLabel : UILabel!
    @IBOutlet weak var daysLabel : UILabel!
    
    let daysLabelPrefix = "Take on "
    let daysLabelDefault = "Select days of the week"
    let drugsLabelDefault = "Select a drug"
    
    let timePicker = UIDatePicker()
    var timeDate : Date?
    var dateF : DateFormatter = DateFormatter()
    var dateE : DateFormatter = DateFormatter()

    var endDate : Date?
    let datePicker = UIDatePicker()

    var drug : InventoryItem? {
        didSet{
            if let drugName = drug?.InventoryItemName,
                let drugType = drug?.InventoryItemType {
                drugNameLabel.text? = drugName
                doseUnitLabel.text? = getDrugTypeDescriptions(for: drugType)["amountUnit"]!
            }
        }
    }
    
    var weekdays : [AgendaItem.Weekday : Bool]? {
        didSet {
            weekdaysSet()
        }
    }
    
    var agendaItem : AgendaItem?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateF = DateFormatter()
        dateF.dateStyle = .none
        dateF.timeStyle = .short
        dateE = DateFormatter()
        dateE.dateStyle = .medium
        dateE.timeStyle = .none
        createTimePicker()
        createDatePicker()
        
        timeTextField.addTarget(self, action: #selector(timePickerSelected), for: .editingDidBegin)
        timeTextField.addTarget(self, action: #selector(timePickerUnselected), for: .editingDidEnd)
        timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        
        endDateTextField.addTarget(self, action: #selector(datePickerSelected), for: .editingDidBegin)
        endDateTextField.addTarget(self, action: #selector(datePickerUnselected), for: .editingDidEnd)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

        weekdays = AgendaItem.generateWeekdayDictionary()
        daysLabel.text = daysLabelDefault
        drugNameLabel.text = drugsLabelDefault
        
    }

    @IBAction func addCell(_ sender: UIButton) {
//        print(sender.superview?.superview)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            doseField.becomeFirstResponder()
        case 2:
            timeTextField.becomeFirstResponder()
        case 4:
            endDateTextField.becomeFirstResponder()
        default:
            break;
        }
        
    }
    
    func createTimePicker(){
        timePicker.datePickerMode = .time
        timePicker.minimumDate = Date(timeIntervalSinceReferenceDate: 0)
        timePicker.maximumDate = Date(timeIntervalSinceReferenceDate: 24 * 60 * 60)
        timeTextField.inputView = timePicker
    }
    
    func timePickerChanged() {
        timeTextField.text = dateF.string(from: timePicker.date)
        timeDate = timePicker.date
    }
    
    func timePickerSelected() {
        if let dPtext = timeTextField.text {
            
            if let previousDate = dateF.date(from: dPtext) {
                timePicker.setDate(previousDate, animated: false)
                timeDate = timePicker.date
            } else {
                timePicker.setDate(timePicker.minimumDate!, animated: false)
                timeTextField.text = dateF.string(from: timePicker.date)
                timeDate = timePicker.date
            }
        }
    }
    
    func timePickerUnselected() {
        if timeTextField.text != "" && timeDate != nil {
            timeDate = timePicker.date
        } else {
            timeDate = nil
        }
    }
    
    func createDatePicker(){
        datePicker.datePickerMode = .date
//        datePicker.minimumDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
        datePicker.minimumDate = Date(timeIntervalSinceNow: 0)
        endDateTextField.inputView = datePicker
    }
    
    func datePickerChanged() {
        endDateTextField.text = dateE.string(from: datePicker.date)
        endDate = datePicker.date
    }
    
    func datePickerSelected() {
        if let dPtext = endDateTextField.text {
            
            if let previousDate = dateE.date(from: dPtext) {
                datePicker.setDate(previousDate, animated: false)
                endDate = datePicker.date
            } else {
                datePicker.setDate(datePicker.minimumDate!, animated: false)
                endDateTextField.text = dateE.string(from: datePicker.date)
                endDate = datePicker.date
            }
        }
    }
    
    func datePickerUnselected() {
        if endDateTextField.text != "" && endDate != nil {
            endDate = datePicker.date
        } else {
            endDate = nil
        }
    }
    
    func weekdaysSet() {
        
        var dayString = daysLabelPrefix
        
        for weekdayIndex in 1...7 {
            
            let weekday = AgendaItem.getWeekday(for: weekdayIndex)
            
            if let boolean = (weekdays?[weekday]) {
                if(boolean){
                    if(dayString == daysLabelPrefix) {
                        dayString += weekday.rawValue
                    } else {
                        dayString += ", " + weekday.rawValue
                    }
                    
                }
            }
            
        }
        
        if (dayString != daysLabelPrefix) {
            daysLabel.text = dayString
        } else {
            daysLabel.text = daysLabelDefault
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ChooseWeekdays" ) {
            
            if let weekdayChooserController = segue.destination as? ChooseDays {
                weekdayChooserController.source = segue.source
                weekdayChooserController.weekdays = weekdays
            }
            
        }
        
        else if (segue.identifier == "ChooseDrugCreateAgenda" ) {
            if let chooseDrugController = segue.destination as?  ChooseDrugTableViewController {
                chooseDrugController.source = segue.source
        }
        
    }
    }
    @IBAction func undwindWithSelectedDrug (segue: UIStoryboardSegue) {
        if let drugPickerController = segue.source as? ChooseDrugTableViewController {
            if let selectedDrug = drugPickerController.selectedDrug {
                self.drug = selectedDrug
                
            }
        }
        
        
        
    }
    
    
    @IBAction func confirmAgenda(_ sender: Any) {
        
        if (agendaItemEntered()) {
            agendaItem = AgendaItem(for: (drug)!, with: Int(doseField.text!)!, at: timeDate!, on: weekdays!, until: endDate!, using: "")
            performSegue(withIdentifier: "saveAgendaItem", sender: self)
        } else {
            let incompleteAgendaItemController = UIAlertController(title: "Incomplete Information", message: "Please fill out all fields before proceeding.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            incompleteAgendaItemController.addAction(okAction)
            
            present(incompleteAgendaItemController, animated: true, completion: nil)
        }
        
    }
    
    func agendaItemEntered() -> Bool {
        
        var entered = true
        
        if let text = drug?.InventoryItemName, !text.isEmpty{
        } else {
            entered = false
        }
        if let text = doseField.text, !text.isEmpty {
        } else {
            entered = false
        }
        if let text = timeTextField.text, !text.isEmpty {
        } else {
            entered = false
        }
        if let text = endDateTextField.text, !text.isEmpty {
        } else {
            entered = false
        }
        
        if (weekdays?.count)! > 0 {
            
        }else{
            entered = false
        }
        return entered
    }
    

    @IBAction func unwindWithSelectedWeekdaysForCreation (segue : UIStoryboardSegue) {
        if let weekdayPickerController = segue.source as? ChooseDays {
            self.weekdays = weekdayPickerController.weekdays
        }
    }
    


}
