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
    var otherUser: UserModel? // for viewing other profile
    let tweetService: TweetServiceProtocol
    let userService: UserServiceProtocol
    
    init(user: UserModel, otherUser: UserModel?, tweetService: TweetServiceProtocol, userService: UserServiceProtocol) {
        self.user = user
        self.otherUser = otherUser
        self.tweetService = tweetService
        self.userService = userService
        self.getTweets()
    }
    
    private func getTweets() {
        self.isLoading = true
        Task { @MainActor in
            do {
                if let otherUser = otherUser {
                    self.tweets = try await tweetService.getUserTweets(id: otherUser.id)
                }
                else {
                    self.tweets = try await tweetService.getUserTweets(id: user.id)
                }
            }
            catch {
                AlertManager.shared.showAlert(title: "Tweets Failed", error: error)
            }
            self.isLoading = false
        }
    }
    
    func follow() async {
        do {
            let otherUser = try await userService.follow(userID: user.id)
            self.otherUser = otherUser
            
            let notification = NotificationRequest(
                userName: user.userName,
                senderId: user.id,
                receiverId: otherUser.id,
                notificationType: .follow
            )
            AlertManager.shared.showAlert(message: "You followed " + user.name)
        }
        catch {
            AlertManager.shared.showAlert(title: "Follow Failed", error: error)
        }
    }
    
    func unfollow() async {
        do {
            let otherUser = try await userService.unfollow(userID: user.id)
            self.otherUser = otherUser
            AlertManager.shared.showAlert(message: "You unfollowed " + otherUser.name)
        }
        catch {
            AlertManager.shared.showAlert(title: "Unfollow Failed", error: error)
        }
    }

}
