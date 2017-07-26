//
//  History.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 25.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class History : RepositoryClass {
    
    static let instance = History()
    
    static let historyKey = "History"
    
    var items : [HistoryItem]? {
        willSet {
            if let items = self.items {
                if items.isEmpty {
                    self.didPopulate = true
                }
            }
        }
        didSet {
            items?.sort(by: History.historyDatesAreInIncreasingOrder(lhs:rhs:))
        }
    }
    
    var didPopulate : Bool = false {
        didSet {
            if didPopulate {
                NotificationCenter.default.post (name: Notification.Name(rawValue: HistoryStrings.HISTORY_POPULATED), object: nil)
            }
        }
    }
    
    var historyReference : DatabaseReference?
    
    var databaseHandlers = [(DatabaseHandle, HistoryItem?)]()
    
    private init() { }
    
    func populate(from ref: DatabaseReference) {
        
        self.historyReference = ref.child("Users").child(User.instance.ID!).child(History.historyKey)
        
        items = [HistoryItem]()
        
        if let handle = historyReference?.observe(.value, with: {
            
            (snapshot) in
            
            var newItems = [HistoryItem]()
            
            if snapshot.value != nil {
                
                if let historyDictionary = snapshot.value as? NSDictionary {
                    
                    for fItem in (historyDictionary) {
                        
                        let newItem = HistoryItem(withKey: fItem.key as! String, withParameters: fItem.value as! NSDictionary)
                        
                        newItems.append(newItem)
                        
                    }
                    
                }
                
            }
            
            self.items = newItems
            
        }) {
            databaseHandlers.append((handle, nil))
        }
    }
    
    func purge() {
        
        items = nil
        for (handle, item) in databaseHandlers {
            if let ref = historyReference?.child((item?.key)!) {
                ref.removeObserver(withHandle: handle)
            } else {
                historyReference?.removeObserver(withHandle: handle)
            }
        }
        
        historyReference = nil
        didPopulate = false
        
    }
    
    func add(historyItem item : HistoryItem) {
        
        historyReference?.childByAutoId().setValue(item.toDictionary())
        
    }
    
    func edit(historyItem item : HistoryItem) {
        
        historyReference?.child(item.key).setValue(item.toDictionary())
        
    }
    
    func remove(historyItem item : HistoryItem) {
        
        for (handler, historyItem) in databaseHandlers {
            if historyItem?.key == item.key {
                stopListening(to: item, using: handler)
                break
            }
        }
        historyReference?.child(item.key).removeValue()
        
    }
    
    func listenToChanges (in item : HistoryItem) -> DatabaseHandle? {
        
        if let listener = historyReference?.child(item.key).observe(.value, with: {
            
            (snapshot) in
            
            if let parameters = snapshot.value as? NSDictionary {
                
                let newItem = HistoryItem(withKey: snapshot.key, withParameters: parameters)
                
                for (index, item) in self.items!.enumerated() {
                    if (newItem.key == item.key) {
                        self.items![index] = newItem
                    }
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: (HistoryStrings.ITEM_UPDATE.appending(item.key))), object: newItem)
                
            }
            
        }) {
            
            databaseHandlers.append((listener,item))
            return listener
            
        }
        return nil
    }
    
    func stopListening (to item : HistoryItem, using handle : DatabaseHandle) {
        
        historyReference?.child(item.key).removeObserver(withHandle: handle)
        databaseHandlers.remove(at: databaseHandlers.index(where: {
           
            (itemHandle, historyItem) in
            
            let handlesEqual = itemHandle == handle
            
            return handlesEqual
            
        })!)
        
    }
    
    
    
    // STATIC HELPER SORTING FUNCTIONS
    
    static func historyDatesAreInIncreasingOrder (lhs: HistoryItem, rhs: HistoryItem) -> Bool {
        return lhs.date < rhs.date
    }
    
}
