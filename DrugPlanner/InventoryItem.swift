//
//  File.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import UIKit

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
    private var photo : String?
    
    override init() {}
    
    init(key: String, name: String, type: DrugType, amount: Int, dose: Int, expiryDate: Date, notes: String, photo:String){
        self.key = key;
        self.name = name;
        self.type = type;
        self.amount = amount;
        self.dose = dose;
        self.expiryDate = expiryDate;
        self.notes = notes;
        self.photo = photo
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
        if let photoObj = decoder.decodeObject(forKey: ItemKeys.Photo)
            as? String {
            photo = photoObj;
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: ItemKeys.Name);
        coder.encode(type, forKey: ItemKeys.ItemType);
        coder.encode(amount, forKey: ItemKeys.Amount);
        coder.encode(dose, forKey: ItemKeys.Dose);
        coder.encode(expiryDate, forKey: ItemKeys.ExpiryDate);
        coder.encode(notes, forKey: ItemKeys.Notes);
        coder.encode(photo, forKey: ItemKeys.Photo);

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
    
    var InventoryItemPhoto: String {
        get{
            return photo!;
        }
        set{
            photo = newValue;
        }
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

/*
func getInventoryItems() -> [InventoryItem] {
    
    var items : [InventoryItem] = []
    items.append(InventoryItem(key: "test1", name: "Iboprofen", type: DrugType.pill, amount: 50, dose: 400, expiryDate: Date.init(timeIntervalSinceNow: 31557600), notes: "take with water"))
    items.append(InventoryItem(key: "test2", name: "Aspirin", type: DrugType.pill, amount: 18, dose: 500, expiryDate: Date.init(timeIntervalSinceNow: 31557600), notes: "take with water"))
    return items
}
*/
