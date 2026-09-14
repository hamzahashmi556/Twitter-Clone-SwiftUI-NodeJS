//
//  Notification.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

import Foundation

struct Notification: Decodable {
    var _id: String
    var id: String { _id }
    var text: String?
    var userName: String
    var senderId: String
    var receiverId: String
    var notificationType: NotificationType
}

struct NotificationRequest: Encodable {
    var text: String?
    var userName: String
    var senderId: String
    var receiverId: String
    var notificationType: NotificationType
}

enum NotificationType: String, Codable {
    case like
    case follow
    
    var message: String {
        switch self {
        case .like:
            "Liked your tweet."
        case .follow:
            "Followed you."
        }
    }
}
