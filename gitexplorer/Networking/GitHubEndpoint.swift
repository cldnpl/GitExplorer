//
//  GitHubEndpoint.swift
//  gitexplorer
//
//  Costruzione degli URL delle chiamate all'API GitHub.
//

import Foundation

/// Endpoint dell'API pubblica di GitHub usati dall'app.
///
/// Centralizza la costruzione degli URL così da tenerla fuori dal service e
/// poterla testare in isolamento. Tutto su HTTPS.
enum GitHubEndpoint: Equatable {
    case searchRepositories(query: String)
    case latestRelease(owner: String, repo: String)

    private static let baseURL = URL(string: "https://api.github.com")!

    var url: URL? {
        switch self {
        case .searchRepositories(let query):
            let base = Self.baseURL.appendingPathComponent("search/repositories")
            var components = URLComponents(url: base, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "q", value: query)]
            return components?.url
        case .latestRelease(let owner, let repo):
            return Self.baseURL.appendingPathComponent("repos/\(owner)/\(repo)/releases/latest")
        }
    }
}
