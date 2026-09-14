//
//  NotificationViewModel.swift
//  Twitter Clone
//
//  Created by Codex on 14/09/2026.
//

import Combine
import Foundation

@MainActor
final class NotificationViewModel {
    @Published private(set) var notifications: [Notification] = []
    @Published private(set) var isLoading = false

    private let notificationService: NotificationServiceProtocol

    init(notificationService: NotificationServiceProtocol) {
        self.notificationService = notificationService
    }
    
    func createNotification(text: String?, user: UserModel, otherUserID: String, type: NotificationType) async throws {
        let notification = NotificationRequest(
            text: text,
            userName: user.userName,
            senderId: user.id,
            receiverId: otherUserID,
            notificationType: type
        )
        let response = try await notificationService.post(request: notification)
        print("Notification Sent: \(response)")
    }

    func fetchNotifications(userID: String?) {
        guard let userID, !userID.isEmpty else {
            notifications = []
            return
        }

        isLoading = true
        Task { @MainActor in
            defer { isLoading = false }

            do {
                notifications = try await notificationService.get(userID: userID)
            } catch {
                notifications = []
                AlertManager.shared.showAlert(title: "Notifications Failed", error: error)
            }
        }
    }
}
