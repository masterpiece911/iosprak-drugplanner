//
//  AgendaViewController.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 07.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit

class AgendaViewController: UITableViewController {

    struct TimeIntervals {
        
        static func HALF_HOUR(event : (Date, EventItem)) -> Bool {
            return Date().addingTimeInterval(-1 * 60 * 30) <= event.0 && event.0 <= Date().addingTimeInterval(60 * 30)
        }
        static func TWO_HOURS(event : (Date, EventItem)) -> Bool {
            return Date().addingTimeInterval(60 * 30) <= event.0 && event.0 <= Date().addingTimeInterval(60 * 60 * 2)
        }
        static func SIX_HOURS(event : (Date, EventItem)) -> Bool {
            return Date().addingTimeInterval(60 * 60 * 2) <= event.0 && event.0 <= Date().addingTimeInterval(60 * 60 * 6)
        }
        static func TODAY(event : (Date, EventItem)) -> Bool {
            return Calendar.current.isDateInToday(event.0)
        }
        static func TOMORROW(event : (Date, EventItem)) -> Bool {
            return Calendar.current.isDateInTomorrow(event.0)
        }
        
    }
    
    var items : [AgendaItem] = [AgendaItem]()
    var events = [(Date, EventItem)] ()
    
    var allSections : [[(Date, EventItem)]] = []
    
    var sectionHeaders : [String] = []

    var agendaObserver : Any?
    var eventsObserver : Any?
    
    var dateF : DateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = Agenda.instance.items!
        events = Scheduler.instance.allEvents
        dateF = DateFormatter()
        dateF.dateStyle = .none
        dateF.timeStyle = .short
        self.agendaObserver = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil, queue: nil, using: agendaListDidUpdate)
        self.eventsObserver = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: EventStrings.EVENT_UPDATE), object: nil, queue: nil, using: eventListDidUpdate)
        setUpSections()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func agendaListDidUpdate (notification: Notification) {
        
        self.items = Agenda.instance.items!
        self.tableView.reloadData()
        
    }
    
    func eventListDidUpdate (notification: Notification) {
        
        self.events = Scheduler.instance.allEvents.filter({
            _, eventItem in
            return eventItem.type == .AGENDA_REMINDER
        })
        setUpSections()
        self.tableView.reloadData()
        
    }
    
    func setUpSections() {
        
        let dateF = DateFormatter()
        dateF.dateStyle = .long
        dateF.timeStyle = .none
                
        self.allSections = []
        self.sectionHeaders = []
        
        let section0 = self.events.filter(TimeIntervals.HALF_HOUR(event:))
        
        if(!section0.isEmpty) {
            self.allSections.append(section0)
            self.sectionHeaders.append( "Take now: ")
        }
        
        let section1 = self.events.filter(TimeIntervals.TWO_HOURS(event:))
        
        if(!section1.isEmpty) {
            self.allSections.append(section1)
            self.sectionHeaders.append("In the next two hours: ")
        }
        
        let section2 = self.events.filter(TimeIntervals.SIX_HOURS(event:))
        
        if(!section2.isEmpty) {
            self.allSections.append(section2)
            self.sectionHeaders.append("In the next six hours: ")
        }
        
        let allPreviousSections = [section0, section1, section2].flatMap { $0 }
        
        let section3 = self.events.filter(TimeIntervals.TODAY(event:)).filter({
            element in
            return !allPreviousSections.contains(where: {
                otherElement in
                return element.0 == otherElement.0 && element.1.key == otherElement.1.key
            })
        })
        
        if(!section3.isEmpty) {
            self.allSections.append(section3)
            self.sectionHeaders.append("Today: ")
        }
        
        let section4 = self.events.filter(TimeIntervals.TOMORROW(event:))
        
        if(!section4.isEmpty) {
            self.allSections.append(section4)
            self.sectionHeaders.append("Tomorrow: ")
        }
        let sectionsBeforeLater = [allPreviousSections, section3, section4].flatMap { $0 }
        let section5 = self.events.filter({
            element in
            return !sectionsBeforeLater.contains(where: {
                otherElement in
                return element.0 == otherElement.0 && element.1.key == otherElement.1.key
            })
        })
        
        if(!section5.isEmpty) {
            self.allSections.append(section5)
            self.sectionHeaders.append("Later: ")
        }

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.allSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.allSections[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaCell", for: indexPath) as! AgendaTableViewCell
        
        let event = allSections[indexPath.section][indexPath.row]
        
        let rightNow = Date()
        
        if(event.0 > rightNow.addingTimeInterval(60 * 30)) {
            cell.backgroundColor = UIColor.clear
        } else {
            let difference = event.0.timeIntervalSince(rightNow)
            let ratio = 1 - (difference / TimeInterval(60 * 30))
            var color = UIColor.yellow
            color = color.withAlphaComponent(CGFloat(ratio))
            cell.backgroundColor = color
        }
        
        let agendaItem = event.1.agenda!
        
        if String(agendaItem.agendaDrug.InventoryItemPhoto) != "" {
            cell.drugImage?.image = agendaItem.agendaDrug.convertStringToImage(photoAsString: agendaItem.agendaDrug.InventoryItemPhoto)
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        cell.nameLabel?.text = agendaItem.agendaDrug.InventoryItemName
        cell.timeLabel?.text = formatter.string(from: event.0)
        cell.hintLabel?.text = agendaItem.agendaDrug.InventoryItemNotes
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.dateLabel.text = formatter.string(from: event.0).appending(",")

        return cell
        
    }

    
    func getDayOfWeek(today:Date)->Int {
        
        let todayDate = today
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "AgendaDetail") {
            
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    
                    let selectedItem = allSections[indexPath!.section][index]
                    if let destination = segue.destination as? UINavigationController {
                        if let topDestination = destination.topViewController as? AgendaDetailTableViewController{
                            topDestination.item = selectedItem.1.agenda
                        }
                    }
                }
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.agendaObserver == nil {
            self.agendaObserver = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil, queue: nil, using: agendaListDidUpdate)
        }
        
        self.items = Agenda.instance.items!
        
        if self.eventsObserver == nil {
            self.eventsObserver = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: EventStrings.EVENT_UPDATE), object: nil, queue: nil, using: eventListDidUpdate)
        }
        
        self.events = Scheduler.instance.allEvents.filter({
            _, eventItem in
            return eventItem.type == .AGENDA_REMINDER
        })
        
        setUpSections()
        tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        if let agObs = self.agendaObserver,
            let evObs = self.eventsObserver {
            NotificationCenter.default.removeObserver(agObs)
            NotificationCenter.default.removeObserver(evObs)
        }
        self.agendaObserver = nil
        self.eventsObserver = nil
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
