//
//  TweetService.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


import Foundation

final class TweetService: TweetServiceProtocol {
    
    let client = APIClient.shared
    let baseURL = "http://localhost:3000/tweets"
    var headers: [String : String] = [
        "Content-Type" : "application/json",
        "Accept" : "application/json",
        
    ]
    
    init() {
        if let jwt = UserDefaults.jwt {
            headers["Authorization"] = "Bearer \(jwt)"
        }
    }
    
    func createTweet(request: TweetRequest, imageData: Data? = nil) async throws -> Tweet {
        let body = try JSONEncoder().encode(request)
        let response: Tweet = try await client.request(baseURL, method: .post, headers: headers, body: body)
        guard let imageData else { return response }
        
        let tweetID = response.id
        let imageResponse: TweetImageResponse = try await ImageUploader.uploadMultipart(
            urlPath: "http://localhost:3000/tweet/uploadImage/" + tweetID,
            fileData: imageData,
            fileName: "tweet_image",
            paramName: "image"
        )
        return imageResponse.tweet
    }
    
    func getTweets() async throws -> [Tweet] {
        return try await client.request(baseURL, method: .get, headers: headers, body: nil)
    }
}
