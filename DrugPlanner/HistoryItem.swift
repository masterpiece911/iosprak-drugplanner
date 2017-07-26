//
//  HistoryItem.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 23.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class HistoryItem {
    
    struct ItemKeys {
        
        static let Key = "key"
        static let Date = "date"
        static let Name = "name"
        static let Dose = "dose"
        static let Notes = "notes"
        
    }
    
    var key : String!
    var date : Date!
    var name : String!
    var dose : Int!
    var notes : String!
    
    init(for name : String, with dose : Int, at date : Date,with notes : String, using key : String) {
        
        self.key = key
        self.name = name
        self.dose = dose
        self.notes = notes
        self.date = date
        
    }
    
    convenience init (withInventory inventory: InventoryItem, withAmount amount: Int, atDate date: Date, withNotes notes : String, usingKey key: String) {
        
        self.init(for: inventory.InventoryItemName, with: inventory.InventoryItemDose, at: date, with: notes, using: key)
        
    }
    
    convenience init (withAgenda agenda: AgendaItem, atDate date: Date, withNotes notes: String, usingKey key: String) {
        
        self.init(for: agenda.agendaDrug.InventoryItemName, with: agenda.agendaDose, at: date, with: notes, using: key)

    }
    
    convenience init (withKey key : String, withParameters parameters : NSDictionary) {
        
        let name        =   parameters[ItemKeys.Name]   as! String
        let dose            =   parameters[ItemKeys.Dose]       as! Int
        let notes           =   parameters[ItemKeys.Notes]      as! String
        let date            =   Date(from: parameters[ItemKeys.Date] as! Int)
        
        self.init(for: name, with: dose, at: date, with: notes, using: key)
        
    }
    
    func toDictionary() -> NSDictionary {
        
        return [
        
            ItemKeys.Name   :   self.name,
            ItemKeys.Date       :   self.date.transformToInt(),
            ItemKeys.Dose       :   self.dose,
            ItemKeys.Notes      :   self.notes
            
        ]
        
    }
    
    
   
}
