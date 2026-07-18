//
//  RepositoryIconView.swift
//  gitexplorer
//
//  Icona di un repository: avatar remoto con fallback all'icona folder.
//

import SwiftUI

/// Icona di un repository.
///
/// Mostra l'avatar del proprietario se disponibile; in assenza di URL o in caso
/// di errore di caricamento usa l'icona folder di default, come richiesto dal case.
struct RepositoryIconView: View {
    let avatarURL: URL?
    var size: CGFloat = 44

    var body: some View {
        Group {
            if let avatarURL {
                AsyncImage(url: avatarURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .empty:
                        // Caricamento in corso: placeholder neutro (niente flash di folder).
                        AppColor.searchField
                    case .failure:
                        DefaultRepositoryIcon()
                    @unknown default:
                        DefaultRepositoryIcon()
                    }
                }
            } else {
                DefaultRepositoryIcon()
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

/// Icona folder di default (repository senza avatar), fedele al Figma:
/// glifo teal su sfondo mint chiaro.
struct DefaultRepositoryIcon: View {
    var body: some View {
        ZStack {
            AppColor.folderIconBackground
            Image(systemName: "folder.fill")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(AppColor.folderIconTint)
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        RepositoryIconView(avatarURL: URL(string: "https://avatars.githubusercontent.com/u/4223"))
        RepositoryIconView(avatarURL: nil)
    }
    .padding()
}
