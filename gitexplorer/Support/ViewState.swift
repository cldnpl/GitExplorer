//
//  ViewState.swift
//  gitexplorer
//
//  Stato generico di una schermata guidata da dati remoti.
//

import Foundation

/// Stato di una vista che carica dati in modo asincrono.
///
/// Modellare gli stati esplicitamente (invece di più flag booleani sparsi)
/// rende la UI prevedibile e i view model facili da testare.
enum ViewState<Value: Equatable>: Equatable {
    /// Nessuna operazione in corso (es. query troppo corta): mostra l'empty state.
    case idle
    /// Caricamento in corso.
    case loading
    /// Dati caricati con successo.
    case loaded(Value)
    /// Operazione riuscita ma senza risultati.
    case empty
    /// Errore, con messaggio mostrabile all'utente.
    case failed(String)
}
