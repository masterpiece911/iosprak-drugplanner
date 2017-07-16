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
    
    var inventory : Inventory
    
    init(referencing ref : DatabaseReference) {
        
        self.ref = ref

        self.inventory = Inventory.instance
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LoginStrings.LOGIN_SUCCESS), object: nil, queue: nil, using: userDidLogIn)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LoginStrings.LOGOUT_SUCCESS), object: nil, queue: nil, using: userDidLogOut)
        
        if (User.instance.ID != nil) {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: LoginStrings.USER_LOGGED_IN), object: nil)
            
        }
        
        
        
    }
    
    func userDidLogIn(notification : Notification) {
        
        inventory.populate(from: self.ref)
        
    }
    
    func userDidLogOut(notification: Notification) {
        
        inventory.purge()
        
    }
}

protocol RepositoryClass {
        
    func populate(from ref : DatabaseReference)
    
    func purge()
}
