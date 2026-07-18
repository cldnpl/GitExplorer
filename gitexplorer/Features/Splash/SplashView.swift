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
///
/// Lo sfondo è volutamente chiaro e fisso: il logo è in navy/teal e su uno
/// sfondo scuro (dark mode) risulterebbe illeggibile. Uno splash brandizzato
/// con sfondo chiaro è la convenzione tipica.
struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 220)
                .accessibilityLabel("GitExplorer")
        }
    }
}

#Preview {
    SplashView()
}
