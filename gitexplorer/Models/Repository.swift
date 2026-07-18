//
//  Repository.swift
//  gitexplorer
//
//  Modello di un repository GitHub e delle sue caratteristiche.
//

import Foundation

/// Un repository GitHub con le caratteristiche mostrate nelle schermate di
/// ricerca e di dettaglio.
struct Repository: Codable, Equatable, Identifiable, Sendable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    let stargazersCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case language
        case fullName = "full_name"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case stargazersCount = "stargazers_count"
    }
}

extension Repository {
    /// Nome dell'organizzazione, derivato da `full_name` ("org/repo").
    /// Fallback sul login del proprietario se il formato non fosse quello atteso.
    var organization: String {
        let first = fullName.split(separator: "/", maxSplits: 1).first.map(String.init)
        return first?.isEmpty == false ? first! : owner.login
    }

    /// Nome del repository, derivato da `full_name`; fallback su `name`.
    var repositoryName: String {
        let parts = fullName.split(separator: "/", maxSplits: 1).map(String.init)
        return parts.count > 1 ? parts[1] : name
    }

    /// Titolo formattato come richiesto dal case: "<organization> / <repository name>".
    var displayTitle: String {
        "\(organization) / \(repositoryName)"
    }
}
