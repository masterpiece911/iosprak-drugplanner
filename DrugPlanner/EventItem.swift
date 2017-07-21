//
//  EventItem.swift
//  DrugPlanner
//
//  Created by admin on 21.07.17.
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
    
    var fireDate : Date
    
    var agenda : AgendaItem?
    
    var inventory : InventoryItem?
    
    var key : String
    
    var type : EventType
    
    
    init(_ type : EventType, on date : Date, from item : Any, using key : String) {
        
        self.fireDate = date
        self.key      = key
        self.type     = type
        
        switch(type) {
        case .AGENDA_REMINDER:
            self.agenda = item as? AgendaItem
            self.inventory = nil
        case .INVENTORY_EXPIRED, .INVENTORY_RANOUT:
            self.inventory = item as? InventoryItem
            self.agenda = nil
        }
        
    }
    
    init (_ key : String, with parameters : NSDictionary) {
        
        self.fireDate = Date.init(from: parameters[ItemKeys.date] as! Int)
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
        
        let dic = NSDictionary()
        dic.setValue(type.rawValue, forKey: ItemKeys.type)
        
        switch type {
        case .AGENDA_REMINDER:
            dic.setValue(self.agenda, forKey: ItemKeys.agenda)
            dic.setValue("", forKey: ItemKeys.inventory)
            
        case .INVENTORY_EXPIRED, .INVENTORY_RANOUT:
            dic.setValue(self.inventory, forKey: ItemKeys.inventory)
            dic.setValue("", forKey: ItemKeys.agenda)
            
        }
        
        dic.setValue(fireDate.transformToInt(), forKey: ItemKeys.date)
        
        return dic
    }
    
    
}
