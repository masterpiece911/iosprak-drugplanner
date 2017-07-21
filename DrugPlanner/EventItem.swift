//
//  EventItem.swift
//  DrugPlanner
//
//  Created by admin on 21.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation

class EventItem {
    
    enum type : String {
        case INVENTORY_EXPIRED
        case INVENTORY_RANOUT
        case AGENDA_REMINDER
    }
    
    var fireDate : Date
    
    var agenda : AgendaItem
    
    var key : String
    
    
    init(on date : Date, from agenda : AgendaItem, using key : String) {
        
        self.fireDate = date
        self.agenda   = agenda
        self.key      = key
        
    }
    
    
}
