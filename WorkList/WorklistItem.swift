//
//  WorklistItem.swift
//  WorkList
//
//  Created by LALIT JAGTAP on 3/27/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class WorklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextWorklistItemID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification() {
        if shouldRemind && dueDate > Date() {
            print("We should schedule a notification")
            
            //1
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            //2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            //3
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            //4
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            //5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request) for itemID: \(itemID)")
        }
    }
}


