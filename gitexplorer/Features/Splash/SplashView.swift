//
//  SplashView.swift
//  gitexplorer
//
//  Schermata 1 — Splash / Loading.
//

import SwiftUI

/// Schermata iniziale mostrata al cold start dell'app.
///
/// Requisiti (dal case Dawn Health):
/// 1. Mostrata solo al cold start.
/// 2. Visibile per almeno 3 secondi.
/// 3. Icona centrata nello schermo.
struct SplashView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()

            // NOTA: placeholder. Va sostituito con l'icona ufficiale
            // esportata dal Figma (Export → SVG/PNG) una volta disponibile.
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
                .foregroundStyle(.tint)
                .accessibilityLabel("GitExplorer")
        }
    }
}

#Preview {
    SplashView()
}
