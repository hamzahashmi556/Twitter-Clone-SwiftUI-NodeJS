//
//  NotificationService.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

import Foundation

final class NotificationService: NotificationServiceProtocol {
    
    let client = APIClient.shared
    let baseURL = "http://localhost:3000/notifications/"
    var headers: [String : String] = [
        "Content-Type" : "application/json",
        "Accept" : "application/json",
        
    ]
    
    init() {
        if let jwt = UserDefaults.jwt {
            headers["Authorization"] = "Bearer \(jwt)"
        }
    }
    
    func post(request: NotificationRequest) async throws -> Notification {
        let body = try JSONEncoder().encode(request)
        return try await client.request(
            baseURL,
            method: .post,
            headers: headers,
            body: body
        )
    }
    
    func get(userID: String) async throws -> [Notification] {
        return try await client.request(
            baseURL + userID,
            method: .get,
            headers: headers
        )
    }
}
