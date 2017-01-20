//
//  Preferences.swift
//  Task_6
//
//  Created by Kirill Asyamolov on 21/11/16.
//  Copyright © 2016 Kirill Asyamolov. All rights reserved.
//

import Foundation

class Preferences {
    
    enum PasswordStrength: Int {
        case weak    = 5
        case medium  = 10
        case strong  = 15
    }
    
    enum PasswordStorage: Int {
        case propertyList = 0
        case sqLite = 1
    }
    
    static let standard: Preferences = Preferences()
    
    private let passwordStrengthDefault = PasswordStrength.medium
    private let passwordStorageDefault = PasswordStorage.propertyList
    
    private let keyPasswordStrength = "passwordStrength"
    private let keyPasswordStorage = "passwordStorage"
    
    private init() {
        registerUserDefaultsForSettingsBundle()
    }

    var passwordStrength: PasswordStrength {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: keyPasswordStrength)
            UserDefaults.standard.synchronize()
        }
        get {
            return PasswordStrength(rawValue: UserDefaults.standard.integer(forKey: keyPasswordStrength))!
        }
    }
    
    var passwordStorage: PasswordStorage {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: keyPasswordStorage)
            UserDefaults.standard.synchronize()
        }
        get {
            return PasswordStorage(rawValue: UserDefaults.standard.integer(forKey: keyPasswordStorage))!
        }
    }
    
    func registerUserDefaultsForSettingsBundle() -> Void
    {
        var defaultsToRegister = [String: Any]()
        
        if let settingsBundlePath = Bundle.main.path(forResource: "Settings", ofType: "bundle") {
            let rootPlistURL = URL(fileURLWithPath: settingsBundlePath).appendingPathComponent("Root.plist")
            let preferences = NSDictionary.init(contentsOf: rootPlistURL)!
            let preferenceSpecifiers = preferences.object(forKey: "PreferenceSpecifiers") as! NSArray
            for case let specifier as NSDictionary in preferenceSpecifiers {
                if let key = specifier.object(forKey: "Key") as? String {
                    defaultsToRegister[key] = specifier.object(forKey: "DefaultValue")
                }
            }
        } else {
            defaultsToRegister[keyPasswordStrength] = passwordStrengthDefault.rawValue
            defaultsToRegister[keyPasswordStorage] = passwordStorageDefault.rawValue
        }
        
        UserDefaults.standard.register(defaults: defaultsToRegister)
        UserDefaults.standard.synchronize()
    }
}
