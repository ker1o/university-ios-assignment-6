//
//  PasswordGenerator.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 22/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import Foundation

class PasswordGenerator {
    static func generatePassword(ofLength length: Int, usingAlphabet alphabet: String) -> String {
        let alphabetPower: Int = alphabet.characters.count
        let rand = Int(arc4random_uniform(256))
        let randomLocation = rand % (alphabetPower - length)
        
        let str = alphabet.shuffled()
        let start = str.index(str.startIndex, offsetBy: randomLocation)
        let end = str.index(start, offsetBy: length)
        return str.substring(with: start..<end)
    }
}
