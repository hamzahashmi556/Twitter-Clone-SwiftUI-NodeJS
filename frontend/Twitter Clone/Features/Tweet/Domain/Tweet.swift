//
//  Tweet.swift
//  Twitter-Clone-UIKit
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import Foundation


struct Tweet: Decodable, Identifiable {
    var id: String { _id }
    var _id: String
    var text: String
    var user: String
    var userId: String
    var userName: String
    var image: String?
    var likes: [String]
    var createdAt: String
    var updatedAt: String
    
    init(_id: String, text: String, user: UserModel) {
        self._id = _id
        self.text = text
        self.user = user.name
        self.userId = user.id
        self.userName = user.userName
        self.likes = []
        self.createdAt = Date().ISO8601Format()
        self.updatedAt = Date().ISO8601Format()
    }
}

struct TweetResponse: Decodable {
    var tweet: Tweet
}

struct TweetRequest: Encodable {
    var text: String
    var user: String
    var userId: String
    var userName: String
    
    init(text: String, user: UserModel) {
        self.text = text
        self.user = user.name
        self.userId = user.id
        self.userName = user.userName
    }
}

struct TweetImageResponse: Decodable {
    var message: String
    var tweet: Tweet
}
