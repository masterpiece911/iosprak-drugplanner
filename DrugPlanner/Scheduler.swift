//
//  Scheduler.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 23.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import UserNotifications

class Scheduler {
    
    static var instance = Scheduler()
    
    var currentNotifications = [UNNotificationRequest]() {
        didSet {
            currentNotifications.sort(by: Events.notificationRequestDatesAreInIncreasingOrder(lhs:rhs:))
        }
    }
    
    var allEvents = [(Date, EventItem)]() {
        didSet {
            self.allEvents.sort(by: {
                lhs, rhs in
                return lhs.0 < rhs.0
            })
            NotificationCenter.default.post(name: Notification.Name(rawValue: AgendaStrings.AGENDA_UPDATE), object: nil)
        }
    }
    
    private init() {
        
    }
    
    func populateCurrentNotifications() {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            requests in
            let newRequests = requests.filter({
                element in
                return !self.currentNotifications.contains(element)
            })
            self.currentNotifications.append(contentsOf: newRequests)
            
        })
    }

    func scheduleNotifications(for items : [EventItem]) {
        
        var allEvents = [(Date, EventItem)]()
        
        let cal = Calendar(identifier: .gregorian)
        
        for item in items {
            
            for component in item.dates {
                
                let date = cal.nextDate(after: Date(), matching: component, matchingPolicy: .strict)
                
                allEvents.append((date!, item))
                
            }
            
        }
        
        self.allEvents = allEvents
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        var index = 0
        
        print(" WILL SCHEDULE THESE NOTIFICATIONS: ")

        for event in self.allEvents {
            
            if (index < 64) {
                UserNotifications.instance.add(event)
                index = index + 1
            } else {
                break
            }
            
        }
        
        print(index)
        
        print("HAVE SCHEDULED THESE NOTIFICATIONS: ")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            (notificationRequests) in
            
            for request in notificationRequests {
                print(request.trigger.debugDescription)
            }
            
        })
        
        
    }
    
    
    
}
