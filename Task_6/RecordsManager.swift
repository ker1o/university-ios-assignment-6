//
//  RecordsManager.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 21/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import Foundation

class RecordsManager {
    private var _records: [NSDictionary]!
    
    private var preferences: Preferences
    
    private var propertyListStorage: PropertyListStorage
    private var sqlDBStorage: SQLDBStorage

    private var currentStorage: RecordsSynchronizing {
        switch preferences.passwordStorage {
        case .propertyList:
            return propertyListStorage
        case .sqLite:
            return sqlDBStorage
        }
    }

    init(url: URL, preferences: Preferences) {
        self.preferences = preferences
        
        propertyListStorage = PropertyListStorage(url: url)
        sqlDBStorage = SQLDBStorage(url: url)!
        
        _records = currentStorage.records
    }

    public var records: [NSDictionary] {
        return _records
    }
    
    //MARK: management of records
    func register(record: NSDictionary) -> Void {
        if (record.count > 0) {
            _records.append(record)
        }
    }
    
    func remove(record: NSDictionary) -> Void {
        _records.remove(at: _records.index(of: record)!)
    }
    
    func replace(record: NSDictionary, withRecord: NSDictionary) -> Void {
        _records[_records.index(of: record)!] = withRecord
    }
    
    @discardableResult
    func synchronyze() -> Bool {
        return currentStorage.synchronize(records: _records)
    }
}
