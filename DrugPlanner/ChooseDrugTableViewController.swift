//
//  ChooseDrugTableViewController.swift
//  DrugPlanner
//
//  Created by admin on 12.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit
import Firebase

class ChooseDrugTableViewController: UITableViewController {

    var drugs = [InventoryItem]()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var ref : DatabaseReference!
    var userID : String!
    
    var selectedDrug : InventoryItem? {
        didSet{
            if let drug = selectedDrug {
                selectedDrugIndex = drugs.index(of: drug)
            }
        }
    }
    
    var selectedDrugIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userID = Auth.auth().currentUser?.uid
        
        ref = delegate.ref
        
        ref.child("Users").child(userID!).child("Inventory").observe(DataEventType.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            var alreadyIn = false;
            
            for val in (value)! {
                
                let obj = val.value as! NSDictionary
                
                /*
                 var date = obj["expiryDate"] as? String
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateStyle = .medium
                 let dateFormatted = dateFormatter.date(from: date!)!
                 */
                
                //INT TO DATE
                let date = obj["expiryDate"] as? Int
                // convert Int to Double
                let timeInterval = Double(date!)
                // create NSDate from Double (NSTimeInterval)
                let dateFormatted = Date(timeIntervalSince1970: timeInterval)
                
                let item = InventoryItem(key: val.key as! String,name: (obj["name"] as? String)!, type: DrugType(rawValue: (obj["type"] as? String)!)!, amount: (obj["amount"] as? Int)!, dose: (obj["dose"] as? Int)!, expiryDate: dateFormatted, notes: (obj["notes"] as? String)!)
                
                for i in self.drugs{
                    if(i.InventoryItemKey == item.InventoryItemKey){
                        alreadyIn = true;
                    }
                }
                
                if(!alreadyIn){
                    self.drugs.append(item);
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SaveSelectedDrug" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    selectedDrug = drugs[index]
                }
                
            }
        }
        
    }
    

}
