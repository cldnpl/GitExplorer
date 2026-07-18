//
//  MockGitHubService.swift
//  gitexplorerTests
//
//  Doppio di test del client GitHub: restituisce risultati/errori stub,
//  senza toccare la rete.
//

import Foundation
@testable import gitexplorer

/// Implementazione di `GitHubServicing` per i test.
///
/// Permette di configurare i risultati e di ispezionare le chiamate ricevute.
final class MockGitHubService: GitHubServicing, @unchecked Sendable {
    var searchResult: Result<SearchResponse, Error>
    var releaseResult: Result<Release?, Error>

    private(set) var searchCallCount = 0
    private(set) var lastSearchQuery: String?
    private(set) var lastReleaseOwner: String?
    private(set) var lastReleaseRepo: String?

    init(
        searchResult: Result<SearchResponse, Error> = .success(SearchResponse(totalCount: 0, items: [])),
        releaseResult: Result<Release?, Error> = .success(nil)
    ) {
        self.searchResult = searchResult
        self.releaseResult = releaseResult
    }

    func searchRepositories(query: String) async throws -> SearchResponse {
        searchCallCount += 1
        lastSearchQuery = query
        return try searchResult.get()
    }

    func latestRelease(owner: String, repo: String) async throws -> Release? {
        lastReleaseOwner = owner
        lastReleaseRepo = repo
        return try releaseResult.get()
    }
}

extension Repository {
    /// Repository di comodo per i test.
    static func stub(
        id: Int = 1,
        name: String = "swift",
        fullName: String = "swiftlang/swift",
        ownerLogin: String = "swiftlang",
        avatarURL: URL? = nil,
        description: String? = "The Swift Programming Language",
        language: String? = "Swift",
        forks: Int = 0,
        issues: Int = 0,
        stars: Int = 0
    ) -> Repository {
        Repository(
            id: id,
            name: name,
            fullName: fullName,
            owner: Owner(login: ownerLogin, avatarURL: avatarURL),
            description: description,
            language: language,
            forksCount: forks,
            openIssuesCount: issues,
            stargazersCount: stars
        )
    }
}
