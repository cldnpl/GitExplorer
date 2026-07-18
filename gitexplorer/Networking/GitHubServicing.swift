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
    func searchRepositories(query: String) async throws -> [Repository]

    /// Ultima release del repository, oppure `nil` se non ne esistono.
    func latestRelease(owner: String, repo: String) async throws -> Release?
}
