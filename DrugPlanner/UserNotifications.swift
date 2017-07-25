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
        
        center.setNotificationCategories([agendaCategory, inventoryExpiredCategory, inventoryRanoutCategory])
        
        center.delegate = self
    }
    
    func add(_ eventItem : (Date,EventItem), with index : Int) {
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        let cal = Calendar(identifier: .gregorian)
        let trigger = UNCalendarNotificationTrigger(dateMatching: cal.dateComponents([.year, .month, .day, .hour, .minute], from: eventItem.0), repeats: false)
        
        switch (eventItem.1.type) {
            
        case .AGENDA_REMINDER:
            
            let drugName   = eventItem.1.agenda!.agendaDrug.InventoryItemName
            let dose       = eventItem.1.agenda!.agendaDose
            let amountUnit = getDrugTypeDescriptions(for: (eventItem.1.agenda!.agendaDrug.InventoryItemType))["amountUnit"]!
            let notes      = eventItem.1.agenda!.agendaDrug.InventoryItemNotes
            
            content.categoryIdentifier = NotificationStrings.AGENDA_REMINDER
            content.title = "Your medication is due."
            content.body = "Please take \(dose) \(amountUnit) of \(drugName). \(notes)"
            
        case .INVENTORY_EXPIRED:
            
            let drugName = eventItem.1.inventory!.InventoryItemName
            let dateF = DateFormatter()
            dateF.dateStyle = .medium
            dateF.timeStyle = .none
            let date     = eventItem.1.inventory!.InventoryItemExpiryDate
            
            content.categoryIdentifier = NotificationStrings.INVENTORY_EXPIRED
            content.title = "Your medication has expired."
            content.body = "\(drugName) has expired on \(dateF.string(from: date))."
            
        case .INVENTORY_RANOUT:
            
            content.categoryIdentifier = NotificationStrings.INVENTORY_RANOUT
            // TODO
            
        }
        
        let request = UNNotificationRequest(identifier: (eventItem.1.key + index.description), content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: {
            error in
            print(request.debugDescription)
            if error != nil {
                print(error!.localizedDescription)
            }
        })
    }
    
}

extension UserNotifications : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("I recieved a notification")
        switch(response.notification.request.content.categoryIdentifier) {
        case NotificationStrings.AGENDA_REMINDER :
            
            switch (response.actionIdentifier) {
            case UNNotificationDismissActionIdentifier : print("Notification dismissed")
            case UNNotificationDefaultActionIdentifier : print("App launched")
            case NotificationStrings.AGENDA_FOLLOWED_ACTION : print("Agenda Event confirmed")
            case NotificationStrings.AGENDA_IGNORED_ACTION : print("Agenda Event ignored")
                
            default: print("Action identifier: \(response.actionIdentifier)")
            }
            
            
            
        case NotificationStrings.INVENTORY_EXPIRED :
            
            print("reacted to Inventory Expired Notification")
            
        case NotificationStrings.INVENTORY_RANOUT :
            
            print("reacted to Inventory will run out Notification")
            
        default: print("Notification Category: \(response.notification.request.content.categoryIdentifier)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("I will present a notification")
        
        completionHandler(.sound)
        completionHandler(.alert)
    }
    
}
