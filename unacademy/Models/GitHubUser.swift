//
//  Untitled.swift
//  unacademy

import Foundation

struct GitHubUserSearchResponse: Codable {
    let items: [GitHubUserBrief]
}

struct GitHubUserBrief: Codable, Identifiable {
    var id: Int { login.hashValue }
    let login: String
    let avatar_url: String
}

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
    let bio: String?
    let followers: Int
    let public_repos: Int
}
struct Repository: Codable, Identifiable {
    let id = UUID()
    let name: String
    let description: String?
    let stargazers_count: Int
    let forks_count: Int
}
