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
    
    var databaseHandlers = [(DatabaseHandle, AgendaItem?)]()
    
    var inventoryListener : Any?
    
    var inventoryItemListeners = [AgendaInventoryListener]()
    
    private init() {
        
    }
    
    func populate(from ref: DatabaseReference) {
        
        self.agendaReference = ref.child("Users").child(User.instance.ID!).child(Agenda.agendaKey)
        
        items = [AgendaItem]()
        
        inventoryListener = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: InventoryStrings.INVENTORY_POPULATED), object: nil, queue: nil, using: inventoryDidPopulate)
        
    }
    
    func purge() {
        
        items = nil
        for (handle,item) in databaseHandlers {
            if let ref = agendaReference?.child((item?.agendaKey)!) {
                ref.removeObserver(withHandle: handle)
            } else {
                agendaReference?.removeObserver(withHandle: handle)
            }
        }
        agendaReference = nil
        inventoryListener = nil
        
    }
    
    func inventoryDidPopulate (notification: Notification) {
        
        if let handle = agendaReference?.observe(.value, with: {
            (snapshot) in
            
            if snapshot.value != nil {
                
                var newItems = [AgendaItem]()
                
                if let agendaDictionary = snapshot.value as? NSDictionary {
                    
                    for fItem in (agendaDictionary) {
                        
                        let newItem = AgendaItem(with: fItem.key as! String, with: fItem.value as! NSDictionary)
                        
                        let drugHandler = Inventory.instance.listenToChanges(in: newItem.agendaDrug)
                        
                        let notificationHandle = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: (InventoryStrings.ITEM_UPDATE.appending(newItem.agendaDrug.InventoryItemKey))), object: nil, queue: nil, using: self.inventoryItemOfAgendaItemDidChange)
                        
                        newItems.append(newItem)
                        
                        if self.inventoryItemListeners.containsAgenda(with: newItem.agendaKey) {
                            
                            self.inventoryItemListeners.getListenerWithAgenda(with: newItem.agendaKey)?.replaceListeners(with: drugHandler!, with: notificationHandle)
                            
                        } else {
                            
                            self.inventoryItemListeners.append(AgendaInventoryListener.init(drugHandler!, notificationHandle, newItem, newItem.agendaDrug))
                            
                        }
                        
                    }
                    
                    self.items = newItems
                    
                    
                }
                
                
            }
        }) {
            databaseHandlers.append((handle, nil))
        }

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
    
    func inventoryItemOfAgendaItemDidChange (notification: Notification) {
        
        let notificationString = notification.name.rawValue
        let inventoryItemKey = notificationString.replacingOccurrences(of: InventoryStrings.ITEM_UPDATE, with: "")
        var newAgendaItem : AgendaItem?
        for listener in inventoryItemListeners {
            if listener.inventoryItem.InventoryItemKey == inventoryItemKey {
                
                newAgendaItem = listener.agendaItem
                newAgendaItem?.agendaDrug = (Inventory.instance.items?.getItem(with: listener.inventoryItem.InventoryItemKey))!
                
            }
        }

        NotificationCenter.default.post(name: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil)
        
    }
    
}

extension Array where Element : AgendaInventoryListener {
    
    func containsAgenda(with key: String) -> Bool {
        
        for listener in self {
            if listener.agendaItem.agendaKey == key {
                return true
            }
        }
        
        return false
        
    }
    
    func getListenerWithAgenda(with key: String) -> Element? {
        
        for listener in self {
            if listener.agendaItem.agendaKey == key {
                return listener
            }
        }
        
        return nil
        
    }
    
}
