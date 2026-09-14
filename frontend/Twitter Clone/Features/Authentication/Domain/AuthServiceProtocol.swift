//
//  AuthServiceProtocol.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


protocol AuthServiceProtocol {
    
    func register(value: UserRequest) async throws -> LoginResponse
    
    func login(request: LoginRequest) async throws -> LoginResponse
}
