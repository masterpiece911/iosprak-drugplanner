//
//  Inventory.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 13.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class Inventory : RepositoryClass {
    
    static let instance = Inventory()
    
    static let inventoryKey = "Inventory"
    
    var items : [InventoryItem]? {
        willSet{
            if let items = self.items {
                if items.isEmpty {
                    self.didPopulate = true
                }
            }
        }
        didSet{
            items?.sort(by: {
                (lhs: InventoryItem, rhs: InventoryItem) in
                return lhs.InventoryItemExpiryDate.transformToInt() < rhs.InventoryItemExpiryDate.transformToInt()
            })

            NotificationCenter.default.post(name: Notification.Name(rawValue: InventoryStrings.INVENTORY_UPDATE), object: nil)
        }
    }
    
    var didPopulate : Bool = false {
        didSet {
            if didPopulate {
                NotificationCenter.default.post(name: Notification.Name(rawValue: InventoryStrings.INVENTORY_POPULATED), object: nil)
            }
        }
    }
    
    var inventoryReference : DatabaseReference?
    
    var databaseHandlers = [(DatabaseHandle,InventoryItem?)]()
    
    private init() {
    
        
    
    }
    
    func populate(from ref : DatabaseReference) {
        
        self.inventoryReference = ref.child("Users").child(User.instance.ID!).child(Inventory.inventoryKey)
        
        items = [InventoryItem]()
        
        if let handle = inventoryReference?.observe(.value, with: {
            
            (snapshot) in
            
            if snapshot.value != nil {
                
                var newItems = [InventoryItem]()
                
                if let inventoryDictionary = snapshot.value as? NSDictionary {
                    
                    for fItem in (inventoryDictionary) {
                        
                        let newItem = InventoryItem(with: fItem.key as! String, with: fItem.value as! NSDictionary)
                        
                        newItems.append(newItem)
                        
                    }
                    
                    self.items = newItems
                    
                }
                
                
                
            }
            
        }) {
            databaseHandlers.append((handle, nil))
        }

    }
    
    func purge() {
    
        items = nil
        for (handle,item) in databaseHandlers {
            if let ref = inventoryReference?.child((item?.InventoryItemKey)!){
                ref.removeObserver(withHandle: handle)
            } else {
                inventoryReference?.removeObserver(withHandle: handle)
            }
        }
        inventoryReference = nil
        didPopulate = false
    
    }
    
    func add(inventory item : InventoryItem) {
    
        inventoryReference?.childByAutoId().setValue(item.toDictionary())
        
    }
    
    func edit(inventory item : InventoryItem) {
        
        inventoryReference?.child(item.InventoryItemKey).setValue(item.toDictionary())
        
    }
    
    func remove(inventory item : InventoryItem) {
        
        for (handler, inventoryItem) in databaseHandlers {
            if inventoryItem?.InventoryItemKey == item.InventoryItemKey {
                stopListening(to: item, using: handler)
                break;
            }
        }
        inventoryReference?.child(item.InventoryItemKey).removeValue()
    }
    
    func listenToChanges(in item : InventoryItem) -> DatabaseHandle? {
        
        if let listener = inventoryReference?.child(item.InventoryItemKey).observe(.value, with: {
            
            (snapshot) in
            
            if let parameters = snapshot.value as? NSDictionary {
                
                let newItem = InventoryItem(with: snapshot.key, with: parameters)
                
                
                
                //self.items![self.items!.index(of: self.items!.getItem(with: item.InventoryItemKey)!)!] = newItem
                
                for (index, item) in self.items!.enumerated() {
                    if (newItem.InventoryItemKey == item.InventoryItemKey) {
                        self.items![index] = newItem
                    }
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: (InventoryStrings.ITEM_UPDATE.appending(item.InventoryItemKey))), object: newItem)
                
            }
            
        }) {
            
            databaseHandlers.append((listener,item))
            return listener
            
        }
        return nil
    }
    
    func stopListening(to item : InventoryItem, using handle : DatabaseHandle) {
        
        inventoryReference?.child(item.InventoryItemKey).removeObserver(withHandle: handle)
        databaseHandlers.remove(at: databaseHandlers.index(where: {
            
            (itemHandle, inventoryItem) in
            
            let handlesEqual = itemHandle == handle
            
            return handlesEqual
            
        })!)
        
    }
}
