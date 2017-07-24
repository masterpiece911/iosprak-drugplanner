//
//  InventoryDetailTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 28.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class AgendaEditController: UITableViewController {
    

    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var timeDate : Date?
    var endDate : Date?

    var dateF : DateFormatter = DateFormatter()
    var dateE : DateFormatter = DateFormatter()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doseField: UITextField!
    @IBOutlet weak var doseUnitLabel: UILabel!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var weekdaysLabel: UILabel!
    @IBOutlet weak var endDateTextField: UITextField!
    let daysLabelPrefix = "Take on "
    let daysLabelDefault = "No Days"
    
    let cancelAlert = UIAlertController(title: "Confirm Cancel?", message: "You have unsaved changes.", preferredStyle: .alert)
    let deleteAlert = UIAlertController(title: "Confirm Delete?", message: "This action can not be undone.", preferredStyle: .alert)
    let editAlert   = UIAlertController(title: "Incomplete Information", message: "Please fill out all fields before proceeding.", preferredStyle: .alert)
    
    var weekdays : [AgendaItem.Weekday : Bool]? {
        didSet {
            weekdaysSet()
        }
    }
    
    var item : AgendaItem!
    
    
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
        
        timeField.addTarget(self, action: #selector(timePickerSelected), for: .editingDidBegin)
        timeField.addTarget(self, action: #selector(timePickerUnselected), for: .editingDidEnd)
        timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        timeField.text = dateF.string(from: item.agendaTime)
        
        endDateTextField.addTarget(self, action: #selector(datePickerSelected), for: .editingDidBegin)
        endDateTextField.addTarget(self, action: #selector(datePickerUnselected), for: .editingDidEnd)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        endDateTextField.text = dateE.string(for: item.agendaEndDate)
        
        weekdays = item.agendaWeekdays
        
        let descriptions = getDrugTypeDescriptions(for: item.agendaDrug.InventoryItemType)
        nameLabel.text = item.agendaDrug.InventoryItemName
        doseField.text = String(item.agendaDose)
        doseUnitLabel.text = descriptions["amountUnit"]
        setupAlerts()
        
    }
    
    
    func weekdaysSet() {
        
        var dayString = daysLabelPrefix
        
        for weekdayIndex in 1...7 {
            
            let weekday = AgendaItem.getWeekday(for: weekdayIndex)
            print(weekday)
            print(weekdayIndex)
            
            if let boolean = (weekdays?[weekday]) {
                print(boolean)
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
            print("Test")
            print(dayString)
            weekdaysLabel.text = dayString
        } else {
            weekdaysLabel.text = daysLabelDefault
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            doseField.becomeFirstResponder()
        case 2:
            timeField.becomeFirstResponder()
        case 4:
            endDateTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    // SETUP FUNCTIONS FOR DATE PICKER
    
    func createTimePicker(){
        timePicker.datePickerMode = .time
        timePicker.minimumDate = Date(timeIntervalSinceReferenceDate: 0)
        timePicker.maximumDate = Date(timeIntervalSinceReferenceDate: 24 * 60 * 60)
        timeField.inputView = timePicker
    }
    
    func timePickerChanged() {
        timeField.text = dateF.string(from: timePicker.date)
        timeDate = timePicker.date
    }
    
    func timePickerSelected() {
        if let dPtext = timeField.text {
            
            if let previousDate = dateF.date(from: dPtext) {
                timePicker.setDate(previousDate, animated: false)
                timeDate = timePicker.date
            } else {
                timePicker.setDate(timePicker.minimumDate!, animated: false)
                timeField.text = dateF.string(from: timePicker.date)
                timeDate = timePicker.date
            }
        }
    }
    
    func timePickerUnselected() {
        if timeField.text != "" && timeDate != nil {
            timeDate = timePicker.date
        } else {
            timeDate = nil
        }
    }
    
    func createDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
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
    
    @IBAction func unwindWithSelectedWeekdaysForEdit (segue : UIStoryboardSegue) {
        if let weekdayPickerController = segue.source as? ChooseDays {
            self.weekdays = weekdayPickerController.weekdays
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
            case "CancelAgenda" :
                break;
            case "DeleteAgenda" :
                break;
            case "EditAgenda" :
                item.agendaDose = Int(doseField.text!)!
                item.agendaTime = dateF.date(from: timeField.text!)!
                item.agendaEndDate = dateE.date(from: endDateTextField.text!)!
                item.agendaWeekdays = weekdays!
            case "ChooseWeekdaysEdit" :
                if let weekdayChooserController = segue.destination as? ChooseDays {
                    weekdayChooserController.source = segue.source
                    weekdayChooserController.weekdays = weekdays
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
                performSegue(withIdentifier: "CancelAgenda", sender: self)
            }
        } else {
            performSegue(withIdentifier: "CancelAgenda", sender: self)
        }
    }
    
    func cancelWithoutSaveConfirmed (action : UIAlertAction) {
        performSegue(withIdentifier: "CancelAgenda", sender: self)
    }
    
    // DONE ACTIONS
    
    @IBAction func doneButtonPressed (_ sender : Any) {
        if (isValidEntry()) {
            
            if (isEdited()) {
                
                performSegue(withIdentifier: "EditAgenda", sender: self)
                
            } else {
                performSegue(withIdentifier: "CancelAgenda", sender: self)
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
        performSegue(withIdentifier: "DeleteAgenda", sender: self)
    }
    
    
    
    // HELPER FUNCTIONS FOR ACTIONS
    
    func isEdited() -> Bool {
        var edited = false
        
        let currentDose = Int(doseField.text!)!
        let currentTime = dateF.date(from: timeField.text!)!
        let currentDate = dateE.date(from: endDateTextField.text!)!
        let currentWeekdays = weekdays!

        if (
            currentDose != item.agendaDose ||
            currentTime != item.agendaTime ||
            currentDate != item.agendaEndDate ||
            currentWeekdays != item.agendaWeekdays
            ) {
            edited = true
        }
        
        return edited
        
        
    }
    
    func isValidEntry() -> Bool {
        
        var textFieldEmpty = true
        var validEntry = false
        
        if  let dose       = doseField.text,
            let time       = timeField.text,
            let endDate    = endDateTextField.text,
            let weekdays   = weekdaysLabel.text
        {
            
            if (dose != "" &&
                time != "" &&
                endDate != "" &&
                weekdays != daysLabelPrefix)
            {
                textFieldEmpty = false
            }
            
        }
        
        if (!textFieldEmpty) {
            if let _ = Int(doseField.text!) {
                validEntry = true
            }
        }

        
        return validEntry
    }
    
}
