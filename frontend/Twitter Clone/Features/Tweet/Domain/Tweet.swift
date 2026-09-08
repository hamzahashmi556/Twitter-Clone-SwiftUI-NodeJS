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
    var image: TweetImage?
    var likes: [String]
    var createdAt: String
    var updatedAt: String
    
    init(_id: String, text: String, user: UserModel, image: TweetImage? = nil) {
        self._id = _id
        self.text = text
        self.user = user.name
        self.userId = user.id
        self.userName = user.userName
        self.image = image
        self.likes = []
        self.createdAt = Date().ISO8601Format()
        self.updatedAt = Date().ISO8601Format()
    }
}

struct TweetImage: Decodable {
    var type: String
    var data: [Int]
    
    init(data: [Int]) {
        self.type = "base64"
        self.data = data
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
