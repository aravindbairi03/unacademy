//
//  NetworkManager.swift
//  unacademy


import Foundation

enum GitHubAPI {
    static let baseURL = "https://api.github.com"

    case searchUsers(query: String)
    case userDetails(username: String)
    case userRepositories(username: String)

    var url: URL? {
        switch self {
        case .searchUsers(let query):
            return URL(string: "\(GitHubAPI.baseURL)/search/users?q=\(query)")
        case .userDetails(let username):
            return URL(string: "\(GitHubAPI.baseURL)/users/\(username)")
        case .userRepositories(let username):
            return URL(string: "\(GitHubAPI.baseURL)/users/\(username)/repos")
        }
    }
}

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding failed: \(error)")
            throw error
        }
    }
}
