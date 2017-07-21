//
//  Events.swift
//  DrugPlanner
//
//  Created by admin on 21.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class Events : RepositoryClass {
    
    static let instance = Events()
    
    static let eventsKey = "Events"
    
    var items : [EventItem]? {
        didSet {
            
        }
    }
    
    var eventsReference : DatabaseReference?
    
    var databaseHandlers = [(DatabaseHandle, EventItem)]()
    
    private init() {
        
    }
    
    func populate(from ref: DatabaseReference) {
        
        //TODO
        print("events populated")
        
    }
    
    func purge() {
        
        // TODO
        print("events purged")
    }
}
