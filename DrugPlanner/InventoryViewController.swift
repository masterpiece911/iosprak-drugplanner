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
    var ref : DatabaseReference!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var userID : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser?.uid
        
        ref = delegate.ref;
        
        ref.child("Users").child(userID!).child("Inventory").observe(DataEventType.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            var alreadyIn = false;
            
            for val in (value)! {
                
                var obj = val.value as! NSDictionary
                var date = obj["expiryDate"] as? String
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let dateFormatted = dateFormatter.date(from: date!)!
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    var filePath: String {
        let manager = FileManager.default;
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first; // URL Array mit Pfaden; empfohlen: erstes
        return url!.appendingPathComponent("InventoryItems").path;
    }
    
    private func loadData(){
        if let myItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [InventoryItem]{
            items = myItems;
        }
    }
    
    // Daten werden in das File gespeichert
    private func saveData(inventoryItem: InventoryItem){
        items.append(inventoryItem);
        NSKeyedArchiver.archiveRootObject(items, toFile: filePath); // Speicherung vom Array ins File
    }

    
    // TODO: Add new Med Action

    
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
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
            
            let unformattedItem = createInventoryController.inventoryItem
            
            let dateF = DateFormatter()
            dateF.dateStyle = .medium
            dateF.timeStyle = .none
            let date = dateF.string(from: unformattedItem.InventoryItemExpiryDate)
            
            
            items.append(unformattedItem);
            
            let newItem = ["name": unformattedItem.InventoryItemName,
                           "amount": unformattedItem.InventoryItemAmount,
                           "dose": unformattedItem.InventoryItemDose,
                           "notes": unformattedItem.InventoryItemNotes,
                           "expiryDate": date,
                           "type": unformattedItem.InventoryItemType.rawValue] as [String : Any]
            
            let usersRef = self.ref.child("Users").child(userID).child("Inventory");
            
            usersRef.childByAutoId().setValue(newItem)
        }
      
    }
  
    @IBAction func cancelInventoryItem(segue:UIStoryboardSegue) {
     
    }
    
    @IBAction func editInventoryItem(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func deleteInventoryItem(segue:UIStoryboardSegue) {
        
    }
    
}
