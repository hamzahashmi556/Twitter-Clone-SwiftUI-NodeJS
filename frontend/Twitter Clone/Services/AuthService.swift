//
//  AuthService.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

import Foundation

protocol AuthServiceProtocol {
    
    func register(value: UserRequest) async throws -> UserModel
    
    func login(request: LoginRequest) async throws -> LoginResponse
}

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
    
    func register(value: UserRequest) async throws -> UserModel {
        let data = try JSONEncoder().encode(value)
        let response: UserModel = try await client.request(baseURL, method: .post, headers: headers, body: data)
        return response
    }
}
