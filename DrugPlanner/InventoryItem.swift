//
//  File.swift
//  DrugPlanner
//
//  Created by ioana-raluca pica on 20.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation

struct InventoryItem {
    
    var name : String
    var type : DrugType
    var amount : Int
    var dose : Int
    var expiryDate : Date
    var notes : String
    
}


enum DrugType : String{
    
    case mg = "Powder"
    case ml = "Drops"
    case pill = "Pills"
    
}

func getInventoryItems() -> [InventoryItem] {
    
    var items : [InventoryItem] = []
    items.append(InventoryItem(name: "Iboprofen", type: DrugType.pill, amount: 50, dose: 400, expiryDate: Date.init(timeIntervalSinceNow: 31557600), notes: "take with water"))
    items.append(InventoryItem(name: "Aspirin", type: DrugType.pill, amount: 18, dose: 500, expiryDate: Date.init(timeIntervalSinceNow: 31557600), notes: "take with water"))
    return items
}
