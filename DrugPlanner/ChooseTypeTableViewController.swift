//
//  ChooseTypeTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 21.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class ChooseTypeTableViewController: UITableViewController {

    var types : [String] = [
        DrugType.mg.rawValue,
        DrugType.ml.rawValue,
        DrugType.pill.rawValue,
        DrugType.injection.rawValue,
        DrugType.syrup.rawValue
    ]
    
    var selectedType:String? {
        didSet {
            if let type = selectedType {
                selectedTypeIndex = types.index(of: type)
            }
        }
    }
    
    var selectedTypeIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return types.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)

        cell.textLabel?.text = types[indexPath.row]
        
        var image : UIImage
        
        if indexPath.row == selectedTypeIndex {
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
        
        if let index = selectedTypeIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryView = UIImageView(image : image)
        }
        
        selectedType = types[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        
        image = #imageLiteral(resourceName: "OK")
        cell?.accessoryView = UIImageView(image: image)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "SaveSelectedType" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    selectedType = types[index]
                }
            }
        }
        
    }

}
