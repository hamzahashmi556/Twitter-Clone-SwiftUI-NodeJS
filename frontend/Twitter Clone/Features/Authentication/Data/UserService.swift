//
//  UserService.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import Foundation

final class UserService: UserServiceProtocol {
    
    let client = APIClient.shared
    
    private let baseURL = "http://localhost:3000/users"
    
    var headers: [String : String] = [
        "Content-Type" : "application/json",
        "Accept" : "application/json",
    ]
    
    init() {
        if let jwt = UserDefaults.jwt {
            headers["Authorization"] = "Bearer \(jwt)"
        }
    }
    
    func getUser(id: String) async throws -> UserModel {
        let endpoint = baseURL + "/" + id
        return try await client.request(endpoint, method: .get, headers: [:], body: nil)
    }
    
    func updateProfilePicture(image: Data) async throws -> UserImageResponse {
        return try await ImageUploader.uploadMultipart(
            urlPath: baseURL + "/me/avatar",
            fileData: image,
            fileName: "profile_picture",
            paramName: "avatar"
        )
    }
    
    func updateUser(id: String, request: UserUpdateRequest) async throws -> UserModel {
        let body = try JSONEncoder().encode(request)
        return try await client.request(
            baseURL + "/\(id)",
            method: .patch,
            headers: headers,
            body: body
        )
    }
    
    func follow(userID: String) async throws -> UserModel {
        return try await client.request(
            "\(baseURL)/follow/\(userID)",
            method: .put,
            headers: headers
        )
    }
    
    func unfollow(userID: String) async throws -> UserModel {
        return try await client.request(
            "\(baseURL)/unfollow/\(userID)",
            method: .put,
            headers: headers
        )
    }
}
