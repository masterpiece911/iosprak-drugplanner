//
//  EventItem.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 21.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation

class EventItem {
    
    enum EventType : String {
        case INVENTORY_EXPIRED
        case INVENTORY_RANOUT
        case AGENDA_REMINDER
    }
    
    struct ItemKeys {
        
        static let date = "date"
        static let key = "key"
        static let type = "type"
        static let inventory = "inventory"
        static let agenda = "agenda"
        
    }
    
    struct DCKeys {
        
        static let year = "year"
        static let month = "month"
        static let day = "day"
        static let hour = "hour"
        static let minute = "minute"
        static let weekday = "weekday"
        
    }
    
    var dates : [DateComponents]
    
    var endDate : Date?
    
    var agenda : AgendaItem?
    
    var inventory : InventoryItem?
    
    var key : String
    
    var type : EventType
    
    
    convenience init(_ type : EventType, from item : Any, using key : String) {
        
        switch(type) {
        case .AGENDA_REMINDER:
            self.init(.AGENDA_REMINDER, for: item as! AgendaItem, using: key)
        case .INVENTORY_EXPIRED, .INVENTORY_RANOUT:
            self.init(type, for: item as! InventoryItem, using: key)
        }
        
    }
    
    init(_ type : EventType, for agenda : AgendaItem, using key : String) {
        
        self.key = key
        
        self.type = type
        
        self.dates = [DateComponents]()
        
        self.agenda = agenda
        
        self.endDate = agenda.agendaEndDate
        
        let cal = Calendar(identifier: .gregorian)
        
        for value in agenda.agendaWeekdays {
            
            if (value.value) {
                
                var dateComponent = DateComponents()
                
                dateComponent.weekday = AgendaItem.getInteger(for: value.key)
                
                dateComponent.hour = cal.component(.hour, from: agenda.agendaTime)
                
                dateComponent.minute = cal.component(.minute, from: agenda.agendaTime)
                
                self.dates.append(dateComponent)
                
                
            }
            
        }
        
    }
    
    init(_ type : EventType, for inventory : InventoryItem, using key : String) {
        
        self.key = key
        self.type = type
        self.dates = [DateComponents]()
        
        self.inventory = inventory
        
        let cal = Calendar(identifier: .gregorian)
        
        let dateComponent = cal.dateComponents([.year, .month, .day], from: inventory.InventoryItemExpiryDate)
        
        self.dates.append(dateComponent)
        
    }
    
    init (_ key : String, with parameters : NSDictionary) {
        
        self.dates = (parameters[ItemKeys.date] as! [NSDictionary]).toDateComponents()
        self.type = EventType(rawValue: parameters[ItemKeys.type] as! String)!
        switch (type) {
        case .AGENDA_REMINDER:
            self.agenda = Agenda.instance.items?.getAgenda(with: parameters[ItemKeys.agenda] as! String)
            self.inventory = nil
        case .INVENTORY_EXPIRED, .INVENTORY_RANOUT:
            self.inventory = Inventory.instance.items?.getItem(with: parameters[ItemKeys.inventory] as! String)
            self.agenda = nil
        }
        
        self.key      = key
        
    }
    
    func toDictionary() -> NSDictionary {
        
        var dic = Dictionary<String, Any>()
        dic[ItemKeys.type] = type.rawValue
        
        
        switch type {
        case .AGENDA_REMINDER:
            dic[ItemKeys.agenda] = self.agenda?.agendaKey
            dic[ItemKeys.inventory] = ""
        case .INVENTORY_EXPIRED, .INVENTORY_RANOUT:
            dic[ItemKeys.inventory] = self.inventory?.InventoryItemKey
            dic[ItemKeys.agenda] = ""
        }
        
        dic[ItemKeys.date] = self.dates.toNSDictionary()
        
        return dic as NSDictionary
        
    }
    
    func getEarliestDate() -> Date {
        
        let cal = Calendar(identifier: .gregorian)
        var dates = [Date]()
        
        for component in self.dates {
            
            let date = cal.nextDate(after: Date(), matching: component, matchingPolicy: .strict)
            dates.append(date!)
            
        }
        
        return dates.min()!
        
    }
    
}

extension Array where Element : NSDictionary {
    
    func toDateComponents() -> [DateComponents] {
        
        var dcArray = [DateComponents]()
        
        for component in self {
            
            var fDateComponent = DateComponents()
            
            fDateComponent.year = component.value(forKey: EventItem.DCKeys.year) as? Int
            fDateComponent.month = component.value(forKey: EventItem.DCKeys.month) as? Int
            fDateComponent.day = component.value(forKey: EventItem.DCKeys.day) as? Int
            fDateComponent.weekday = component.value(forKey: EventItem.DCKeys.weekday) as? Int
            fDateComponent.hour = component.value(forKey: EventItem.DCKeys.hour) as? Int
            fDateComponent.minute = component.value(forKey: EventItem.DCKeys.minute) as? Int
            
            dcArray.append(fDateComponent)
            
        }
        
        return dcArray

    }
    
}

extension Array where Element == DateComponents {
    
    func toNSDictionary () -> [NSDictionary] {
        
        var componentArray = [NSDictionary]()
        
        for component in self {
            
                var fDictionary = Dictionary<String, Any>()
                
                if let year = component.year {
                    fDictionary[EventItem.DCKeys.year] = year
                }
                if let month = component.month {
                    fDictionary[EventItem.DCKeys.month] = month
                }
                if let day = component.day {
                    fDictionary[EventItem.DCKeys.day] = day
                }
                if let weekday = component.weekday {
                    fDictionary[EventItem.DCKeys.weekday] = weekday
                }
                if let hour = component.hour {
                    fDictionary[EventItem.DCKeys.hour] = hour
                }
                if let minute = component.minute {
                    fDictionary[EventItem.DCKeys.minute] = minute
                }
            
                componentArray.append(fDictionary as NSDictionary)
            
        }
        
        return componentArray

    }
    
}
