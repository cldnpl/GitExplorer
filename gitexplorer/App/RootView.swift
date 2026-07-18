//
//  RootView.swift
//  gitexplorer
//
//  Root della UI: gestisce il passaggio dalla Splash alla schermata principale.
//

import SwiftUI

/// Vista radice dell'app.
///
/// Gestisce la fase di avvio: mostra la `SplashView` al cold start per almeno
/// 3 secondi, poi passa alla schermata principale. Essendo la radice, la splash
/// compare solo una volta all'avvio e non ai cambi di navigazione interni.
struct RootView: View {
    private enum Phase {
        case splash
        case main
    }

    @State private var phase: Phase = .splash

    var body: some View {
        Group {
            switch phase {
            case .splash:
                SplashView()
                    .task {
                        // Requisito: la splash resta visibile per almeno 3 secondi.
                        try? await Task.sleep(for: .seconds(3))
                        phase = .main
                    }
            case .main:
                // Placeholder temporaneo: nel prossimo step diventa la Search screen.
                Text("Search screen — prossimo step")
                    .foregroundStyle(.secondary)
            }
        }
        .animation(.easeInOut, value: phase)
    }
}

#Preview {
    RootView()
}
