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
   
    
    // !!!!!STILL TO DO!!!! - DIDN't WANT TO WORK NOW AT STORYBOARD :-S
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryContentTableViewCell
        let item = items[indexPath.row]
        
        cell.drugNameLabel.text = item.InventoryItemName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        cell.expiryDateLabel.text = formatter.string(from: item.InventoryItemExpiryDate)
        
        cell.doseLabel.text = " " + getDrugTypeDescriptions(for: item.InventoryItemType)["amountUnit"]!
        
        return cell
 
    }*/
    
    
    // !!!!!TO IMPLEMENT: SEGUE TO HISTORY VIEW DETAIL
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if self.observer == nil {
            self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: HistoryStrings.HISTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
            
            items = History.instance.items!
            tableView.reloadData()
        }
    }
    
    // DO WE NEED IT?
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
