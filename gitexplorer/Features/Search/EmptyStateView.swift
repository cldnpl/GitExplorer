//
//  EmptyStateView.swift
//  gitexplorer
//
//  Empty state iniziale della schermata di ricerca (fedele al Figma).
//

import SwiftUI

/// Empty state mostrato quando non è ancora stata avviata una ricerca.
struct EmptyStateView: View {
    var title: String = "A little empty"
    var subtitle: String = "Search for a repository and\nsave it as favourite"

    var body: some View {
        VStack(spacing: 16) {
            FolderIllustration()
                .frame(width: 60, height: 54)

            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)

                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Illustrazione dell'empty state: una cartella piena (riempita) dietro e una
/// cartella tratteggiata davanti, come nel design.
private struct FolderIllustration: View {
    var body: some View {
        ZStack {
            FolderShape()
                .fill(AppColor.searchField)
                .frame(width: 46, height: 38)
                .offset(x: 6, y: -4)

            FolderShape()
                .stroke(
                    AppColor.textSecondary,
                    style: StrokeStyle(lineWidth: 1.5, lineJoin: .round, dash: [4, 3])
                )
                .frame(width: 46, height: 38)
                .offset(x: -6, y: 4)
        }
    }
}

/// Sagoma di una cartella con linguetta in alto a sinistra.
private struct FolderShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 4
        let tabWidth = rect.width * 0.42
        let tabHeight = rect.height * 0.22
        let bodyTop = rect.minY + tabHeight

        var path = Path()
        // Lato sinistro (parte dalla base della linguetta verso l'alto).
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + radius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        // Cima della linguetta.
        path.addLine(to: CGPoint(x: rect.minX + tabWidth - radius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + tabWidth + radius, y: bodyTop),
            control: CGPoint(x: rect.minX + tabWidth, y: bodyTop)
        )
        // Bordo superiore del corpo fino a destra.
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: bodyTop))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: bodyTop + radius),
            control: CGPoint(x: rect.maxX, y: bodyTop)
        )
        // Lato destro.
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - radius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        // Base.
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - radius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    EmptyStateView()
}
