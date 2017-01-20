//
//  RecordsManager.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 21/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import Foundation

class RecordsManager {
    private var _records: [Record]!
    
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

    public var records: [Record] {
        return _records
    }
    
    //MARK: management of records
    func register(record: Record) -> Void {
        _records.append(record)
    }
    
    func remove(record: Record) -> Void {
        let index = _records.index(where: {$0 === record})!
        _records.remove(at: index)
    }
    
    func replace(record: Record, withRecord: Record) -> Void {
        let index = _records.index(where: {$0 === record})!
        _records[index] = withRecord
    }
    
    @discardableResult
    func synchronyze() -> Bool {
        return currentStorage.synchronize(records: _records)
    }
}
