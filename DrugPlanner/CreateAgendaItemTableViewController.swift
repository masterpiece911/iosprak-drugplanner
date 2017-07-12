//
//  CreateAgendaItemTableViewController.swift
//  DrugPlanner
//
//  Created by admin on 05.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class CreateAgendaItemTableViewController: UITableViewController {
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var detailDrugLabel: UILabel!
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var doseSelectLabel: UIStackView!
    @IBOutlet weak var dayDetailLabel: UILabel!
    @IBOutlet weak var daysSelectLabel: UILabel!
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var endDateTextField: UITextField!
    
    let timePicker = UIDatePicker()
    var timeDate : Date?
    var dateF : DateFormatter = DateFormatter()
    var dateE : DateFormatter = DateFormatter()

    var endDate : Date?
    let datePicker = UIDatePicker()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateF = DateFormatter()
        dateF.dateStyle = .none
        dateF.timeStyle = .medium
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


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    func createTimePicker(){
        timePicker.datePickerMode = .time
        timePicker.minimumDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
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
            } else {
                timePicker.setDate(timePicker.minimumDate!, animated: false)
                timeTextField.text = dateF.string(from: timePicker.date)
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
            } else {
                datePicker.setDate(datePicker.minimumDate!, animated: false)
                endDateTextField.text = dateE.string(from: datePicker.date)
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

}
