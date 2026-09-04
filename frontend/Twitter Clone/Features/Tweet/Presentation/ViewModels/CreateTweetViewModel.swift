//
//  CreateTweetViewModel.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 04/09/2026.
//

import Foundation
import Combine

final class CreateTweetViewModel: ObservableObject {
    
    @Published var text = ""
    @Published var image: Data? = nil
    @Published private(set) var isLoading = false
    
    let service: TweetServiceProtocol
    let user: UserModel
    
    init(service: TweetServiceProtocol, user: UserModel) {
        self.service = service
        self.user = user
    }
    
    func post(success: @escaping(Tweet) -> Void) {
        isLoading = true
        Task { @MainActor in
            do {
                let imageBuffer = image?.base64EncodedString()
                let request = TweetRequest(text: text, user: user, image: imageBuffer)
                let response = try await service.createTweet(request: request)
                success(response.tweet)
            }
            catch {
                AlertManager.shared.showAlert(error: error)
            }
            isLoading = false
        }
    }
}
