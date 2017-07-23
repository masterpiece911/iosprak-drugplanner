//
//  HistoryDrugChooseTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 23.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class HistoryDrugChooseTableViewController: UITableViewController {

    
    //an array with the list with all drugs
    var drugs = [InventoryItem]()
    
    var selectedDrug : InventoryItem? {
        didSet{
            if let drug = selectedDrug {
                selectedDrugIndex = drugs.index(where: {
                    drugItem in
                    if drug.InventoryItemKey == drugItem.InventoryItemKey {
                        return true
                    } else {
                        return false
                    }
                    
                })
            }
        }
    }
    
    var selectedDrugIndex : Int?
    
   var observer :  Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drugs = Inventory.instance.items!
        
        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.INVENTORY_UPDATE), object: nil, queue: nil, using: drugListDidUpdate)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drugs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugCell", for: indexPath)
        
        let drug = drugs[indexPath.row]
        
        cell.textLabel?.text = drug.InventoryItemName
        
        if indexPath.row == selectedDrugIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let index = selectedDrugIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedDrug = drugs[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
    }
    
    func drugListDidUpdate(notification: Notification) {
        self.drugs = Inventory.instance.items!
        self.tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if let obs = self.observer {
            NotificationCenter.default.removeObserver(obs)
            self.observer = nil
        }
        
        if segue.identifier == "SaveDrug" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    selectedDrug = drugs[index]
                }
                
            }
        }
        
    }
    
}
