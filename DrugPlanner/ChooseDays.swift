//
//  ChooseDays.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 12.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class ChooseDays: UITableViewController {

    var weekdays : [AgendaItem.Weekday : Bool]!
    var source : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return weekdays.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekdayCell")!
            
        let weekday = AgendaItem.getWeekday(for: indexPath.row + 1)
            
        cell.textLabel?.text = weekday.rawValue
            
        if(weekdays[weekday])! {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath){
            
            let weekday = AgendaItem.getWeekday(for: indexPath.row + 1)
            
            weekdays[weekday]! = !weekdays[weekday]!
            
            if(weekdays[weekday]!) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        }
        
        
        
    }

    @IBAction func donePressed(_ sender: Any) {
        if let _ = source as? AgendaEditController {
            performSegue(withIdentifier: "UnwindToAgendaEdit", sender: self)
        }
        if let _ = source as? CreateAgendaItemTableViewController {
            performSegue(withIdentifier: "UnwindToAgendaCreation", sender: self)
        }
    }

}
