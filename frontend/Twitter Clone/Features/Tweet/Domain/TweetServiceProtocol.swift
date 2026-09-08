//
//  TweetServiceProtocol.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import Foundation

protocol TweetServiceProtocol {
    func createTweet(request: TweetRequest, imageData: Data?) async throws -> Tweet
}
