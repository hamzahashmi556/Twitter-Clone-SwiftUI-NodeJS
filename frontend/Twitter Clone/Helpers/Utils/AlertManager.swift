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
    
    @Published var title = ""
    @Published var errorMsg = ""
    @Published var isPresented = false
    
    private init() {}
    
    func showAlert(title: String = "Alert", message: String) {
        self.title = title
        self.errorMsg = message
        isPresented = true
    }
    
    func showAlert(title: String = "Alert", error: Error) {
        self.title = title
        self.errorMsg = error.localizedDescription
        isPresented = true
    }
}
