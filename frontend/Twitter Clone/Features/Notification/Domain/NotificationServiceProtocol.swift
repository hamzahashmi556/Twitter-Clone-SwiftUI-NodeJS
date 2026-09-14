//
//  NotificationService.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 14/09/2026.
//

protocol NotificationServiceProtocol {
    
    func post(request: NotificationRequest) async throws -> Notification
    
    func get(userID: String) async throws -> [Notification]
}
