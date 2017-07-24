//
//  Repository.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 13.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class Repository {
    
    var ref : DatabaseReference!
    
    var repositorySubclasses : [RepositoryClass]
    
    init(referencing ref : DatabaseReference) {
        
        self.ref = ref

        // SET ALL INSTANCES OF REPOSITORY CLASSES
        self.repositorySubclasses = [RepositoryClass]()
        
        let repositories : [RepositoryClass] = [
            Inventory.instance,
            Agenda.instance,
            Events.instance
        ]
        
        repositorySubclasses.append(contentsOf: repositories)
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LoginStrings.LOGIN_SUCCESS), object: nil, queue: nil, using: userDidLogIn)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: LoginStrings.LOGOUT_SUCCESS), object: nil, queue: nil, using: userDidLogOut)
        
        if (User.instance.ID != nil) {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: LoginStrings.USER_LOGGED_IN), object: nil)
            for subclass in repositorySubclasses {
                subclass.populate(from: self.ref)
            }
            
        }
        
        
        
    }
    
    func userDidLogIn(notification : Notification) {
        
        for subclass in repositorySubclasses {
            subclass.populate(from: self.ref)
        }
    }
    
    func userDidLogOut(notification: Notification) {
        
        for subclass in repositorySubclasses {
            subclass.purge()
        }
        
    }
}

protocol RepositoryClass {
        
    func populate(from ref : DatabaseReference)
    
    func purge()
}
