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
    let notificationService: NotificationServiceProtocol
    
    init(user: UserModel, otherUser: UserModel?, tweetService: TweetServiceProtocol, userService: UserServiceProtocol, notificationService: NotificationServiceProtocol) {
        self.user = user
        self.otherUser = otherUser
        self.tweetService = tweetService
        self.userService = userService
        self.notificationService = notificationService
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
        guard let otherUser else { return }
        do {
            let response = try await userService.follow(userID: otherUser.id)
            self.otherUser = response
            AlertManager.shared.showAlert(message: "You followed " + response.name)
            
            // send notification
            do {
                let notification = NotificationRequest(
                    userName: user.userName,
                    senderId: user.id,
                    receiverId: otherUser.id,
                    notificationType: .follow
                )
                let response = try await notificationService.post(request: notification)
                print("Notification Sent: \(response)")
            } catch { }
        }
        catch {
            AlertManager.shared.showAlert(title: "Follow Failed", error: error)
        }
    }
    
    func unfollow() async {
        guard let otherUser else { return }
        do {
            let response = try await userService.unfollow(userID: otherUser.id)
            self.otherUser = response
            AlertManager.shared.showAlert(message: "You unfollowed " + response.name)
        }
        catch {
            AlertManager.shared.showAlert(title: "Unfollow Failed", error: error)
        }
    }

}
