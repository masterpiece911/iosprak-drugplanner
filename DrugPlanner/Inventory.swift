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
                    }
        didSet{
            items?.sort(by: {
                (lhs: InventoryItem, rhs: InventoryItem) in
                return lhs.InventoryItemExpiryDate.transformToInt() < rhs.InventoryItemExpiryDate.transformToInt()
            })

            NotificationCenter.default.post(name: Notification.Name(rawValue: InventoryStrings.INVENTORY_UPDATE), object: nil)
        }
    }
    
    var inventoryReference : DatabaseReference?
    
    private init() {
    
        
    
    }
    
    func populate(from ref : DatabaseReference) {
        
        self.inventoryReference = ref.child("Users").child(User.instance.ID!).child(Inventory.inventoryKey)
        
        items = [InventoryItem]()
        
        inventoryReference?.observe(.value, with: {
            
            (snapshot) in
            
            if snapshot.value != nil {
                
                var newItems = [InventoryItem]()
            
                let inventoryDictionary = snapshot.value as? NSDictionary
                
                for fItem in (inventoryDictionary)! {
                    
                    let newItem = InventoryItem(with: fItem.key as! String, with: fItem.value as! NSDictionary)
            
                    newItems.append(newItem)
            
                }
                
                self.items = newItems
            
            }
        
        })

    }
    
    func purge() {
    
        items = nil
        inventoryReference?.removeAllObservers()
        inventoryReference = nil
    
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
}
