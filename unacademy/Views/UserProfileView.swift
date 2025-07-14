//
//  UserProfileView.swift
//  unacademy

import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    let username: String
    @StateObject private var viewModel = UserProfileViewModel()

    var body: some View {
        ScrollView {
            if let user = viewModel.user {
                VStack(spacing: 16) {
                    WebImage(url: URL(string: user.avatar_url))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())

                    Text(user.login)
                        .font(.title2).bold()

                    if let bio = user.bio {
                        Text(bio).italic().padding(.horizontal)
                    }

                    HStack {
                        StatView(title: "Followers", value: user.followers)
                        StatView(title: "Repos", value: user.public_repos)
                    }

                    Divider()

                    Text("Repositories")
                        .font(.headline)
                        .padding(.top)

                    ForEach(viewModel.repos) { repo in
                        RepositoryRowView(repo: repo)
                    }
                }
                .padding()
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else {
                ProgressView("Loading...")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(username)
                    .font(.headline)
                    .bold()
            }
        }
        .task {
            await viewModel.loadDetails(for: username)
        }
    }
}

struct StatView: View {
    let title: String
    let value: Int

    var body: some View {
        VStack {
            Text("\(value)").bold()
            Text(title).font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}


