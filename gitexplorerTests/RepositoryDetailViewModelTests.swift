//
//  RepositoryDetailViewModelTests.swift
//  gitexplorerTests
//

import Testing
@testable import gitexplorer

@MainActor
struct RepositoryDetailViewModelTests {
    /// Con una release disponibile lo stato diventa `.loaded` col tag corretto,
    /// e la chiamata usa owner e nome del repository.
    @Test func loadsReleaseTag() async {
        let mock = MockGitHubService(releaseResult: .success(Release(tagName: "v5.50.2")))
        let viewModel = RepositoryDetailViewModel(repository: .stub(), service: mock)

        await viewModel.loadLatestRelease()

        #expect(viewModel.releaseState == .loaded("v5.50.2"))
        #expect(mock.lastReleaseOwner == "swiftlang")
        #expect(mock.lastReleaseRepo == "swift")
    }

    /// Repository senza release: stato `.unavailable`.
    @Test func noReleaseProducesUnavailable() async {
        let mock = MockGitHubService(releaseResult: .success(nil))
        let viewModel = RepositoryDetailViewModel(repository: .stub(), service: mock)

        await viewModel.loadLatestRelease()

        #expect(viewModel.releaseState == .unavailable)
    }

    /// Un errore di rete non blocca la UI: stato `.unavailable`.
    @Test func errorProducesUnavailable() async {
        let mock = MockGitHubService(releaseResult: .failure(APIError.transport))
        let viewModel = RepositoryDetailViewModel(repository: .stub(), service: mock)

        await viewModel.loadLatestRelease()

        #expect(viewModel.releaseState == .unavailable)
    }
}
