//
//  AgendaItem.swift
//  DrugPlanner
//
//  Created by admin on 12.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation

class AgendaItem  {
    
    struct ItemKeys {
        
        static let Key      = "key"
        static let drug     = "drug"
        static let dose     = "dose"
        static let endDate  = "endDate"
        static let time     = "time"
        static let weekdays = "weekdays"
        
    }
    
    private var key : String!
    private var drug : InventoryItem!
    private var dose : Int!
    private var endDate : Date!
    private var time : Date!
    private var weekdays : [Weekday : Bool]!
    
    init(for drug : InventoryItem, with dose : Int, at time : Date, on weekdays : [Weekday : Bool], until endDate : Date, using key : String) {
        
        self.key = key
        self.drug = drug
        self.dose = dose
        self.time = time
        self.weekdays = weekdays
        self.endDate = endDate
        
    }
    
    init(with key : String, with parameters: NSDictionary) {
        
        self.key      = key
        self.drug     = Inventory.instance.items!.getItem(with: parameters[ItemKeys.drug] as! String)
        self.dose     = parameters[ItemKeys.dose] as! Int
        self.time     = Date(from: parameters[ItemKeys.time] as! Int)
        self.weekdays = AgendaItem.getWeekdayDictionary(from: parameters[ItemKeys.weekdays] as! NSDictionary)
        self.endDate  = Date(from: parameters[ItemKeys.endDate] as! Int)
        
    }
    
    func toDictionary() -> NSDictionary {
        
        let weekdayDic = [
            Weekday.Monday.rawValue    : weekdays[.Monday] ,
            Weekday.Tuesday.rawValue   : weekdays[.Tuesday] ,
            Weekday.Wednesday.rawValue : weekdays[.Wednesday] ,
            Weekday.Thursday.rawValue  : weekdays[.Thursday] ,
            Weekday.Friday.rawValue    : weekdays[.Friday] ,
            Weekday.Saturday.rawValue  : weekdays[.Saturday] ,
            Weekday.Sunday.rawValue    : weekdays[.Sunday]
        ]
        
        return [
            ItemKeys.drug     : self.drug.InventoryItemKey ,
            ItemKeys.dose     : self.dose ,
            ItemKeys.endDate  : self.agendaEndDate.transformToInt() ,
            ItemKeys.time     : self.agendaTime.transformToInt() ,
            ItemKeys.weekdays : weekdayDic
        ]
    }
    
    var agendaKey : String {
        get {
            return self.key
        }
        set {
            self.key = newValue
        }
    }
    
    var agendaDrug : InventoryItem {
        get {
            return self.drug
        }
        set {
            self.drug = newValue
        }
    }
    
    var agendaDose : Int {
        get {
            return self.dose
        }
        set {
            self.dose = newValue
        }
    }
    
    var agendaEndDate : Date {
        get {
            return self.endDate
        }
        set {
            self.endDate = newValue
        }
    }
    
    var agendaTime : Date {
        get {
            return self.time
        }
        set {
            self.time = newValue
        }
    }
    
    var agendaWeekdays : [Weekday:Bool] {
        get {
            return self.weekdays
        }
        set {
            self.weekdays = newValue
        }
    }
    
    static func generateWeekdayDictionary() -> [Weekday : Bool] {
        return [
            .Monday : false,
            .Tuesday : false,
            .Wednesday : false,
            .Thursday : false,
            .Friday : false,
            .Saturday : false,
            .Sunday : false
        ]
    }
    
    static func getWeekdayDictionary(from dict: NSDictionary) -> [Weekday : Bool] {
       
        var weekdayDictionary = [Weekday : Bool] ()
        
        for weekdayIndex in 1...7 {
            
            let weekday = AgendaItem.getWeekday(for: weekdayIndex)
            weekdayDictionary[weekday] = dict[weekday.rawValue] as? Bool
            
        }
        
        return weekdayDictionary
    }
    
    static func getWeekday(for index : Int) -> Weekday {
        switch (index) {
        case 2:
            return .Monday
        case 3:
            return .Tuesday
        case 4:
            return .Wednesday
        case 5:
            return .Thursday
        case 6:
            return .Friday
        case 7:
            return .Saturday
        case 1:
            return .Sunday
        default:
            print("weird weekday selected")
            return .Monday
        }
    }
    
    enum Weekday : String{
        case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    }
    
}

extension Array where Element : AgendaItem {
    
    func getAgenda(with key : String) -> AgendaItem? {
        
        for item in self {
            
            if item.agendaKey == key {
                return item
            }

        }
        return nil
    }
    
    func hasAgenda(with key : String) -> Bool {
        
        for item in self {
            
            if item.agendaKey == key {
                return true
            }
            
        }
        return false
    }
    
}
