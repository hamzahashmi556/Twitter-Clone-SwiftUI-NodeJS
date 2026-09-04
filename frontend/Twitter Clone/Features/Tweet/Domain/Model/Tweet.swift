//
//  Tweet.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 04/09/2026.
//

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
}

struct TweetImage: Decodable {
    var type: String
    var buffer: String
}

struct TweetResponse: Decodable {
    var tweet: Tweet
}

struct TweetRequest: Encodable {
    var text: String
    var user: String
    var userId: String
    var userName: String
    var image: String?
    
    init(text: String, user: UserModel, image: String?) {
        self.text = text
        self.user = user.name
        self.userId = user.id
        self.userName = user.userName
        self.image = image
    }
}
