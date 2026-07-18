//
//  RepositoryRowView.swift
//  gitexplorer
//
//  Riga di un repository nella lista dei risultati di ricerca.
//

import SwiftUI

/// Riga della lista risultati: icona, header "org / name" e descrizione "About".
struct RepositoryRowView: View {
    let repository: Repository

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            RepositoryIconView(avatarURL: repository.owner.avatarURL)

            VStack(alignment: .leading, spacing: 4) {
                Text(repository.displayTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(1)

                if let description = repository.displayDescription {
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    RepositoryRowView(
        repository: Repository(
            id: 1,
            name: "strapi",
            fullName: "strapi/strapi",
            owner: Owner(login: "strapi", avatarURL: nil),
            description: "Open source Node.js Headless CMS to easily build customisable APIs",
            language: "JavaScript",
            forksCount: 0,
            openIssuesCount: 0,
            stargazersCount: 0
        )
    )
    .padding()
}
