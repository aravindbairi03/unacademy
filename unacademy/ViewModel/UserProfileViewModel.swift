//
//  UserProfileViewModel.swift
//  unacademy

import Foundation

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var user: GitHubUser?
    @Published var repos: [Repository] = []
    @Published var errorMessage: String?

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }

    func loadDetails(for username: String) async {
        do {
            guard let userURL = GitHubAPI.userDetails(username: username).url,
                  let repoURL = GitHubAPI.userRepositories(username: username).url else {
                throw URLError(.badURL)
            }

            async let userData: GitHubUser = network.fetch(GitHubUser.self, from: userURL)
            async let repoData: [Repository] = network.fetch([Repository].self, from: repoURL)

            self.user = try await userData
            self.repos = try await repoData
            self.errorMessage = nil
        } catch {
            self.user = nil
            self.repos = []
            self.errorMessage = "Failed to load user data."
        }
    }
}

