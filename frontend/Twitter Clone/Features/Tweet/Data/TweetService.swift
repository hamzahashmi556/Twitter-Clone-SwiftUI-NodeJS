//
//  TweetService.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 04/09/2026.
//

import Foundation

final class TweetService: TweetServiceProtocol {
    
    let client = APIClient.shared
    let baseURL = "http://localhost:3000/tweets"
    let headers: [String : String] = [
        "Content-Type" : "application/json",
        "Accept" : "application/json",
        
    ]
    
    func createTweet(request: TweetRequest) async throws -> TweetResponse {
        let body = try JSONEncoder().encode(request)
        var headers = headers
        if let jwt = UserDefaults.jwt {
            headers["Authorization"] = "Bearer \(jwt)"
        }
        return try await client.request(baseURL, method: .post, headers: headers, body: body)
    }
}
