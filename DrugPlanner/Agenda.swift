//
//  Agenda.swift
//  DrugPlanner
//
//  Created by sahin on 16.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class Agenda : RepositoryClass {
    
    static let instance = Agenda()
    
    static let agendaKey = "Agenda"
    
    var items : [AgendaItem]? {
        didSet{
            // TODO: IMPLEMENT ORDER HERE
            NotificationCenter.default.post(name: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil)
        }
    }
    
    var agendaReference : DatabaseReference?
    
    private init() {
        
    }
    
    func populate(from ref: DatabaseReference) {
        
        self.agendaReference = ref.child("Users").child(User.instance.ID!).child(Agenda.agendaKey)
        
        items = [AgendaItem]()
        
        agendaReference?.observe(.value, with: {
            (snapshot) in
            
            if snapshot.value != nil {
                
                var newItems = [AgendaItem]()
                
                let agendaDictionary = snapshot.value as? NSDictionary
                
                for fItem in (agendaDictionary)! {
                    
                    let newItem = AgendaItem(with: fItem.key as! String, with: fItem.value as! NSDictionary)
                    
                    newItems.append(newItem)
                }
                
                self.items = newItems
                
            }
        })
    }
    
    func purge() {
        
        agendaReference?.removeAllObservers()
        items = nil
        agendaReference = nil
        
    }
    
    func add(new item: AgendaItem) {
        
        agendaReference?.childByAutoId().setValue(item.toDictionary())
        
    }
    
    func edit(_ item: AgendaItem) {
        
        agendaReference?.child(item.agendaKey).setValue(item.toDictionary())
        
    }
    
    func delete(_ item: AgendaItem) {
        
        agendaReference?.child(item.agendaKey).removeValue()
        
    }
    
}
