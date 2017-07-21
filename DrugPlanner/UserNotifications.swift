//
//  UserNotifications.swift
//  DrugPlanner
//
//  Created by admin on 20.07.17.
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
        
//        center.delegate = self
    }
    
    
}

//extension UserNotifications : UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        <#code#>
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        <#code#>
//    }
//    
//}
