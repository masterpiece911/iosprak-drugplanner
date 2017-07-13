//
//  AgendaItem.swift
//  DrugPlanner
//
//  Created by admin on 12.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation

class AgendaItem {
    
    struct itemKeys {
        
        
        
    }
    
    private var key : String!
    private var drug : String!
    private var dose : Int!
    private var endDate : Date!
    private var time : Date!
    private var weekdays : [Weekday : Bool]!
    
    init(for drug : String, with dose : Int, at time : Date, on weekdays : [Weekday : Bool], until endDate : Date, using key : String) {
        
        self.key = key
        self.drug = drug
        self.dose = dose
        self.time = time
        self.weekdays = weekdays
        self.endDate = endDate
        
    }
    
    var agendaKey : String {
        get {
            return self.key
        }
        set {
            self.key = newValue
        }
    }
    
    var agendaDrug : String {
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
    
    static func getWeekday(for index : Int) -> Weekday {
        switch (index) {
        case 0:
            return .Monday
        case 1:
            return .Tuesday
        case 2:
            return .Wednesday
        case 3:
            return .Thursday
        case 4:
            return .Friday
        case 5:
            return .Saturday
        case 6:
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
