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
    
    var databaseHandlers = [(DatabaseHandle, EventItem?)]()
    
    var agendaListener : NCListener?
    
    private init() {
        
    }
    
    func populate(from ref: DatabaseReference) {
        
        self.eventsReference = ref.child(User.instance.ID!).child(Events.eventsKey)
        
        items = [EventItem]()
        
        self.agendaListener = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: AgendaStrings.AGENDA_POPULATED), object: nil, queue: nil, using: agendaDidPopulate)
        
    }
    
    func purge() {
        
        // TODO
        print("events purged")
    }
    
    func agendaDidPopulate ( notification : Notification) {
        
        if let handle = eventsReference?.observe(.value, with: {
            (snapshot) in
            
            if snapshot.value != nil {
                
                var newItems = [EventItem]()
                
                if let eventDictionary = snapshot.value as? NSDictionary {
                    
                    for fItem in (eventDictionary) {
                        
                        let newItem = EventItem(fItem.key as! String, with: fItem.value as! NSDictionary)
                        
                        
                        
                    }
                    
                }
                
            }
            
            
        }) {
            databaseHandlers.append((handle, nil))
        }
        
    }
    
    typealias NCListener = NSObjectProtocol
}
