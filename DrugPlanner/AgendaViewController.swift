//
//  AgendaViewController.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class AgendaViewController: UITableViewController {

    var items : [AgendaItem] = [AgendaItem]()
    
    var observer : Any?
    var dateF : DateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = Agenda.instance.items!
        dateF = DateFormatter()
        dateF.dateStyle = .none
        dateF.timeStyle = .short
        self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil, queue: nil, using: agendaListDidUpdate)
     
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaCell", for: indexPath) as! AgendaTableViewCell

        let agendaItem = items[indexPath.row]

        if String(agendaItem.agendaDrug.InventoryItemPhoto) != "" {
            cell.drugImage?.image = agendaItem.agendaDrug.convertStringToImage(photoAsString: agendaItem.agendaDrug.InventoryItemPhoto)
        }
        cell.nameLabel?.text = agendaItem.agendaDrug.InventoryItemName
        var weekday = getDayOfWeek(today: Date())
        var day = AgendaItem.getWeekday(for: weekday)
        let timeNow = dateF.date(from: dateF.string(from: Date()))!
        let timeOlder = timeNow < agendaItem.agendaTime

        var weekdayCount = 1;
        
        
        
        if(agendaItem.agendaWeekdays[day]! && timeOlder){
            cell.dateLabel?.text = "today"
        }else{
            weekdayCount = weekdayCount + 1
            weekday = weekday + 1;
            day = AgendaItem.getWeekday(for: weekday)
            if(agendaItem.agendaWeekdays[day]!){
                cell.dateLabel?.text = "tomorrow"
            }else{
                while(!agendaItem.agendaWeekdays[day]! && weekdayCount < 8){
                    if(weekday == 7){
                        weekday = 1;
                    }else{
                        weekday = weekday + 1
                    }
                    day = AgendaItem.getWeekday(for: weekday)
                    weekdayCount = weekdayCount + 1
                }

                cell.dateLabel?.text = day.rawValue
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        cell.timeLabel?.text = formatter.string(from: agendaItem.agendaTime)
        cell.hintLabel?.text = agendaItem.agendaDrug.InventoryItemNotes
        return cell
    }
    
    func agendaListDidUpdate (notification: Notification) {
        
        self.items = Agenda.instance.items!
        self.tableView.reloadData()
        
    }
    
    func getDayOfWeek(today:Date)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = today
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "AgendaDetail") {
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    
                    let selectedItem = items[index]
                    if let destination = segue.destination as? UINavigationController {
                        if let topDestination = destination.topViewController as? AgendaDetailTableViewController{
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
            self.observer = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil, queue: nil, using: agendaListDidUpdate)

        }
        
        self.items = Agenda.instance.items!
        tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        if let obs = self.observer {
            NotificationCenter.default.removeObserver(obs)
            self.observer = nil
        }

    }
    
    
    @IBAction func saveNewAgendaItem (segue : UIStoryboardSegue) {
        
        if let createAgendaController = segue.source as? CreateAgendaItemTableViewController {
            
            Agenda.instance.add(new: createAgendaController.agendaItem!)
            
        }
        
    }
    
    @IBAction func unwindAgendaItemDetail (segue : UIStoryboardSegue) {

        
    }
    
    @IBAction func cancelAgendaCreate (Segue : UIStoryboardSegue) {
        
        
    }

    
    @IBAction func deleteAgendaItem (segue : UIStoryboardSegue) {
        
        if let editAgendaController = segue.source as? AgendaEditController {
            
            Agenda.instance.delete(editAgendaController.item)
            
        }
        
    }
    
    

}
