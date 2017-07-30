//
//  Events.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 21.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

class Events : RepositoryClass {
    
    static let instance = Events()
    
    static let eventsKey = "Events"
    
    var items : [EventItem]? {
        didSet {
            Scheduler.instance.scheduleNotifications(for: self.items!)
        }
    }
    
    var eventsReference : DatabaseReference?
    
    var databaseHandlers = [(DatabaseHandle, EventItem?)]()
    
    var agendaListener : NCListener?
    
    private init() {
        
    }
    
    
    func populate(from ref: DatabaseReference) {
        
        self.eventsReference = ref.child("Users").child(User.instance.ID!).child(Events.eventsKey)
        
        items = [EventItem]()
        
        self.agendaListener = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: AgendaStrings.AGENDA_POPULATED), object: nil, queue: nil, using: agendaDidPopulate)
        
    }
    
    func purge() {
        
        // TODO
        items = nil
        for (handle,item) in databaseHandlers {
            if let ref = eventsReference?.child((item?.key)!) {
                ref.removeObserver(withHandle: handle)
            } else {
                eventsReference?.removeObserver(withHandle: handle)
            }
        }
        eventsReference = nil
        NotificationCenter.default.removeObserver(agendaListener!)
        agendaListener = nil

    }
    
    func agendaDidPopulate ( notification : Notification) {
        
        if let handle = eventsReference?.observe(.value, with: {
            (snapshot) in

            var newItems = [EventItem]()
            
            if snapshot.value != nil {
                
                if let eventDictionary = snapshot.value as? NSDictionary {
                    
                    for fItem in (eventDictionary) {
                        
                        let newItem = EventItem(fItem.key as! String, with: fItem.value as! NSDictionary)
                        
                        newItems.append(newItem)
                        
                    }
                    
                    let inventoryEventItems = newItems.filter(Events.filterInventoryExpiredEvents(elem:))
                    
                    for item in inventoryEventItems {
                        let newItem = self.addInventoryRanoutDate(intoInventoryEvent: item, fromItems: newItems)
                        newItems[newItems.index(where: {
                            oldItem in
                            
                            return oldItem.key == newItem.key
                        })!] = newItem
                    }
                    
                }
                
            }
            
            self.items = newItems
            
        }) {
            databaseHandlers.append((handle, nil))
        }
        
    }
    
    func add(_ item : EventItem) {
        
        eventsReference?.childByAutoId().setValue(item.toDictionary())
        
    }
    
    func edit (_ item : EventItem) {
        
        eventsReference?.child(item.key).setValue(item.toDictionary())
            
        
        
    }
    
    func delete (_ item : EventItem) {
        
        eventsReference?.child(item.key).removeValue()
        
    }
    
    func addInventoryRanoutDate(intoInventoryEvent event : EventItem, fromItems items : [EventItem]) -> EventItem {
        
        
        
        let agendaItemsForEvent = items.filter(Events.filterAgendaReminderEvents(elem:)).filter({
            element in
            return element.agenda?.agendaDrug.InventoryItemKey == event.inventory?.InventoryItemKey
        })
            let cal   = Calendar.current
            let today = Date()
            
            var dates = [(Date, Int)]()
            
            for agenda in agendaItemsForEvent {
                
                for component in agenda.dates {
                    
                    var nextDate : Date
                    
                    nextDate = cal.nextDate(after: today, matching: component, matchingPolicy: .strict)!
                    
                    while (nextDate < agenda.endDate!) {
                        dates.append((nextDate, (agenda.agenda?.agendaDose)!))
                        nextDate = cal.nextDate(after: nextDate, matching: component, matchingPolicy: .strict)!
                    }
                    
                }
                
            }
            
            dates.sort(by: {
                lhs, rhs in
                return lhs.0 < rhs.0
            })
            
            var noOfInventory = (event.inventory?.InventoryItemAmount)!, index = 0, datesLength = dates.count
            
            var inventoryPositive = true, moreInventoryThanDates = false
            
            while (inventoryPositive && !moreInventoryThanDates) {
                if (!(index < datesLength)) {
                    moreInventoryThanDates = true
                } else if (noOfInventory <= 0) {
                    inventoryPositive = false
                } else {
                    noOfInventory -= dates[index].1
                    index += 1
                }
                
            }
            
            if (!moreInventoryThanDates) {
                
                var dateOfRunOut = cal.dateComponents([.year,.month,.day], from: dates[index-1].0)
                dateOfRunOut.hour = 8
                
                
                event.dates.append(dateOfRunOut)
                
            } else if (event.dates.count > 1) {
                while event.dates.count != 1 {
                    let _ = event.dates.popLast()
                }
            }
            
            return event
        
    }
    
    // STATIC HELPER SORTING FUNCTIONS
    
    static func eventKeysAreInIncreasingOrder(lhs: EventItem, rhs: EventItem) -> Bool {
        return lhs.key < rhs.key
    }
    
    static func eventDatesAreInIncreasingOrder(lhs: EventItem, rhs: EventItem) -> Bool {
        return lhs.getEarliestDate() < rhs.getEarliestDate()
    }

    static func filterAgendaReminderEvents(elem: EventItem) -> Bool {
        return elem.type == EventItem.EventType.AGENDA_REMINDER
    }
    
    static func filterInventoryExpiredEvents(elem: EventItem) -> Bool {
        return elem.type == EventItem.EventType.INVENTORY_EXPIRED
    }
    
    static func filterInventoryRanoutEvents(elem: EventItem) -> Bool {
        return elem.type == EventItem.EventType.INVENTORY_RANOUT
    }
    
    static func getListOfUniqueEventItemKeys (fromEventList eventList: [EventItem]) -> Set<String>{
        
        var addedList = Set<String>()
        
        for element in eventList {
            
            if !addedList.contains(element.key) {
                addedList.insert(element.key)
            }
            
        }
        
        return addedList
        
    }
    
    // TYPEALIAS
    
    typealias NCListener = NSObjectProtocol
    
    typealias FirebaseKey = String
}

extension Array where Element : EventItem {
    
    func getItem (with key : String) -> EventItem? {
        
        for item in self {
            
            if item.key == key {
                return item
            }
            
        }
        
        return nil
        
    }
    
    func getItem (withAgenda key : String) -> EventItem? {
        
        for item in self.filter(Events.filterAgendaReminderEvents(elem:)) {
            
            if item.agenda?.agendaKey == key {
                return item
            }
            
        }
        
        return nil
        
    }
    
    func getItem (withInventory key : String) -> EventItem? {
        
        for item in self.filter(Events.filterInventoryExpiredEvents(elem:)) {
            
            if item.inventory?.InventoryItemKey == key {
                return item
            }
            
        }
        
        return nil
        
    }
    
}
