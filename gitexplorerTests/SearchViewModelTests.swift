//
//  SearchViewModelTests.swift
//  gitexplorerTests
//

import Foundation
import Testing
@testable import gitexplorer

@MainActor
struct SearchViewModelTests {
    /// Sotto i 3 caratteri non deve partire nessuna ricerca.
    @Test func belowThresholdDoesNotSearch() async {
        let mock = MockGitHubService()
        let viewModel = SearchViewModel(service: mock, debounceMilliseconds: 0)

        viewModel.query = "sw"
        viewModel.queryDidChange()

        #expect(viewModel.state == .idle)
        #expect(mock.searchCallCount == 0)
    }

    /// La query viene ripulita dagli spazi prima di applicare la soglia.
    @Test func whitespaceIsTrimmedBeforeThreshold() async {
        let mock = MockGitHubService()
        let viewModel = SearchViewModel(service: mock, debounceMilliseconds: 0)

        viewModel.query = "  a  " // dopo il trim è 1 carattere
        viewModel.queryDidChange()

        #expect(viewModel.state == .idle)
        #expect(mock.searchCallCount == 0)
    }

    /// Con almeno 3 caratteri parte la ricerca e si popolano risultati e conteggio.
    @Test func atThresholdLoadsResultsWithCount() async {
        let repository = Repository.stub()
        let mock = MockGitHubService(
            searchResult: .success(SearchResponse(totalCount: 128, items: [repository]))
        )
        let viewModel = SearchViewModel(service: mock, debounceMilliseconds: 0)

        viewModel.query = "swift"
        viewModel.queryDidChange()
        await viewModel.debounceTask?.value

        #expect(mock.searchCallCount == 1)
        #expect(mock.lastSearchQuery == "swift")
        #expect(viewModel.resultCount == 128)
        #expect(viewModel.state == .loaded([repository]))
    }

    /// Zero risultati produce lo stato `empty`.
    @Test func emptyResultsProduceEmptyState() async {
        let mock = MockGitHubService(
            searchResult: .success(SearchResponse(totalCount: 0, items: []))
        )
        let viewModel = SearchViewModel(service: mock, debounceMilliseconds: 0)

        viewModel.query = "zzzzz"
        viewModel.queryDidChange()
        await viewModel.debounceTask?.value

        #expect(viewModel.state == .empty)
    }

    /// Un errore del service produce lo stato `failed` (senza crash).
    @Test func serviceErrorProducesFailedState() async {
        let mock = MockGitHubService(searchResult: .failure(APIError.rateLimited))
        let viewModel = SearchViewModel(service: mock, debounceMilliseconds: 0)

        viewModel.query = "swift"
        viewModel.queryDidChange()
        await viewModel.debounceTask?.value

        guard case .failed = viewModel.state else {
            Issue.record("Atteso stato .failed, ottenuto \(viewModel.state)")
            return
        }
    }
}
