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
    
    private var key : String!
    private var date : Date!
    private var name : String!
    private var dose : Int!
    private var notes : String!
    
    init(for name : String, with dose : Int, at date : Date,with notes : String, using key : String) {
        
        self.key = key
        self.name = name
        self.dose = dose
        self.notes = notes
        self.date = date
        
        
    }
   
   }
