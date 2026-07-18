//
//  SearchResponse.swift
//  gitexplorer
//
//  Risposta dell'endpoint di ricerca repository di GitHub.
//

import Foundation

/// Risposta di `GET /search/repositories`.
///
/// `totalCount` viene usato per mostrare il numero di risultati richiesto dal case.
struct SearchResponse: Codable, Equatable, Sendable {
    let totalCount: Int
    let items: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
