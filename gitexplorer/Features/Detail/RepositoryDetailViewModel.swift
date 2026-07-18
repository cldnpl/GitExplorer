//
//  RepositoryDetailViewModel.swift
//  gitexplorer
//
//  Logica della schermata di dettaglio: caricamento dell'ultima release.
//

import Combine
import Foundation

/// View model della schermata di dettaglio.
///
/// I dati principali del repository sono già disponibili dalla ricerca; qui
/// carichiamo l'unica informazione mancante, l'ultima release, con una chiamata
/// dedicata all'API. Dipende da `GitHubServicing`, quindi è testabile con un mock.
@MainActor
final class RepositoryDetailViewModel: ObservableObject {
    /// Stato del caricamento dell'ultima release.
    enum ReleaseState: Equatable {
        case loading
        case loaded(String)   // tag della release (es. "v4.15.5")
        case unavailable      // repository senza release pubblicate
    }

    let repository: Repository
    @Published private(set) var releaseState: ReleaseState = .loading

    private let service: GitHubServicing

    init(repository: Repository, service: GitHubServicing = GitHubService()) {
        self.repository = repository
        self.service = service
    }

    func loadLatestRelease() async {
        releaseState = .loading
        do {
            let release = try await service.latestRelease(
                owner: repository.owner.login,
                repo: repository.name
            )
            releaseState = release.map { .loaded($0.tagName) } ?? .unavailable
        } catch {
            // In caso di errore mostriamo comunque "nessuna release" invece di bloccare la UI.
            releaseState = .unavailable
        }
    }
}
