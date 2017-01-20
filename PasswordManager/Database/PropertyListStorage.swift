//
//  PropertyListStorage.swift
//  PasswordManager
//
//  Created by Kirill Asyamolov on 21/12/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import Foundation

class PropertyListStorage: RecordsSynchronizing {
    private var url: URL
    
    private (set) var records: [Record]
    
    init(url: URL) {
        self.url = url
        
        if let records = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? [Record] {
            self.records = records
        } else {
            self.records = [Record]()
        }
    }
    

    
    func synchronize(records: [Record]) -> Bool {
        return NSKeyedArchiver.archiveRootObject(records, toFile: url.path)
    }
}
