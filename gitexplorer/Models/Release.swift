//
//  Release.swift
//  gitexplorer
//
//  Ultima release pubblicata di un repository.
//

import Foundation

/// Ultima release di un repository (`GET /repos/{owner}/{repo}/releases/latest`).
///
/// Serve a mostrare la "last release version" nella schermata di dettaglio.
struct Release: Codable, Equatable, Sendable {
    let tagName: String

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
    }
}
