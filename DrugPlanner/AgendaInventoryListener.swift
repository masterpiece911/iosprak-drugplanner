//
//  AgendaInventoryListener.swift
//  DrugPlanner
//
//  Created by admin on 18.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class AgendaInventoryListener {
    
    typealias NCObserver = NSObjectProtocol
    
    var databaseHandle : DatabaseHandle?
    
    var ncListener : NCObserver?
    
    var agendaItem : AgendaItem
    
    var inventoryItem : InventoryItem
    
    
    init(_ handle : DatabaseHandle, _ listener : NCObserver, _ agendaItem : AgendaItem, _ inventoryItem : InventoryItem  ) {
        
        self.databaseHandle = handle
        self.ncListener = listener
        self.agendaItem = agendaItem
        self.inventoryItem = inventoryItem
        
    }
    
    init(_ agendaItem : AgendaItem, _ inventoryItem : InventoryItem) {
        self.agendaItem = agendaItem
        self.inventoryItem = inventoryItem
        self.databaseHandle = nil
        self.ncListener = nil
    }
    
    func replaceListeners(with handle : DatabaseHandle, with listener : NCObserver) {
        
        self.databaseHandle = handle
        self.ncListener = listener
        
    }
    
    func stopListening (){
        
        if let handle = self.databaseHandle, let listener = self.ncListener {
            Inventory.instance.stopListening(to: self.inventoryItem, using: handle)
            NotificationCenter.default.removeObserver(listener)
        }
        
        self.databaseHandle = nil
        self.ncListener = nil
        
    }
    
    
}
