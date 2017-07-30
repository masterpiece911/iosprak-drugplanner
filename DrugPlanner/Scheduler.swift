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
    
    var allEvents = [(Date, EventItem)]() {
        didSet {
            self.allEvents.sort(by: {
                lhs, rhs in
                return lhs.0 < rhs.0
            })
            NotificationCenter.default.post(name: Notification.Name(rawValue: EventStrings.EVENT_UPDATE), object: nil)
        }
    }
    
    private init() {
        
    }
    
    func scheduleNotifications(for items : [EventItem]) {
        
        var allEvents = [(Date, EventItem)]()
        
        let cal = Calendar(identifier: .gregorian)
        
        for item in items {
            
            if(item.type == .INVENTORY_EXPIRED) {
                
                if let date = cal.nextDate(after: Date(), matching: item.dates[0], matchingPolicy: .strict) {
                    allEvents.append((date, item))
                } else {
                    allEvents.append((Date(timeIntervalSinceNow: 5 * 60), item))
                }
                
                
                if item.dates.count > 1 {
                    let correspondingRanoutEvent = EventItem(.INVENTORY_RANOUT, for: item.inventory!, using: item.key)
                    correspondingRanoutEvent.dates[0] = item.dates[1]
                    if let date = cal.nextDate(after: Date(), matching: correspondingRanoutEvent.dates[0], matchingPolicy: .strict) {
                        allEvents.append((date, correspondingRanoutEvent))
                    } else {
                        allEvents.append((Date(timeIntervalSinceNow: 5 * 60), correspondingRanoutEvent))
                    }
                    
                    
                }
                
            } else {
                
                for component in item.dates {
                    
                    let date = cal.nextDate(after: Date(), matching: component, matchingPolicy: .strict)
                    
                    allEvents.append((date!, item))
                    
                }
                
            }
            
        }
        
        self.allEvents = allEvents
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        var index = 0
        
        for event in self.allEvents {
            
            if (index < 64) {
                UserNotifications.instance.add(event, with: index)
                index = index + 1
            } else {
                break
            }
            
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            (notificationRequests) in
            
            print("START SHOWING PENDING NOTIFICATION REQUESTS")
            print(Calendar.current.dateComponents([.hour, .minute, .second], from: Date()))
            
            for request in notificationRequests {
                print(request.content.categoryIdentifier)
                print(request.identifier)
                let date = request.trigger as! UNCalendarNotificationTrigger
                print(date.dateComponents)
            }
            
            print("END SHOWING PENDING NOTIFICATION REQUESTS")
            
        })
        
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {
            
            (notifications) in
            
            var deliveredNotifications : [String] = []
            
            for notification in notifications {
                let firedate = notification.date
                
                if firedate < Date().addingTimeInterval(-1 * 60 * 60) {
                    
                    let identifier = notification.request.identifier
                    
                    deliveredNotifications.append(identifier)
                    
                    for item in Events.instance.items!.filter(Events.filterAgendaReminderEvents(elem:)) {
                        if (identifier.hasPrefix((item.agenda?.agendaKey)!)) {
                            History.instance.add(historyItem: HistoryItem(withAgenda: item.agenda!, atDate: firedate, withNotes: "", usingKey: "temp", takenOrNot: false))
                        
                            UserNotifications.instance.add(item.agenda!, on: firedate)
                            
                            break;
                            
                        }
                    }
                
                }
                
            }
            
            if !deliveredNotifications.isEmpty {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: deliveredNotifications)
            }
            
        })
        
    }
    
    
    
}
