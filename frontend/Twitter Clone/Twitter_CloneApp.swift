//
//  Twitter_CloneApp.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import SwiftUI

@main
struct Twitter_CloneApp: App {
    
    let authService: AuthServiceProtocol = AuthService()
    let userService: UserServiceProtocol = UserService()
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                authVM: AuthViewModel(userService: userService),
                authService: authService
            )
        }
    }
}
