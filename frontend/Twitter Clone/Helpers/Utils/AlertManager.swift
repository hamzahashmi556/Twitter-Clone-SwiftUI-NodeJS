//
//  AlertManager.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import Foundation
import Combine

final class AlertManager: ObservableObject {
    
    static let shared = AlertManager()
    
    @Published var errorMsg = ""
    @Published var isPresented = false
    
    private init() {}
    
    func showAlert(message: String) {
        self.errorMsg = message
        isPresented = true
    }
    
    func showAlert(error: Error) {
        self.errorMsg = error.localizedDescription
        isPresented = true
    }
}
