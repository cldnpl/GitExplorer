//
//  RepositoryDetailView.swift
//  gitexplorer
//
//  Schermata 3 — Show Repository.
//

import SwiftUI

/// Schermata di dettaglio di un repository.
///
/// Step 4a: mostra i dati già disponibili dalla ricerca (icona, "org/nome",
/// linguaggio, forks, issues, stargazers). L'ultima release verrà caricata
/// nello step 4b tramite un view model dedicato.
struct RepositoryDetailView: View {
    @StateObject private var viewModel: RepositoryDetailViewModel

    @Environment(\.dismiss) private var dismiss

    private var repository: Repository { viewModel.repository }

    init(repository: Repository, service: GitHubServicing = GitHubService()) {
        _viewModel = StateObject(
            wrappedValue: RepositoryDetailViewModel(repository: repository, service: service)
        )
    }

    var body: some View {
        VStack(spacing: 28) {
            backButton

            header

            statsCard

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadLatestRelease()
        }
    }

    // MARK: - Back

    private var backButton: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColor.textSecondary)
            }
            .accessibilityLabel("Back")

            Spacer()
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
            RepositoryIconView(avatarURL: repository.owner.avatarURL, size: 104)

            VStack(spacing: 4) {
                Text(repository.displayTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                    .multilineTextAlignment(.center)

                if let language = repository.language {
                    Text(language)
                        .font(.system(size: 15))
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Stats card

    private var statsCard: some View {
        VStack(spacing: 0) {
            statRow("Forks", value: repository.forksCount.formatted(.number))
            divider
            statRow("Issues", value: repository.openIssuesCount.formatted(.number))
            divider
            statRow("Stared by", value: repository.stargazersCount.formatted(.number))
            divider
            lastReleaseRow
        }
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background)
                .stroke(AppColor.divider, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    /// Riga dell'ultima release: mostra uno spinner durante il caricamento,
    /// il tag della release se presente, oppure "—" se il repository non ne ha.
    private var lastReleaseRow: some View {
        HStack {
            Text("Last release version")
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            switch viewModel.releaseState {
            case .loading:
                ProgressView()
            case .loaded(let tag):
                Text(tag)
                    .foregroundStyle(AppColor.textPrimary)
            case .unavailable:
                Text("—")
                    .foregroundStyle(AppColor.textPrimary)
            }
        }
        .font(.system(size: 15))
        .padding(.vertical, 18)
    }

    private func statRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            Text(value)
                .foregroundStyle(AppColor.textPrimary)
        }
        .font(.system(size: 15))
        .padding(.vertical, 18)
    }

    private var divider: some View {
        Rectangle()
            .fill(AppColor.divider)
            .frame(height: 1)
    }
}

#Preview {
    RepositoryDetailView(
        repository: Repository(
            id: 1,
            name: "strapi",
            fullName: "strapi/strapi",
            owner: Owner(login: "strapi", avatarURL: nil),
            description: "Open source Node.js Headless CMS",
            language: "JavaScript",
            forksCount: 203,
            openIssuesCount: 3700,
            stargazersCount: 38952
        )
    )
}
