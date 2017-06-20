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


enum DrugType {
    
    case mg
    case ml
    case tablet
    
}
