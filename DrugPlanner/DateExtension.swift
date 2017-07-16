//
//  DateExtension.swift
//  DrugPlanner
//
//  Created by admin on 14.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation

extension Date {
    
    /// returns an integer representation of the date for use in our firebase database
    func transformToInt () -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    /// generates a date using an Integer from our firebase database
    init(from firebaseInt : Int) {
        self.init(timeIntervalSince1970: Double(firebaseInt))
    }
    
}
