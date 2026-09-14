//
//  AuthService.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import Foundation

class AuthService: AuthServiceProtocol {
    
    let session = URLSession.shared
    let baseURL = "http://localhost:3000/users"
    let client = APIClient.shared
    
    let headers: [String : String] = [
        "Content-Type" : "application/json",
        "Accept" : "application/json"
    ]
    
    func login(request: LoginRequest) async throws -> LoginResponse {
        let body = try JSONEncoder().encode(request)
        let endpoint = baseURL + "/login"
        return try await client.request(endpoint, method: .post, headers: headers, body: body)
    }
    
    func register(value: UserRequest) async throws -> LoginResponse {
        let data = try JSONEncoder().encode(value)
        return try await client.request(baseURL, method: .post, headers: headers, body: data)
    }
}
