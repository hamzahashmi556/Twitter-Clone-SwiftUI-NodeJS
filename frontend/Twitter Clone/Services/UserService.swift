//
//  UserService.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 03/09/2026.
//

protocol UserServiceProtocol {
    
    func getUser(id: String) async throws -> UserResponse
}

final class UserService: UserServiceProtocol {
    
    let client = APIClient.shared
    
    private let baseURL = "http://localhost:3000/users"
    
    func getUser(id: String) async throws -> UserResponse {
        let endpoint = baseURL + "/" + id
        return try await client.request(endpoint, method: .get, headers: [:], body: nil)
    }
}
