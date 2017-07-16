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
        
        ref.child("Users").child(userID!).child("Inventory").observe(DataEventType.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            var alreadyIn = false;
            
            for val in (value)! {
                
                let obj = val.value as! NSDictionary
                
                /* STRING-DATE FORMATTED TO DATE
                var date = obj["expiryDate"] as? String
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let dateFormatted = dateFormatter.date(from: date!)!
                */
                
                //the INT from Firebase TO DATE
                let date = obj["expiryDate"] as? Int
                // convert Int to Double
                let timeInterval = Double(date!)
                // create NSDate from Double (NSTimeInterval)
                let dateFormatted = Date(timeIntervalSince1970: timeInterval)
                
                let item = InventoryItem(key: val.key as! String,name: (obj["name"] as? String)!, type: DrugType(rawValue: (obj["type"] as? String)!)!, amount: (obj["amount"] as? Int)!, dose: (obj["dose"] as? Int)!, expiryDate: dateFormatted, notes: (obj["notes"] as? String)!)
                
                for i in self.items{
                    if(i.InventoryItemKey == item.InventoryItemKey){
                        alreadyIn = true;
                    }
                }
                
                if(!alreadyIn){
                    self.items.append(item);
                }
                self.tableView.reloadData()
            }
        })


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
            
            print("destination")
            print(segue.destination)
            if let cell = sender as? UITableViewCell {
                print(cell)
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    
                    let selectedItem = items[index]
                    print("destination")
                    print(selectedItem.InventoryItemName)
                    print(segue.destination)
                    if let destination = segue.destination as? UINavigationController {
                        if let topDestination = destination.topViewController as? InventoryDetailTableViewController{
                            print(topDestination)
                            topDestination.item = selectedItem
                        }
                    }
                }
            }
            
        }
        
    }
    

    
    
    
    @IBAction func saveNewInventoryItem(segue:UIStoryboardSegue) {

        
        if let createInventoryController = segue.source as? CreateInventoryItemTableViewController {

            Inventory.instance.add(inventory: createInventoryController.inventoryItem)
            
            let unformattedItem = createInventoryController.inventoryItem
            
            let dateF = DateFormatter()
            dateF.dateStyle = .medium
            dateF.timeStyle = .none
            
            // convert Date to TimeInterval
           let timeInterval = unformattedItem.InventoryItemExpiryDate.timeIntervalSince1970
            // convert to Integer
            let dateInt = Int(timeInterval)
            
            
            items.append(unformattedItem);
            
            let newItem = ["name": unformattedItem.InventoryItemName,
                           "amount": unformattedItem.InventoryItemAmount,
                           "dose": unformattedItem.InventoryItemDose,
                           "notes": unformattedItem.InventoryItemNotes,
                           "expiryDate": dateInt,
                           "type": unformattedItem.InventoryItemType.rawValue] as [String : Any]
            
            let usersRef = self.ref.child("Users").child(userID).child("Inventory");
            
            usersRef.childByAutoId().setValue(newItem)
        }
      
    }
  

    @IBAction func cancelInventoryItemDetail(segue:UIStoryboardSegue) {
        
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
