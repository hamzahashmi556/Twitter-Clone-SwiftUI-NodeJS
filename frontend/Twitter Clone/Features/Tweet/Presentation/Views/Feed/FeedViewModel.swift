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
    
    let tweetService: TweetServiceProtocol
    
    init(tweetService: TweetServiceProtocol) {
        self.tweetService = tweetService
        self.fetchTweets()
    }
    
    func fetchTweets() {
        Task {
            do {
                let tweets = try await tweetService.getTweets()
                self.tweets = tweets
            }
            catch {
                AlertManager.shared.showAlert(error: error)
            }
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
