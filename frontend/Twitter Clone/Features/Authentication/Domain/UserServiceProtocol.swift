//
//  UserServiceProtocol.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


protocol UserServiceProtocol {
    func getUser(id: String) async throws -> UserModel
}
