//
//  UserNotifications.swift
//  DrugPlanner
//
//  Created by Noyan Tillman Sahin on 20.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotifications : NSObject{
    
    static var instance = UserNotifications()
    
    private override init() {}
    
    func setUp() {
        
        let center = UNUserNotificationCenter.current()
        
        let agendaFollowedAction = UNNotificationAction (identifier: NotificationStrings.AGENDA_FOLLOWED_ACTION, title: "Confirm", options: UNNotificationActionOptions(rawValue: 0))
        
        let agendaIgnoredAction = UNNotificationAction (identifier: NotificationStrings.AGENDA_IGNORED_ACTION, title: "Ignore", options: UNNotificationActionOptions(rawValue: 0))
        
        let agendaCategory = UNNotificationCategory (identifier: NotificationStrings.AGENDA_REMINDER, actions: [agendaFollowedAction, agendaIgnoredAction], intentIdentifiers: [], options: .customDismissAction)
        
        let inventoryExpiredCategory = UNNotificationCategory (identifier: NotificationStrings.INVENTORY_EXPIRED, actions: [], intentIdentifiers: [], options: .customDismissAction)
        
        let inventoryRanoutCategory  = UNNotificationCategory (identifier: NotificationStrings.INVENTORY_RANOUT, actions: [], intentIdentifiers: [], options: .customDismissAction)
        
        let agendaIgnoredCategory = UNNotificationCategory (identifier: NotificationStrings.AGENDA_IGNORED, actions: [], intentIdentifiers: [], options: .customDismissAction)
        
        center.setNotificationCategories([agendaCategory, inventoryExpiredCategory, inventoryRanoutCategory, agendaIgnoredCategory])
        
        center.delegate = self
    }
    
    func add(_ eventItem : (Date,EventItem), with index : Int) {
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        let cal = Calendar(identifier: .gregorian)
        let trigger = UNCalendarNotificationTrigger(dateMatching: cal.dateComponents([.year, .month, .day, .hour, .minute], from: eventItem.0), repeats: false)
        
        var identifier : String
        
        switch (eventItem.1.type) {
            
        case .AGENDA_REMINDER:
            
            identifier     = (eventItem.1.agenda?.agendaKey)!
            let drugName   = eventItem.1.agenda!.agendaDrug.InventoryItemName
            let dose       = eventItem.1.agenda!.agendaDose
            let amountUnit = getDrugTypeDescriptions(for: (eventItem.1.agenda!.agendaDrug.InventoryItemType))["amountUnit"]!
            let notes      = eventItem.1.agenda!.agendaDrug.InventoryItemNotes
            
            content.categoryIdentifier = NotificationStrings.AGENDA_REMINDER
            content.title = "Your medication is due."
            content.body = "Please take \(dose) \(amountUnit) of \(drugName). \(notes)"
            
        case .INVENTORY_EXPIRED:
            
            identifier = (eventItem.1.inventory?.InventoryItemKey)!
            let drugName = eventItem.1.inventory!.InventoryItemName
            let dateF = DateFormatter()
            dateF.dateStyle = .medium
            dateF.timeStyle = .none
            let date     = eventItem.1.inventory!.InventoryItemExpiryDate
            
            content.categoryIdentifier = NotificationStrings.INVENTORY_EXPIRED
            content.title = "Your medication has expired."
            content.body = "\(drugName) has expired on \(dateF.string(from: date))."
            
        case .INVENTORY_RANOUT:
            
            identifier = (eventItem.1.inventory?.InventoryItemKey)!
            let drugName = eventItem.1.inventory!.InventoryItemName
            
            content.categoryIdentifier = NotificationStrings.INVENTORY_RANOUT
            content.title = "Your medication is running out."
            content.body = "Based on current schedules, you are running out on \(drugName). You need to order more to follow your schedules."
            
            
        }
        
        let request = UNNotificationRequest(identifier: (identifier + index.description), content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: {
            error in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
    }
    
    func add (_ agenda : AgendaItem, on date : Date) {
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        let components = Calendar.current.dateComponents([.year, .month, .hour, .minute, .day, .second], from: Date(timeIntervalSinceNow: 30))
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = agenda.agendaKey.appending("_").appending(date.transformToInt().description)
        
        let dateF = DateFormatter()
        dateF.dateStyle = .medium
        dateF.timeStyle = .none
        let dateString = dateF.string(from: date)
        
        dateF.dateStyle = .none
        dateF.timeStyle = .short
        let timeString = dateF.string(from: date)
        
        content.categoryIdentifier = NotificationStrings.AGENDA_IGNORED
        content.title = "You missed your schedule."
        content.body = "You were scheduled to take \(agenda.agendaDose) \(getDrugTypeDescriptions(for: agenda.agendaDrug.InventoryItemType)["amountUnit"]!) of \(agenda.agendaDrug.InventoryItemName) on \(dateString) at \(timeString). This was noted in your history."
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
            print("I scheduled a notification to tell you you missed your schedule")
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        
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
        
        
    }
    
}

extension UserNotifications : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch(response.notification.request.content.categoryIdentifier) {
        case NotificationStrings.AGENDA_REMINDER :
            
            switch (response.actionIdentifier) {
            case UNNotificationDismissActionIdentifier :
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationStrings.AGENDA_IGNORED_ACTION), object: response.notification.request.identifier)

            case UNNotificationDefaultActionIdentifier :
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationStrings.AGENDA_APPLAUNCH_ACTION), object: response.notification.request.identifier)
                
            case NotificationStrings.AGENDA_FOLLOWED_ACTION :
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationStrings.AGENDA_FOLLOWED_ACTION), object: response.notification.request.identifier)
                
            case NotificationStrings.AGENDA_IGNORED_ACTION :
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationStrings.AGENDA_IGNORED_ACTION), object: response.notification.request.identifier)
                
            default: print("Action identifier: \(response.actionIdentifier)")
            }
            
            
            
        case NotificationStrings.INVENTORY_EXPIRED :
            
            print("reacted to Inventory Expired Notification")
            
        case NotificationStrings.INVENTORY_RANOUT :
            
            print("reacted to Inventory will run out Notification")
            
        case NotificationStrings.AGENDA_IGNORED :
            
            print("reacted to Agenda ignored Notification")
            
        default: print("Notification Category: \(response.notification.request.content.categoryIdentifier)")
            
        }
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        switch(notification.request.content.categoryIdentifier) {
        case NotificationStrings.INVENTORY_EXPIRED, NotificationStrings.INVENTORY_RANOUT :
            completionHandler(.alert)
        case NotificationStrings.AGENDA_REMINDER :
            completionHandler([.alert, .sound])
        default: break
        }
        
    }
    
}
