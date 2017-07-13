//
//  Repository.swift
//  DrugPlanner
//
//  Created by admin on 13.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class Repository {
    
    var ref : DatabaseReference!
    
    var inventory : [InventoryItem]?
    var agenda : [AgendaItem]?
    
    init(referencing ref : DatabaseReference) {
        
        self.ref = ref

        if (User.instance.ID != nil) {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: LoginStrings.USER_LOGGED_IN), object: nil)
            
        }
        
        
        
    }
}
