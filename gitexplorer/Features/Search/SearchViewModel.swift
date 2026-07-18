//
//  SearchViewModel.swift
//  gitexplorer
//
//  Logica della schermata di ricerca: debounce, soglia minima, stati.
//

import Combine
import Foundation

/// View model della schermata di ricerca.
///
/// Responsabilità:
/// - applica un *debounce* alla digitazione per non chiamare l'API a ogni tasto;
/// - avvia la ricerca solo con almeno `minimumQueryLength` caratteri;
/// - espone uno `ViewState` esplicito e il numero totale di risultati;
/// - annulla la ricerca precedente quando la query cambia (niente race).
///
/// Dipende dall'astrazione `GitHubServicing`, quindi è testabile con un mock.
@MainActor
final class SearchViewModel: ObservableObject {
    /// Numero minimo di caratteri per avviare la ricerca (requisito del case).
    static let minimumQueryLength = 3

    @Published var query: String = ""
    @Published private(set) var state: ViewState<[Repository]> = .idle
    @Published private(set) var resultCount: Int = 0

    private let service: GitHubServicing
    private let debounceMilliseconds: Int

    /// Task di ricerca in corso. `private(set)` (quindi `internal`) così i test
    /// possono attenderne il completamento in modo deterministico.
    private(set) var debounceTask: Task<Void, Never>?

    init(service: GitHubServicing = GitHubService(), debounceMilliseconds: Int = 350) {
        self.service = service
        self.debounceMilliseconds = debounceMilliseconds
    }

    /// Da invocare a ogni variazione del testo di ricerca.
    func queryDidChange() {
        debounceTask?.cancel()

        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard text.count >= Self.minimumQueryLength else {
            // Sotto la soglia: torna allo stato iniziale (empty state).
            state = .idle
            resultCount = 0
            return
        }

        debounceTask = Task { [weak self, debounceMilliseconds] in
            // Debounce: attende una breve pausa nella digitazione.
            try? await Task.sleep(for: .milliseconds(debounceMilliseconds))
            guard !Task.isCancelled else { return }
            await self?.search(text)
        }
    }

    private func search(_ text: String) async {
        state = .loading
        do {
            let response = try await service.searchRepositories(query: text)
            guard !Task.isCancelled else { return }
            resultCount = response.totalCount
            state = response.items.isEmpty ? .empty : .loaded(response.items)
        } catch {
            guard !Task.isCancelled else { return }
            let message = (error as? LocalizedError)?.errorDescription
                ?? "Something went wrong. Please try again."
            state = .failed(message)
        }
    }
}
