//
//  ContentView.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import SwiftUI
import Combine

struct RootView: View {
    let authService: AuthServiceProtocol = AuthService()
    @StateObject private var alertManager = AlertManager.shared
    var body: some View {
//        RegisterView(authService: authService)
        LogInView(authService: authService)
            .alert(alertManager.errorMsg, isPresented: $alertManager.isPresented) {
                Button("OK") {
                    alertManager.isPresented = false
                    alertManager.errorMsg.removeAll()
                }
            }
    }
}
