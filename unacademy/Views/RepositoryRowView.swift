//
//  RepositoryRowView.swift
//  unacademy

import SwiftUI

struct RepositoryRowView: View {
    let repo: Repository

    var body: some View {
        VStack(alignment: .leading) {
            Text(repo.name).font(.headline)
                .foregroundColor(.blue)

            if let desc = repo.description {
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 16) {
                Label("\(repo.stargazers_count)", systemImage: "star.fill").foregroundColor(.yellow)
                Label("\(repo.forks_count)", systemImage: "tuningfork").foregroundColor(.blue)
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
