//
//  Owner.swift
//  gitexplorer
//
//  Proprietario (utente o organizzazione) di un repository GitHub.
//

import Foundation

/// Proprietario di un repository: usato per il nome dell'organizzazione e per
/// l'avatar mostrato come icona del repository.
struct Owner: Codable, Hashable, Sendable {
    let login: String
    let avatarURL: URL?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
