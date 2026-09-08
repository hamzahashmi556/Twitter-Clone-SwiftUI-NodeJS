//
//  Extension+UserDefaults.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
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
    
    static var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: "userID")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userID")
        }
    }
}
