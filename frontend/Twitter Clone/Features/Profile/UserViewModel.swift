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
    
    var user: UserModel
    let tweetService: TweetServiceProtocol
    let userService: UserServiceProtocol
    
    init(user: UserModel, tweetService: TweetServiceProtocol, userService: UserServiceProtocol) {
        self.user = user
        self.tweetService = tweetService
        self.userService = userService
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
    
    func follow() async {
        do {
            let user = try await userService.follow(userID: user.id)
            self.user = user
            AlertManager.shared.showAlert(message: "You followed " + user.name)
        }
        catch {
            AlertManager.shared.showAlert(title: "Follow Failed", error: error)
        }
    }
    
    func unfollow() async {
        do {
            let user = try await userService.unfollow(userID: user.id)
            self.user = user
            AlertManager.shared.showAlert(message: "You unfollowed " + user.name)
        }
        catch {
            AlertManager.shared.showAlert(title: "Unfollow Failed", error: error)
        }
    }

}
