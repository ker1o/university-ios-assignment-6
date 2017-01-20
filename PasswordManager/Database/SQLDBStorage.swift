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
    var records: [Record] {
        get {
            var recordsResult = [Record]()
        
            let sequence = try! db.prepare(recordsTable)
            for record in sequence {
                let record: Record = Record(serviceName: record[serviceNameColumn], password: record[passwordColumn])
                recordsResult.append(record)
            }
            return recordsResult
        }
    }
    
    func synchronize(records: [Record]) -> Bool {
        if deleteAllRecords() {
            return addRecords(records: records)
        } else {
            return false
        }
    }
    
    // MARK: utils methods for work with database
    fileprivate func addRecords(records: [Record]) -> Bool {
        do {
            for record in records {
                try db.run(recordsTable.insert(serviceNameColumn <- record.serviceName,
                                               passwordColumn <- record.password))
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
