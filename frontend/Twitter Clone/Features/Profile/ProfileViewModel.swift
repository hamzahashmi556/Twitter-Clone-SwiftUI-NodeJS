//
//  ProfileViewModel.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 08/09/2026.
//

import Combine

@MainActor
class ProfileViewModel {
    
    @Published private(set) var isLoading = false
    @Published private(set) var tweets: [Tweet] = []
    
    let user: UserModel
    let tweetService: TweetServiceProtocol
    
    init(user: UserModel, tweetService: TweetServiceProtocol) {
        self.user = user
        self.tweetService = tweetService
        self.getTweets()
    }
    
    private func getTweets() {
        self.isLoading = true
        Task { @MainActor in
            let id = user.id
            do {
                self.tweets = try await tweetService.getUserTweets(id: id)
            }
            catch {
                AlertManager.shared.showAlert(title: "Tweets Failed", error: error)
            }
            self.isLoading = false
        }
    }
}
