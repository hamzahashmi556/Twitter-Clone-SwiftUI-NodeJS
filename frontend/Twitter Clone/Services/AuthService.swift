//
//  AuthService.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import Foundation

protocol AuthServiceProtocol {
    
    func register(value: UserRequest) async throws -> UserResponse
}

class AuthService: AuthServiceProtocol {
    
    let session = URLSession.shared
    let baseURL = "http://localhost:3000/users"
    let client = APIClient.shared
    
    let headers: [String : String] = [
        "Content-Type" : "application/json",
        "Accept" : "application/json"
    ]
    
    func register(value: UserRequest) async throws -> UserResponse {
        let data = try JSONEncoder().encode(value)
        let response: UserResponse = try await client.request(baseURL, method: .post, headers: headers, body: data)
        return response
    }
}
