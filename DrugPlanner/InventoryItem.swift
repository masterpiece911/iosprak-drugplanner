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

class InventoryItem  {
    

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
    private var photo : String!
    
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
    
    init(with key : String, with parameters : NSDictionary) {
        
        
        self.key        = key
        self.name       = parameters[ItemKeys.Name]! as! String
        self.type       = DrugType(rawValue: parameters[ItemKeys.ItemType]! as! String)
        self.amount     = parameters[ItemKeys.Amount] as! Int
        self.dose       = parameters[ItemKeys.Dose] as! Int
        self.expiryDate = Date(from: parameters[ItemKeys.ExpiryDate]! as! Int)
        self.notes      = parameters[ItemKeys.Notes] as! String
        self.photo      = parameters[ItemKeys.Photo] as! String
        
    }
    
    func toDictionary() -> NSDictionary {
        
        return [
            ItemKeys.Name       : self.name ,
            ItemKeys.Amount     : self.amount ,
            ItemKeys.Dose       : self.dose ,
            ItemKeys.ExpiryDate : self.expiryDate.transformToInt() ,
            ItemKeys.ItemType   : self.type.rawValue ,
            ItemKeys.Notes      : self.notes,
            ItemKeys.Photo      : self.photo
        ]
    }
    
    func convertStringToImage(photoAsString: String) -> UIImage{
        
        let dataDecoded : Data = Data(base64Encoded: photoAsString, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage!;
        
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
            return photo;
        }
        set{
            photo = newValue;
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
    
    func getItem(with key : String) -> InventoryItem? {
        for item in self {
            if item.InventoryItemKey == key {
                return item
            }
        }
        return nil
    }
        
}


enum DrugType : String{
    
    case mg = "Powder"
    case ml = "Drops"
    case pill = "Pills"
    case syrup = "Syrup"
    case injection = "Injection"
    
}

func getDrugTypeDescriptions(for drug : DrugType) -> [String:String] {
    var descriptions = [String : String] ()
    
    switch drug {
    case .mg:
        descriptions["doseUnit"] = "mg"
        descriptions["amountUnit"] = "Doses"
    case .ml:
        descriptions["doseUnit"] = "ml"
        descriptions["amountUnit"] = "Doses"
    case .pill:
        descriptions["doseUnit"] = "mg"
        descriptions["amountUnit"] = "Pills"
    case .syrup:
        descriptions["doseUnit"] = "cl"
        descriptions["amountUnit"] = "Doses"
    case .injection :
        descriptions["doseUnit"] = "mg"
        descriptions["amountUnit"] = "Injections"
    }
    
    return descriptions
    
}
