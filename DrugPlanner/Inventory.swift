//
//  Inventory.swift
//  DrugPlanner
//
//  Created by Admin on 13.07.17.
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
                if items == [] {
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
    
    var databaseHandlers = [DatabaseHandle]()
    
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
            databaseHandlers.append(handle)
        }

    }
    
    func purge() {
    
        items = nil
        for handler in databaseHandlers {
            //TODO REMOVE OBSERVERS AT THE CORRECT CHILD ITEMS.
            inventoryReference?.removeObserver(withHandle: handler)
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
        
        inventoryReference?.child(item.InventoryItemKey).removeValue()
    }
    
    func listenToChanges(in item : InventoryItem) -> DatabaseHandle? {
        
        if let listener = inventoryReference?.child(item.InventoryItemKey).observe(.value, with: {
            
            (snapshot) in
            
            let newItem = InventoryItem(with: snapshot.key, with: snapshot.value as! NSDictionary)
            
            self.items![self.items!.index(of: self.items!.getItem(with: item.InventoryItemKey)!)!] = newItem
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: (InventoryStrings.ITEM_UPDATE.appending(item.InventoryItemKey))), object: nil)
            
            
        }) {
            
            databaseHandlers.append(listener)
            return listener
            
        }
        return nil
    }
    
    func stopListening(to item : InventoryItem, using handle : DatabaseHandle) {
        
        inventoryReference?.child(item.InventoryItemKey).removeObserver(withHandle: handle)
        databaseHandlers.remove(at: databaseHandlers.index(of: handle)!)
        
    }
}
