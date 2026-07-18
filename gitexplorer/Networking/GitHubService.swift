//
//  GitHubService.swift
//  gitexplorer
//
//  Implementazione del client GitHub basata su URLSession.
//

import Foundation

/// Implementazione concreta di `GitHubServicing` basata su `URLSession`.
///
/// La sessione è iniettata (default `.shared`) per poter essere sostituita nei
/// test con una `URLSession` configurata con un `URLProtocol` stub.
struct GitHubService: GitHubServicing {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func searchRepositories(query: String) async throws -> [Repository] {
        let response: SearchResponse = try await get(.searchRepositories(query: query))
        return response.items
    }

    func latestRelease(owner: String, repo: String) async throws -> Release? {
        do {
            return try await get(.latestRelease(owner: owner, repo: repo))
        } catch APIError.http(404) {
            // Nessuna release pubblicata: caso valido, non un errore.
            return nil
        }
    }

    // MARK: - Richiesta generica

    private func get<T: Decodable>(_ endpoint: GitHubEndpoint) async throws -> T {
        guard let url = endpoint.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            break
        case 403, 429:
            // GitHub risponde 403 (o 429) quando si supera il rate limit anonimo.
            throw APIError.rateLimited
        default:
            throw APIError.http(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}
