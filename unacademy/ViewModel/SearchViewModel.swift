//
//  ViewModel.swift
//  unacademy
//
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [GitHubUserBrief] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private var searchTask: Task<Void, Never>? = nil
    
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }

    func debounceSearch() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            await searchUsers()
        }
    }

    func searchUsers() async {
        guard !query.isEmpty else {
            results = []
            errorMessage = nil
            return
        }

        isLoading = true
        defer { isLoading = false }

        guard let url = GitHubAPI.searchUsers(query: query).url else { return }

        do {
            let response = try await network.fetch(GitHubUserSearchResponse.self, from: url)
            self.results = response.items
            self.errorMessage = response.items.isEmpty ? "No users found." : nil
        } catch {
            self.results = []
        }
    }
}
