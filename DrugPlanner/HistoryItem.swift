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
        static let DateAndTime = "dateAndTime"
        static let DrugName = "drugName"
        static let DrugType = "drugType"
        static let IntakenDose = "intakeDose"
        static let DrugConcentration = "drugConcentration"
        static let Notes = "notes"
        static let Taken = "taken"
        
    }
    
    var key : String!
    var dateAndTime : Date!
    var drugName : String!
    var drugType : String!
    var intakenDose : Int!
    var drugConcentration : Int!
    var notes : String!
    var taken : Bool!
    
    init(at dateAndTime : Date, for drugName : String, of drugType : String, with intakenDose : Int, having drugConcentration : Int, with notes : String, using key : String, takenOrNot taken:Bool) {
        
        self.key = key
        self.dateAndTime = dateAndTime
        self.drugName = drugName
        self.drugType = drugType
        self.intakenDose = intakenDose
        self.drugConcentration = drugConcentration
        self.notes = notes
        self.taken = taken
        
    }
    
    
    convenience init (withInventory inventory: InventoryItem, withIntakenDose intakenDose: Int, atDate date: Date, withNotes notes : String, usingKey key: String, takenOrNot taken : Bool) {
        
        self.init(at: date, for: inventory.InventoryItemName, of : inventory.InventoryItemType.rawValue, with : intakenDose, having: inventory.InventoryItemDose,  with: notes, using: key, takenOrNot: taken)
        
    }
    
    convenience init (withAgenda agenda: AgendaItem, atDate date: Date, withNotes notes: String, usingKey key: String, takenOrNot taken : Bool) {
        
        self.init(at: date, for: agenda.agendaDrug.InventoryItemName, of: agenda.agendaDrug.InventoryItemType.rawValue, with: agenda.agendaDose, having: agenda.agendaDrug.InventoryItemDose,  with: notes, using: key, takenOrNot: taken)

    }
    
    convenience init (withKey key : String, withParameters parameters : NSDictionary) {

        let date            =   Date(from: parameters[ItemKeys.DateAndTime] as! Int)
        let drugName        =   parameters[ItemKeys.DrugName]   as! String
        let drugType        =   parameters[ItemKeys.DrugType]      as! String
        let drugConcentration   =   parameters[ItemKeys.DrugConcentration]       as! Int
        let intakenDose = parameters[ItemKeys.IntakenDose]      as! Int
        let notes           =   parameters[ItemKeys.Notes]      as! String
        let takenOrNot = parameters [ItemKeys.Taken]      as! Bool
        
        self.init(at: date, for: drugName, of: drugType, with: intakenDose, having: drugConcentration, with: notes, using: key, takenOrNot: takenOrNot)
        
    }
    
    func toDictionary() -> NSDictionary {
        
        return [
            
            ItemKeys.DrugName   :   self.drugName,
            ItemKeys.DateAndTime       :   self.dateAndTime.transformToInt(),
            ItemKeys.DrugType : self.drugType,
            ItemKeys.IntakenDose :  self.intakenDose,
            ItemKeys.DrugConcentration       :   self.intakenDose,
            ItemKeys.Notes      :   self.notes,
            ItemKeys.Taken : self.taken
            
        ]
        
    }
    
    
   
}
