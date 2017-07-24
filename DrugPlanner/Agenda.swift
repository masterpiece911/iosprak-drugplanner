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
        willSet{
            if let items = self.items {
                if items.isEmpty {
                    self.didPopulate = true
                }
            }
        }
        didSet{
            // TODO: IMPLEMENT ORDER HERE
            NotificationCenter.default.post(name: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil)
        }
    }
    
    var agendaReference : DatabaseReference?
    
    var databaseHandlers = [(DatabaseHandle, AgendaItem?)]()
    
    var inventoryListener : Any?
    
    var didPopulate : Bool = false {
        didSet {
            if didPopulate {
                NotificationCenter.default.post(name: Notification.Name(rawValue: AgendaStrings.AGENDA_POPULATED), object: nil)
            }
        }
    }
    
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
        NotificationCenter.default.removeObserver(inventoryListener!)
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
                        
                        var inventoryListener : AgendaInventoryListener
                        
                        if (self.inventoryItemListeners.containsAgenda(with: newItem.agendaKey)) {
                            inventoryListener = self.inventoryItemListeners.getListenerWithAgenda(with: newItem.agendaKey)!
                        } else {
                            inventoryListener = AgendaInventoryListener(newItem, newItem.agendaDrug)
                            self.inventoryItemListeners.append(inventoryListener)
                        }
                        
                        inventoryListener.stopListening()
                        
                        let drugHandle = Inventory.instance.listenToChanges(in: newItem.agendaDrug)
                        
                        let notificationHandle = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: (InventoryStrings.ITEM_UPDATE.appending(newItem.agendaDrug.InventoryItemKey))), object: nil, queue: nil, using: self.inventoryItemOfAgendaItemDidChange)
                        
                        inventoryListener.replaceListeners(with: drugHandle!, with: notificationHandle)
                        
                        newItems.append(newItem)
                        
                    }
                    
                    self.items = newItems
                                        
                }
                
                
            }
        }) {
            databaseHandlers.append((handle, nil))
        }

    }
    
    func add(new item: AgendaItem) {
        
        let itemKey = agendaReference?.childByAutoId().key
        agendaReference?.child(itemKey!).setValue(item.toDictionary())
        item.agendaKey = itemKey!
        
        Events.instance.add(EventItem(EventItem.EventType.AGENDA_REMINDER, for: item, using: itemKey!))
        
    }
    
    func edit(_ item: AgendaItem) {
        
        agendaReference?.child(item.agendaKey).setValue(item.toDictionary())
        if let agendaEvent = Events.instance.items?.getItem(with: item.agendaKey) {
            Events.instance.edit(agendaEvent)
        } else {
            Events.instance.add(EventItem(EventItem.EventType.AGENDA_REMINDER, for: item, using: item.agendaKey))
        }
        
    }
    
    func delete(_ item: AgendaItem) {
        
        agendaReference?.child(item.agendaKey).removeValue()
        if let agendaEvent = Events.instance.items?.getItem(with: item.agendaKey) {
            Events.instance.delete(agendaEvent)
        }
        
    }
    
    func inventoryItemOfAgendaItemDidChange (notification: Notification) {
        
        let notificationString = notification.name.rawValue
        let newInventoryItem = notification.object as! InventoryItem
        let inventoryItemKey = notificationString.replacingOccurrences(of: InventoryStrings.ITEM_UPDATE, with: "")
        for listener in inventoryItemListeners {
            if listener.inventoryItem.InventoryItemKey == inventoryItemKey {
                
                let newAgendaItem = listener.agendaItem
                //newAgendaItem?.agendaDrug = (Inventory.instance.items?.getItem(with: listener.inventoryItem.InventoryItemKey))!
                newAgendaItem.agendaDrug = newInventoryItem
                
                for (index, item) in self.items!.enumerated() {
                    if item.agendaKey == newAgendaItem.agendaKey {
                        items?[index] = newAgendaItem
                        break;
                    }
                }
                break
            }
        }
        
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
