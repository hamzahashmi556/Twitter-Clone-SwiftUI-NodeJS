//
//  UserModel.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//


struct UserModel: Decodable, Identifiable {
    var id: String { return _id }
    var _id: String
    var name: String
    var userName: String
//    var tokens: [String]
//    var token: String?
    var email: String
    var password: String?
    var avatar: String?
    var avatarExists: Bool?
    var bio: String?
    var website: String?
    var location: String?
    var followers: [String]
    var followings: [String]
}

struct UserRequest: Encodable {
    var name: String
    var userName: String
    var email: String
    var password: String
    var avatar: String?
    var bio: String?
    var website: String?
    var location: String?
}

struct UserUpdateRequest: Encodable {
    var name: String?
    var email: String?
    var password: String?
    var bio: String?
    var website: String?
    var location: String?
}

struct UserImageResponse: Decodable {
    var message: String
}

struct LoginRequest: Encodable {
    var email: String
    var password: String
}

struct LoginResponse: Decodable {
    var token: String
    var user: UserModel
}
