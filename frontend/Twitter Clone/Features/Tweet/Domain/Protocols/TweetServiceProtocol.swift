//
//  TweetServiceProtocol.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 04/09/2026.
//


protocol TweetServiceProtocol {
    func createTweet(request: TweetRequest) async throws -> TweetResponse
}
