    //
//  Record.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 21/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//
import Foundation
    
class Record: NSObject, NSCoding {
    static let keyServiceName: String = "ServiceName"
    static let keyPassword: String = "Password"
    
    public var serviceName: String
    public var password: String
    
    init(serviceName: String, password: String) {
        self.serviceName = serviceName
        self.password = password
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let serviceName = aDecoder.decodeObject(forKey: Record.keyServiceName) as? String,
            let password = aDecoder.decodeObject(forKey: Record.keyPassword) as? String
            else { return nil }
        
        self.init(serviceName: serviceName, password: password)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(serviceName, forKey: Record.keyServiceName)
        aCoder.encode(password, forKey: Record.keyPassword)
    }
}
