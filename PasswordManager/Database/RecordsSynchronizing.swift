//
//  DataSynchronizing.swift
//  PasswordManager
//
//  Created by Kirill Asyamolov on 21/12/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//
import Foundation

protocol RecordsSynchronizing {
    var records: [NSDictionary] { get }
    func synchronize(records: [NSDictionary]) -> Bool
}

