//
//  APIError.swift
//  gitexplorer
//
//  Errori tipizzati del layer di rete.
//

import Foundation

/// Errori del client GitHub, mappati in messaggi mostrabili all'utente.
///
/// Il rate limit è modellato esplicitamente: l'API pubblica anonima di GitHub
/// limita le ricerche a ~10/minuto e va gestito senza far crashare l'app.
enum APIError: Error, Equatable, LocalizedError {
    case invalidURL
    case invalidResponse
    case rateLimited
    case http(Int)
    case decoding
    case transport

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Indirizzo della richiesta non valido."
        case .invalidResponse:
            return "Risposta del server non valida."
        case .rateLimited:
            return "Troppe richieste a GitHub. Riprova tra poco."
        case .http(let code):
            return "Errore dal server (codice \(code))."
        case .decoding:
            return "Impossibile leggere i dati ricevuti."
        case .transport:
            return "Problema di connessione. Controlla la rete."
        }
    }
}
