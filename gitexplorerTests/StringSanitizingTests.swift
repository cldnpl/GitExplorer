//
//  StringSanitizingTests.swift
//  gitexplorerTests
//

import Testing
@testable import gitexplorer

struct StringSanitizingTests {
    @Test func removesUnicodeEmoji() {
        #expect("🚀 Strapi is the leading".removingEmoji() == "Strapi is the leading")
    }

    @Test func removesGitHubShortcodes() {
        #expect(":mortar_board: List of examples".removingEmoji() == "List of examples")
    }

    @Test func keepsPlainText() {
        #expect("The Swift Programming Language".removingEmoji() == "The Swift Programming Language")
    }

    /// Orari e rapporti non devono essere scambiati per shortcode.
    @Test func keepsTimesAndRatios() {
        #expect("build at 12:30 ratio 3:4".removingEmoji() == "build at 12:30 ratio 3:4")
    }

    /// Gli spazi lasciati da un'emoji rimossa vengono normalizzati.
    @Test func collapsesWhitespaceLeftByRemoval() {
        #expect("A 🚀 B".removingEmoji() == "A B")
    }

    @Test func returnsEmptyForEmojiOnly() {
        #expect("🚀🔥".removingEmoji() == "")
    }
}
