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
    private var nsArray: NSArray?
    
    init(url: URL) {
        self.url = url
        nsArray = NSArray(contentsOf: url)
        
        if nsArray == nil {
            nsArray = NSArray()
        }
        
    }
    
    var records: [NSDictionary] {
        get {
            return nsArray as! [NSDictionary]
        }
    }
    
    func synchronize(records: [NSDictionary]) -> Bool {
        return NSArray(array: records).write(to: url, atomically: true)
    }
}
