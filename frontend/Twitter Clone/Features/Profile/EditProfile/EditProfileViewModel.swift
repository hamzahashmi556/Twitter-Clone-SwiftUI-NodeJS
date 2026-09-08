//
//  EditProfileViewModel.swift
//  twitter-clone (iOS)
//
//  Created by cem on 12/7/21.
//

import Combine
import UIKit

class EditProfileViewModel: ObservableObject {
    
    var user: UserModel
    @Published var name: String
    @Published var location: String
    @Published var bio: String
    @Published var website: String
    
    let service: UserServiceProtocol
    
    init(user: UserModel, service: UserServiceProtocol) {
        self.user = user
        self.name = user.name
        self.location = user.location ?? ""
        self.bio = user.bio ?? ""
        self.website = user.website ?? ""
        self.service = service
    }
    
    func save(selectedImage: UIImage?, success: @escaping () -> Void) {
        Task {
            do {
                if let selectedImage, let image = selectedImage.jpegData(compressionQuality: 0.5) {
                    print("With image")
                    let response = try await service.updateProfilePicture(image: image)
                    AlertManager.shared.showAlert(title: "", message: response.message)
                    self.user = try await self.uploadUserData(name: name, bio: bio, website: website, location: location)
                }
                else {
                    print("Without image")
                    self.user = try await self.uploadUserData(name: name, bio: bio, website: website, location: location)
                }
                success()
            }
            catch {
                AlertManager.shared.showAlert(title: "Alert", error: error)
            }
        }
    }
    
    private func uploadUserData(name: String?, bio: String?, website: String?, location: String?) async throws -> UserModel {
        
        let userId = user.id
        
        let request = UserUpdateRequest(
            name: name,
            bio: bio,
            website: website,
            location: location
        )
        let response = try await service.updateUser(id: userId, request: request)
        return response
    }
}
