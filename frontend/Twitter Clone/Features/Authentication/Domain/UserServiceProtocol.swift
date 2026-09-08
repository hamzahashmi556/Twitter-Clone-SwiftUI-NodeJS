//
//  UserServiceProtocol.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import Foundation

protocol UserServiceProtocol {
    
    func getUser(id: String) async throws -> UserModel
    
    func updateProfilePicture(image: Data) async throws -> UserImageResponse
    
    func updateUser(id: String, request: UserUpdateRequest) async throws -> UserModel
}
