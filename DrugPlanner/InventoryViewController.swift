//
//  InventoryViewController.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class InventoryViewController: UITableViewController, UITextFieldDelegate {
    
    var items = [InventoryItem]()
    
    var observer : Any?
    
    var alertController : UIAlertController?
    
    var takenIndex : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.INVENTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
        
        items = Inventory.instance.items!
        tableView.reloadData()

        
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
        cell.dosesLabel.text = " " + getDrugTypeDescriptions(for: item.InventoryItemType)["amountUnit"]!
        if String(item.InventoryItemPhoto) != "" {
                    cell.drugImage.image = item.convertStringToImage(photoAsString: item.InventoryItemPhoto)
        }

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let markTaken = UITableViewRowAction(style: .normal, title: "Take", handler: {
            action, index in
            print("\(self.items[index.row].InventoryItemName) as taken")
            self.takenIndex = index.row
            self.drugTakenTapped(index.row)
        })
        
        markTaken.backgroundColor = UIColor(colorLiteralRed: 0.15294117647058825
, green: 0.6823529411764706, blue: 0.3764705882352941, alpha: 1)
        
        return [markTaken]
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "InventoryDetail") {
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    
                    let selectedItem = items[index]
                    if let destination = segue.destination as? UINavigationController {
                        if let topDestination = destination.topViewController as? InventoryDetailTableViewController{
                            topDestination.item = selectedItem
                        }
                    }
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if self.observer == nil {
            self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.INVENTORY_UPDATE), object: nil, queue: nil, using: listDidUpdate)
            
            items = Inventory.instance.items!
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
    
    @IBAction func saveNewInventoryItem(segue:UIStoryboardSegue) {

        
        if let createInventoryController = segue.source as? CreateInventoryItemTableViewController {

            Inventory.instance.add(inventory: createInventoryController.inventoryItem)
            
        }
      
    }
  

    @IBAction func cancelInventoryItemDetail(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelInventoryItemAdd(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func deleteInventoryItem(segue:UIStoryboardSegue) {
        
        if let editInventoryController = segue.source as? InventoryEditController {
            
            Inventory.instance.remove(inventory: editInventoryController.item)
            
        }
        
    }
    
    func listDidUpdate(notification: Notification) {
        
        self.items = Inventory.instance.items!
        self.tableView.reloadData()
        
    }
    
    func drugTakenTapped (_ index: Int) {
        
        self.alertController = UIAlertController(title: "Confirm that you took \(items[index].InventoryItemName)?", message: "This will be noted in your history.", preferredStyle: .alert)

        alertController!.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
            
            textField.placeholder = "Enter your intake dose"
            textField.keyboardType = .numberPad
            textField.delegate = self
            
        })
        
        let alertConfirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {
            action in
            
            let takenItem = self.items[index]
            let takenAmount = Int((self.alertController!.textFields?[0].text!)!)!
            takenItem.InventoryItemAmount -= takenAmount
            let now = Date()
            
            Inventory.instance.edit(inventory: takenItem)
            History.instance.add(historyItem: HistoryItem.init(withInventory: takenItem, withAmount: takenAmount, atDate: now, withNotes: "", usingKey: "tmp"))
        })
        
        alertConfirmAction.isEnabled = false
        
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController!.addAction(alertConfirmAction)
        alertController!.addAction(alertCancelAction)
        
        present(alertController!, animated: true, completion: nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let previousInput = textField.text!
        
        if string == "" && previousInput.substring(to: previousInput.index(before: previousInput.endIndex)) == "" {
            self.alertController!.actions[0].isEnabled = false
            self.alertController!.message = "An intake dose is required."
            return true
        } else {
            var newInput : String
            if string == "" {
                newInput = previousInput.substring(to: previousInput.index(before: previousInput.endIndex))
            } else {
                newInput = previousInput.appending(string)
            }
            
            if let intake = Int(newInput) {
                
                if intake <= self.items[self.takenIndex!].InventoryItemAmount {
                    self.alertController!.actions[0].isEnabled = true
                    self.alertController!.message = "This will be noted in your history."
                } else {
                    self.alertController!.actions[0].isEnabled = false
                    self.alertController!.message = "Your intake dose can not be higher than your remaining doses."
                }
                
            }
            
            
            return string == "" || Int(string) != nil

        }
        
        
        
    }
    
    
    
    
    
}
