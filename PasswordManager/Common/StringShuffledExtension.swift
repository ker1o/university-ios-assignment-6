//
//  NSMutableString+Exchange.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 22/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import Foundation

extension String {
    func shuffled() -> String {
        var arr = Array<Character>(characters)
        let charsLength = arr.count
        
        for _ in 0..<charsLength {
            arr.sort {(_, _) in arc4random() < arc4random()}
        }
        
        var str = ""
        for char in arr {
            str.append(char)
        }
        
        return str
    }
}
