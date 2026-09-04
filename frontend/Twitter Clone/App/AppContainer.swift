//
//  AppContainer.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 04/09/2026.
//

import Combine

final class AppContainer: ObservableObject {
    
    let authService: AuthServiceProtocol
    let userService: UserServiceProtocol
    let tweetService: TweetServiceProtocol
    
    init() {
        self.authService = AuthService()
        self.userService = UserService()
        self.tweetService = TweetService()
    }
}
