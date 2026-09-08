//
//  UserService.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


final class UserService: UserServiceProtocol {
    
    let client = APIClient.shared
    
    private let baseURL = "http://localhost:3000/users"
    
    func getUser(id: String) async throws -> UserModel {
        let endpoint = baseURL + "/" + id
        return try await client.request(endpoint, method: .get, headers: [:], body: nil)
    }
}