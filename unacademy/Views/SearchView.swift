//
//  SearchView.swift
//  unacademy
import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.results.isEmpty && viewModel.query.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "person.3.sequence")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        Text("Search GitHub Users")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text("Start typing a username above to find developers.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                } else {
                    if !viewModel.isLoading, let error = viewModel.errorMessage, !viewModel.query.isEmpty {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top)
                    }

                    List {
                        ForEach(viewModel.results) { user in
                            NavigationLink(destination: UserProfileView(username: user.login)) {
                                HStack {
                                    WebImage(url: URL(string: user.avatar_url))
                                        .resizable()
                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    Text(user.login)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("GitHub Users")
                        .font(.headline)
                        .bold()
                }
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .searchable(text: $viewModel.query)
            .onChange(of: viewModel.query) { 
                viewModel.debounceSearch()
            }
        }
    }
}


