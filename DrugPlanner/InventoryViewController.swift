//
//  InventoryViewController.swift
//  DrugPlanner
//
//  Created by admin on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class InventoryViewController: UITableViewController {
    
    var items = [InventoryItem]()
    
    var observer : Any?


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
        
        let photoString = String(item.InventoryItemPhoto)
        let dataDecoded : Data = Data(base64Encoded: photoString!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.drugImage.image = decodedimage
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "InventoryDetail") {
            
            if let cell = sender as? UITableViewCell {
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
    
}
