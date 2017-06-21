//
//  CreateInventoryItemTableViewController.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class CreateInventoryItemTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var doseField: UITextField!
    @IBOutlet weak var amountUnitLabel: UILabel!
    @IBOutlet weak var doseUnitLabel: UILabel!
    @IBOutlet weak var expiryDatePicker: UIDatePicker!
    @IBOutlet weak var noteField: UITextField!
    
    var type:String = "" {
        didSet {
            typeLabel.text? = type
        }
    }
    
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func unwindWithSelectedType(segue : UIStoryboardSegue) {
        if let typePickerViewController = segue.source as? ChooseTypeTableViewController {
            if let selectedType = typePickerViewController.selectedType {
                type = selectedType
            }
        }
    }

}
