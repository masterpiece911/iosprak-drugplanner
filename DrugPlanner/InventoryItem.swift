//
//  File.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation

class InventoryItem: NSObject, NSCoding {
    
    
    
    struct ItemKeys{
        static let Name = "name";
        static let ItemType = "type";
        static let Amount = "amount";
        static let Dose = "dose";
        static let ExpiryDate = "expiryDate";
        static let Notes = "notes";
    }
    
    
    private var name : String!
    private var type : DrugType!
    private var amount : Int!
    private var dose : Int!
    private var expiryDate : Date!
    private var notes : String!
    
    override init() {}
    
    init(name: String, type: DrugType, amount: Int, dose: Int, expiryDate: Date, notes: String){
        self.name = name;
        self.type = type;
        self.amount = amount;
        self.dose = dose;
        self.expiryDate = expiryDate;
        self.notes = notes;
    }
    
    required init?(coder decoder: NSCoder) {
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


enum DrugType {
    
    case mg
    case ml
    case tablet
    
}
