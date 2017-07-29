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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: HistoryStrings.HISTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
        
        items = History.instance.items!
        tableView.reloadData()

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
       // cell.DoseLabel.text = getDrugTypeDescriptions(for: item.InventoryItemType)["amountUnit"]!
        
        //DOSE UNIT LABEL AUSFÜLLEN
        cell.DoseUnitLabel.text = String(historyItem.drugType)
        
        //ACCESSORY VIE IMAGE

        if historyItem.taken {
            let image = #imageLiteral(resourceName: "OK") // checked 
            cell.accessoryView = UIImageView(image: image)
        }
        else {
            let image = #imageLiteral(resourceName: "Unchecked") //- not; checked
            cell.accessoryView = UIImageView(image :image)
        }
        return cell
 
    }
    
    
    // !!!!!TO IMPLEMENT: SEGUE TO HISTORY VIEW DETAIL
    
    
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
