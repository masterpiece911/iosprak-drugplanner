//
//  ChooseDrugTableViewController.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 12.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class ChooseDrugTableViewController: UITableViewController {
    
    //an array with the list with all drugs
    var drugs = [InventoryItem]()
    var source : UIViewController?
    
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
        
        var image : UIImage
        
        if indexPath.row == selectedDrugIndex {
            image = #imageLiteral(resourceName: "OK")
        } else {
            image = #imageLiteral(resourceName: "Unchecked")
        }
        
        cell.accessoryView = UIImageView(image: image)
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var image : UIImage = #imageLiteral(resourceName: "Unchecked")
        
        if let index = selectedDrugIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryView = UIImageView(image: image)
        }
        
        selectedDrug = drugs[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        image = #imageLiteral(resourceName: "OK")
        cell?.accessoryView = UIImageView(image: image)
        
    }
    
    func drugListDidUpdate(notification: Notification) {
        self.drugs = Inventory.instance.items!
        self.tableView.reloadData()
    }

    @IBAction func donePressedChoosedDrug(_ sender: Any) {
        if let _ = source as? CreateHistoryItemController {
            performSegue(withIdentifier: "SaveSelectedDrugToCreateHistory", sender: self)
        }
        if let _ = source as? CreateAgendaItemTableViewController {
            performSegue(withIdentifier: "SaveSelectedDrugToACreateAgenda", sender: self)
        }
    }
    

}
