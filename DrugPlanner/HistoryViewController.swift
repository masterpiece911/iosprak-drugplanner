//
//  HistoryViewController.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin and Ioana :)))) huhuhuh on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    var items = [HistoryItem]()
    
    var observer : Any?
    
    var expandedRows = Set<Int>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: HistoryStrings.HISTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
        
        items = History.instance.items!
        tableView.reloadData()
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // - History Table view data source - the already intaken Drugs

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
   
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryContentTableViewCell
        let historyItem = items[indexPath.row]
        
        
        // DATE AND TIME AUSFÜLLEN
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        cell.TimeOfTakeLabel.text = formatter.string(from: historyItem.dateAndTime)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.DateOfTakeLabel.text = formatter.string(from: historyItem.dateAndTime)
        
        //DRUG NAME
        cell.DrugNameLabel.text = historyItem.drugName
        
        //INTAKEN DOSE LABEL
        cell.DoseLabel.text = String(historyItem.intakenDose)
        
        //DOSE UNIT LABEL AUSFÜLLEN
        cell.DoseUnitLabel.text = getDrugTypeDescriptions(for: DrugType(rawValue: historyItem.drugType!)!)["amountUnit"]! + " a \(historyItem.drugConcentration!)" + getDrugTypeDescriptions(for: DrugType(rawValue: historyItem.drugType!)!)["doseUnit"]!
        
        //ACCESSORY VIEW IMAGE
        if historyItem.taken {
            cell.takenSwitch.setOn(true, animated: true)
            let image = #imageLiteral(resourceName: "OK") // checked 
            cell.accessoryView = UIImageView(image: image)
        }
        else {
            cell.takenSwitch.setOn(false, animated: true)
            let image = #imageLiteral(resourceName: "Unchecked") //- not checked
            cell.accessoryView = UIImageView(image :image)
        }
        
        cell.historyNoteTextField.text = historyItem.notes!
        
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        
        return cell
 
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? HistoryContentTableViewCell
            
            else { return }
        switch cell.isExpanded{
            case true:
                self.expandedRows.remove(indexPath.row)
            
            case false:
                self.expandedRows.insert(indexPath.row)
        }
        
        cell.isExpanded = !cell.isExpanded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if self.observer == nil {
            self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: HistoryStrings.HISTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
            
            items = History.instance.items!
            tableView.reloadData()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        if let obs = self.observer {
            NotificationCenter.default.removeObserver(obs)
            self.observer = nil
        }
        
    }
    
    @IBAction func editHistoryItem(_ sender: UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview as? HistoryContentTableViewCell {
            //TODO: edit History Item
            
        }
    }
    
    
    @IBAction func deleteHistoryItem(_ sender: UIButton) {
        

        if let cell = sender.superview?.superview?.superview?.superview as? HistoryContentTableViewCell {
            //TODO: delete History Item
        }
        
    }
    
    @IBAction func saveNewHistoryItem (segue : UIStoryboardSegue) {
        
        if let createHistoryController = segue.source as? CreateHistoryItemController {
    
                History.instance.add(historyItem: createHistoryController.historyItem!)
            
        }
        
    }
    
    //DELETE HISTORY ITEM - brauchen wir ein Delete zu implementieren?
    
    
    
    @IBAction func cancelCreateHistoryEvent(segue:UIStoryboardSegue) {
    }
    
    
    func listDidUpdate(notification: Notification) {
        
        self.items = History.instance.items!
        self.tableView.reloadData()
        
    }
    
}
