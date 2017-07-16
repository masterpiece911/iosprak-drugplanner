//
//  InventoryViewController.swift
//  DrugPlanner
//
//  Created by admin on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit
import Firebase

class InventoryViewController: UITableViewController {
    
    var items = [InventoryItem]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.INVENTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
        
        items = Inventory.instance.items!
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items)
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryCell", for: indexPath) as! InventoryTableViewCell

//        let user = Auth.auth().addStateDidChangeListener{ (auth, user) in
        
        let item = items[indexPath.row]
        
        cell.drugNameLabel.text = item.InventoryItemName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        cell.expiryDateLabel.text = formatter.string(from: item.InventoryItemExpiryDate)
        
        cell.numberLabel.text = String(item.InventoryItemAmount)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "InventoryDetail") {
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    
                    let selectedItem = items[index]
                    if let destination = segue.destination as? InventoryDetailTableViewController {
                        destination.item = selectedItem
                    }
                }
            }
            
        }
        
    }
    
    
    
    @IBAction func saveNewInventoryItem(segue:UIStoryboardSegue) {

        
        if let createInventoryController = segue.source as? CreateInventoryItemTableViewController {

            Inventory.instance.add(inventory: createInventoryController.inventoryItem)
            
        }
      
    }
  
    @IBAction func cancelInventoryItem(segue:UIStoryboardSegue) {
     
    }
    
    @IBAction func editInventoryItem(segue:UIStoryboardSegue) {
        
        
        
    }
    
    @IBAction func deleteInventoryItem(segue:UIStoryboardSegue) {
        
    }
    
    func listDidUpdate(notification: Notification) {
        
        self.items = Inventory.instance.items!
        self.tableView.reloadData()
        
    }
    
}
