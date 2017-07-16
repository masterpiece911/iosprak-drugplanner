//
//  File.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class InventoryItem: NSObject, NSCoding {
    

    
    struct ItemKeys{
        static let Key = "key";
        static let Name = "name";
        static let ItemType = "type";
        static let Amount = "amount";
        static let Dose = "dose";
        static let ExpiryDate = "expiryDate";
        static let Notes = "notes";
        static let Photo = "photo";
    }
    
    private var key : String!
    private var name : String!
    private var type : DrugType!
    private var amount : Int!
    private var dose : Int!
    private var expiryDate : Date!
    private var notes : String!
    private var photo : UIImage?
    
    override init() {}
    
    init(key: String, name: String, type: DrugType, amount: Int, dose: Int, expiryDate: Date, notes: String){
        self.key = key;
        self.name = name;
        self.type = type;
        self.amount = amount;
        self.dose = dose;
        self.expiryDate = expiryDate;
        self.notes = notes;
    }
    
    init(with inventoryItem : Dictionary<String, Any>.Iterator.Element) {
        
        let parameters = inventoryItem.value as! NSDictionary
        
        
        self.key        = inventoryItem.key
        self.name       = parameters[ItemKeys.Name]! as! String
        self.type       = DrugType(rawValue: parameters[ItemKeys.ItemType]! as! String)
        self.amount     = parameters[ItemKeys.Amount] as! Int
        self.dose       = parameters[ItemKeys.Dose] as! Int
        self.expiryDate = Date(from: parameters[ItemKeys.ExpiryDate]! as! Int)
        self.notes      = parameters[ItemKeys.Notes] as! String
        
    }
    
    func toDictionary() -> NSDictionary {
        
        return [
            ItemKeys.Name       : self.name ,
            ItemKeys.Amount     : self.amount ,
            ItemKeys.Dose       : self.dose ,
            ItemKeys.ExpiryDate : self.expiryDate.transformToInt() ,
            ItemKeys.ItemType   : self.type.rawValue ,
            ItemKeys.Notes      : self.notes
        ]
    }
    
    required init?(coder decoder: NSCoder) {
        if let keyObj = decoder.decodeObject(forKey: ItemKeys.Key)
            as? String {
            key = keyObj;
        }
        if let nameObj = decoder.decodeObject(forKey: ItemKeys.Name)
            as? String {
            name = nameObj;
        }
        if let typeObj = decoder.decodeObject(forKey: ItemKeys.ItemType)
            as? DrugType {
            type = typeObj;
        }
        if let amountObj = decoder.decodeObject(forKey: ItemKeys.Amount)
            as? Int {
            amount = amountObj;
        }
        if let doseObj = decoder.decodeObject(forKey: ItemKeys.Dose)
            as? Int {
            dose = doseObj;
        }
        if let expiryDateObj = decoder.decodeObject(forKey: ItemKeys.ExpiryDate)
            as? Date {
            expiryDate = expiryDateObj;
        }
        if let notesObj = decoder.decodeObject(forKey: ItemKeys.Notes)
            as? String {
            notes = notesObj;
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: ItemKeys.Name);
        coder.encode(type, forKey: ItemKeys.ItemType);
        coder.encode(amount, forKey: ItemKeys.Amount);
        coder.encode(dose, forKey: ItemKeys.Dose);
        coder.encode(expiryDate, forKey: ItemKeys.ExpiryDate);
        coder.encode(notes, forKey: ItemKeys.Notes);

    }
    
    var InventoryItemKey: String {
        get{
            return key;
        }
        set{
            key = newValue;
        }
    }
    
    var InventoryItemName: String {
        get{
            return name;
        }
        set{
            name = newValue;
        }
    }
    
    var InventoryItemType: DrugType {
        get{
            return type;
        }
        set{
            type = newValue;
        }
    }
    
    var InventoryItemAmount: Int {
        get{
            return amount;
        }
        set{
            amount = newValue;
        }
    }
    var InventoryItemDose: Int {
        get{
            return dose;
        }
        set{
            dose = newValue;
        }
    }
    
    var InventoryItemExpiryDate: Date {
        get{
            return expiryDate;
        }
        set{
            expiryDate = newValue;
        }
    }
    
    var InventoryItemNotes: String {
        get{
            return notes;
        }
        set{
            notes = newValue;
        }
    }
    
    
    
}

extension Array where Element : InventoryItem {
    
    func hasItem(with key : String) -> Bool {
        for item in self {
            if item.InventoryItemKey == key {
                return true
            }
        }
        return false
    }
    
}

enum DrugType : String{
    
    case mg = "Powder"
    case ml = "Drops"
    case pill = "Pills"
    
}

func getDrugTypeDescriptions(for drug : DrugType) -> [String:String] {
    var descriptions = [String : String] ()
    
    switch drug {
    case .mg:
        descriptions["doseUnit"] = "mg"
        descriptions["amountUnit"] = "mg"
    case .ml:
        descriptions["doseUnit"] = "ml"
        descriptions["amountUnit"] = "ml"
    case .pill:
        descriptions["doseUnit"] = "mg"
        descriptions["amountUnit"] = "Pills"
    }
    
    return descriptions
    
}
