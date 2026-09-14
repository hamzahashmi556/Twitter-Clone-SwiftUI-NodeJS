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
    
    func like(tweetId: String) async {
        do {
            let response = try await tweetService.like(tweetId: tweetId)
            if let index = self.tweets.firstIndex(where: { $0.id == tweetId }) {
                self.tweets[index] = response
            }
        }
        catch {
            AlertManager.shared.showAlert(title: "Error", error: error)
        }
    }
    
    func unlike(tweetId: String) async {
        do {
            let response = try await tweetService.unlike(tweetId: tweetId)
            if let index = self.tweets.firstIndex(where: { $0.id == tweetId }) {
                self.tweets[index] = response
            }
        }
        catch {
            AlertManager.shared.showAlert(title: "Error", error: error)
        }
    }
    
    private static func makeSamplePosts() -> [Tweet] {
        let sampleTweetText = "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs."
        let sampleUser = UserModel(
            _id: "6a99109a4d74c2c6170ee07b",
            name: "Hamza Hashmi",
            userName: "hamzahashmi556",
            email: "hamzahashmi556@gmail.com",
            followers: [],
            followings: ["6a9911384d74c2c6170ee07d"]
        )
        
        return [
            Tweet(
                _id: "1",
                text: "Hey Tim, are those regular glasses? #WWDC2020",
                user: sampleUser,
            ),
            Tweet(
                _id: "2",
                text: sampleTweetText,
                user: sampleUser
            ),
            Tweet(
                _id: "3",
                text: sampleTweetText,
                user: sampleUser,
            ),
            Tweet(
                _id: "4",
                text: sampleTweetText,
                user: sampleUser,
            )
        ]
    }
}
