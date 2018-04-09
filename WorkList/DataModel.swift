//
//  DataModel.swift
//  WorkList
//
//  Created by LALIT JAGTAP on 4/1/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Worklist]()
    
    init() {
        loadWorklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func sortWorklists() {
        lists.sort(by: {worklist1, worklist2 in
            return worklist1.name.localizedStandardCompare(worklist2.name) == .orderedAscending})
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let worklist = Worklist(name: "List")
            lists.append(worklist)
            
            indexOfSelectedWorklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    var indexOfSelectedWorklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "WorklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "WorklistIndex")
        }
    }
    
    func registerDefaults() {
        let dictionary: [String:Any] = ["WorklistIndex": -1, "FirstTime": true ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveWorklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    func loadWorklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            sortWorklists()
            do {
                lists = try decoder.decode([Worklist].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
    }
    
    class func nextWorklistItemID() -> Int {
        let userDefaults =  UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "WorklistItemID")
        userDefaults.set(itemID + 1, forKey: "WorklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}


