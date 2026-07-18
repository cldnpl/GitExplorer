//
//  Color+Theme.swift
//  gitexplorer
//
//  Palette del design (Figma - Dawn Dev case).
//

import SwiftUI

extension Color {
    /// Inizializza un colore da un valore esadecimale RGB (es. `0x333C52`).
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}

/// Colori del design, centralizzati per coerenza e per riflettere il Figma.
enum AppColor {
    /// Testo principale (titoli, nomi repository).
    static let textPrimary = Color(hex: 0x333C52)
    /// Testo secondario (descrizioni, conteggi, placeholder).
    static let textSecondary = Color(hex: 0x999DA8)
    /// Sfondo del campo di ricerca.
    static let searchField = Color(hex: 0xF2F3F7)
    /// Linee divisorie.
    static let divider = Color(hex: 0xE6E6E6)
}
