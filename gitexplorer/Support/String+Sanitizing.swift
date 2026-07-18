//
//  String+Sanitizing.swift
//  gitexplorer
//
//  Pulizia del testo proveniente dall'API (descrizioni repository).
//

import Foundation

extension String {
    /// Restituisce la stringa senza emoji.
    ///
    /// Le descrizioni dei repository GitHub contengono spesso emoji, sia come
    /// caratteri Unicode (🚀) sia come shortcode testuali (`:rocket:`).
    /// Qui rimuoviamo entrambe le forme e normalizziamo gli spazi risultanti.
    func removingEmoji() -> String {
        // 1. Rimuove gli shortcode tipo :rocket: / :mortar_board: (primo carattere lettera,
        //    così da non intaccare orari o rapporti come 12:30 o 3:4).
        var result = replacingOccurrences(
            of: ":[a-zA-Z][a-zA-Z0-9_+-]*:",
            with: "",
            options: .regularExpression
        )

        // 2. Rimuove i caratteri emoji Unicode (e i relativi modificatori/selettori).
        result = String(String.UnicodeScalarView(result.unicodeScalars.filter { !$0.isEmojiComponent }))

        // 3. Normalizza gli spazi lasciati dalle rimozioni.
        result = result.replacingOccurrences(
            of: "\\s{2,}",
            with: " ",
            options: .regularExpression
        )
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private extension Unicode.Scalar {
    /// Indica se lo scalar fa parte di un'emoji (pittogramma, modificatore o selettore),
    /// escludendo cifre e simboli ASCII che `isEmoji` marca erroneamente.
    var isEmojiComponent: Bool {
        if value == 0x200D { return true }              // Zero Width Joiner
        if (0xFE00...0xFE0F).contains(value) { return true } // Variation Selectors
        if (0x1F000...0x1FAFF).contains(value) { return true } // pittogrammi vari
        if (0x2600...0x27BF).contains(value) { return true }   // simboli misti & dingbats
        if properties.isEmojiPresentation { return true }
        if properties.isEmojiModifier || properties.isEmojiModifierBase { return true }
        // `isEmoji` è true anche per 0-9, #, *: li teniamo filtrando i valori bassi.
        if properties.isEmoji && value > 0x238C { return true }
        return false
    }
}
