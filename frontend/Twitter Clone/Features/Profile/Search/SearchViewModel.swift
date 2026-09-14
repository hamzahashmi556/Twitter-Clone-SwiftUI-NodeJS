//
//  SearchViewModel.swift
//  Twitter Clone
//
//  Created by Codex on 14/09/2026.
//

import Foundation

@MainActor
final class SearchViewModel {
    private let userService: UserServiceProtocol

    private(set) var users: [UserModel] = []
    private(set) var isLoading = false

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    func searchUsers(query: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            users = try await userService.getUsers(searchQuery: query)
        } catch {
            users = []
            AlertManager.shared.showAlert(title: "Search Failed", error: error)
        }
    }
}
