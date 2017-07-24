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

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
}
