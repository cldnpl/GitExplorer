//
//  GitHubServicing.swift
//  gitexplorer
//
//  Astrazione del client GitHub, per rendere i view model testabili con un mock.
//

import Foundation

/// Interfaccia del client GitHub.
///
/// I view model dipendono da questo protocollo (non dall'implementazione
/// concreta), così nei test si può iniettare un mock senza toccare la rete.
protocol GitHubServicing: Sendable {
    /// Cerca repository che corrispondono alla query.
    ///
    /// Restituisce l'intera `SearchResponse` così da esporre anche il numero
    /// totale di risultati (`total_count`), usato nella UI.
    func searchRepositories(query: String) async throws -> SearchResponse

    /// Ultima release del repository, oppure `nil` se non ne esistono.
    func latestRelease(owner: String, repo: String) async throws -> Release?
}
