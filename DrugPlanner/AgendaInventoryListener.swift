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
    
    typealias NCListener = NSObjectProtocol
    
    var databaseHandle : DatabaseHandle?
    
    var ncListener : NCListener?
    
    var agendaItem : AgendaItem
    
    var inventoryItem : InventoryItem
    
    
    init(_ handle : DatabaseHandle, _ listener : NCListener, _ agendaItem : AgendaItem, _ inventoryItem : InventoryItem  ) {
        
        self.databaseHandle = handle
        self.ncListener = listener
        self.agendaItem = agendaItem
        self.inventoryItem = inventoryItem
        
    }
    
    func replaceListeners(with handle : DatabaseHandle, with listener : NCListener) {
        
        self.databaseHandle = handle
        self.ncListener = listener
        
    }
    
    func stopListening (){
        
        Inventory.instance.stopListening(to: self.inventoryItem, using: self.databaseHandle!)
        NotificationCenter.default.removeObserver(ncListener!)
        
        self.databaseHandle = nil
        self.ncListener = nil
        
    }
    
    
}
