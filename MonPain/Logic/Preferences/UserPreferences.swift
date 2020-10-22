//
//  UserPreferences.swift
//  MonPain
//
//  Created by Jonathan Duss on 22.10.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

public class UserPreferences {
    
    public static var shared: UserPreferences = UserPreferences()

    
    private var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    // MARK: Salt
    
    private let saltRelationKey = "saltRelationKey"
    
    public var saltRelation: SaltRelation {
        get {
            return SaltRelation(rawValue: userDefaults.integer(forKey: saltRelationKey)) ?? SaltRelation.water
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: saltRelationKey)
        }
    }
    
    public func save() {
        userDefaults.synchronize()
    }
    
    
}
