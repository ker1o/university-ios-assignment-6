//
//  SQLDBStorage.swift
//  PasswordManager
//
//  Created by Kirill Asyamolov on 19/12/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import SQLite

class SQLDBStorage: RecordsSynchronizing {
    
    private var urlPath: String
    
    private var db: Connection
    
    private let recordsTable = Table("records")
    private let idColumn = Expression<Int64>("id")
    private let serviceNameColumn = Expression<String>("service_name")
    private let passwordColumn = Expression<String>("password")
    
    init?(url: URL) {
        self.urlPath = url.path + ".sqlite3"
        
        do {
            db = try Connection(urlPath)
            
            //creating table if it's not exist
            try db.run(recordsTable.create(ifNotExists: true) {
                table in
                table.column(idColumn, primaryKey: true)
                table.column(serviceNameColumn)
                table.column(passwordColumn)
            })

        } catch let unknownError {
            print("\(unknownError) \(unknownError.localizedDescription)")
            return nil
        }
    }
    
    // MARK: RecordsSynchronizing implementation
    var records: [NSDictionary] {
        get {
            var recordsResult = [NSDictionary]()
        
            let sequence = try! db.prepare(recordsTable)
            for record in sequence {
                let record: NSDictionary = [Record.keyServiceName: record[serviceNameColumn], Record.keyPassword: record[passwordColumn]]
                recordsResult.append(record)
            }
            return recordsResult
        }
    }
    
    func synchronize(records: [NSDictionary]) -> Bool {
        if deleteAllRecords() {
            return addRecords(records: records)
        } else {
            return false
        }
    }
    
    // MARK: utils methods for work with database
    fileprivate func addRecords(records: [NSDictionary]) -> Bool {
        do {
            for record in records {
                try db.run(recordsTable.insert(serviceNameColumn <- record.object(forKey: Record.keyServiceName) as! String,
                                               passwordColumn <- record.object(forKey: Record.keyPassword) as! String))
            }
            return true
        } catch {
            return false
        }
    }
    
    fileprivate func deleteAllRecords() -> Bool {
        do {
            try db.run(recordsTable.delete())
            return true
        } catch {
            return false
        }
    }
    
    
}
