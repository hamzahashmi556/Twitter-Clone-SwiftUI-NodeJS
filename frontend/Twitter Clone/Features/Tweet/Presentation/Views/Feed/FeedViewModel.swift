//
//  FeedViewModel.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    
    @Published private(set) var tweets: [Tweet] = []
    @Published private(set) var otherUsers: [UserModel] = []
    
    let tweetService: TweetServiceProtocol
    let userService: UserServiceProtocol
    
    init(tweetService: TweetServiceProtocol, userService: UserServiceProtocol) {
        self.tweetService = tweetService
        self.userService = userService
        self.fetchTweets()
    }
    
    func fetchTweets() {
        Task {
            do {
                let tweets = try await tweetService.getTweets()
                self.tweets = tweets
                
                let users: [UserModel] = await withTaskGroup(of: UserModel?.self) { [weak self] tg in
                    guard let self else { return [] }
                    let userIDs = Array(Set(tweets.map({ $0.userId })))
                    for userID in userIDs {
                        tg.addTask {
                            return try? await self.userService.getUser(id: userID)
                        }
                    }
                    var users: [UserModel] = []
                    for await user in tg {
                        if let user {
                            users.append(user)
                        }
                    }
                    return users
                }
                self.otherUsers = users

            }
            catch {
                AlertManager.shared.showAlert(error: error)
            }
        }
    }
    
    func like(tweetId: String) async throws {
        let response = try await tweetService.like(tweetId: tweetId)
        if let index = self.tweets.firstIndex(where: { $0.id == tweetId }) {
            self.tweets[index] = response
        }
    }
    
    func unlike(tweetId: String) async throws {
        let response = try await tweetService.unlike(tweetId: tweetId)
        if let index = self.tweets.firstIndex(where: { $0.id == tweetId }) {
            self.tweets[index] = response
        }
    }
}
