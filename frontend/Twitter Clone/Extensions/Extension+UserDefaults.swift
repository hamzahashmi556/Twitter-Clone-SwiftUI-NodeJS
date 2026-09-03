//
//  Extension+UserDefaults.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import Foundation

extension UserDefaults {
    
    static var jwt: String? {
        get {
            return UserDefaults.standard.string(forKey: "jwt")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "jwt")
        }
    }
}
