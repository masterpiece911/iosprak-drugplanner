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
            
            if snapshot.value != nil {
                
                var newItems = [EventItem]()
                
                if let eventDictionary = snapshot.value as? NSDictionary {
                    
                    for fItem in (eventDictionary) {
                        
                        let newItem = EventItem(fItem.key as! String, with: fItem.value as! NSDictionary)
                        
                        newItems.append(newItem)
                        
                    }
                    
                    self.items = newItems
                    
                }
                
            }
            
            
        }) {
            databaseHandlers.append((handle, nil))
        }
        
    }
    
    func add(_ item : EventItem) {
        
        
        eventsReference?.child(item.key).setValue(item.toDictionary())
        
    }
    
    func edit (_ item : EventItem) {
        
        eventsReference?.child(item.key).setValue(item.toDictionary())
        
    }
    
    func delete (_ item : EventItem) {
        
        eventsReference?.child(item.key).removeValue()
        
    }
    
    
    // STATIC HELPER SORTING FUNCTIONS
    
    static func eventKeysAreInIncreasingOrder(lhs: EventItem, rhs: EventItem) -> Bool {
        return lhs.key < rhs.key
    }
    
    static func eventDatesAreInIncreasingOrder(lhs: EventItem, rhs: EventItem) -> Bool {
        return lhs.getEarliestDate() < rhs.getEarliestDate()
    }
    
    static func notificationRequestIdentifiersAreInIncreasingOrder(lhs: UNNotificationRequest, rhs: UNNotificationRequest) -> Bool {
        return lhs.identifier < rhs.identifier
    }
    
    static func notificationRequestDatesAreInIncreasingOrder(lhs: UNNotificationRequest, rhs: UNNotificationRequest) -> Bool {
        let rightTrigger = rhs.trigger as? UNCalendarNotificationTrigger
        let leftTrigger = lhs.trigger as? UNCalendarNotificationTrigger
        return (rightTrigger?.nextTriggerDate())! < (leftTrigger?.nextTriggerDate())!
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
    
}
