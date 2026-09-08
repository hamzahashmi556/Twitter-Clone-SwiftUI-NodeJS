//
//  TweetServiceProtocol.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


protocol TweetServiceProtocol {
    func createTweet(request: TweetRequest) async throws -> TweetResponse
}
