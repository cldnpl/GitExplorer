//
//  SearchView.swift
//  gitexplorer
//
//  Schermata 2 — Search Repositories.
//

import SwiftUI

/// Schermata di ricerca dei repository.
///
/// Step 3b: la digitazione avvia la ricerca reale (con debounce e soglia di 3
/// caratteri gestiti da `SearchViewModel`) e la vista reagisce allo `ViewState`.
/// Le righe dei risultati sono ancora provvisorie: il layout definitivo (avatar,
/// fallback folder, descrizione) arriva nello step 3c.
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Repository library")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppColor.textPrimary)

                searchField

                content
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Repository.self) { repository in
                RepositoryDetailView(repository: repository)
            }
        }
    }

    // MARK: - Campo di ricerca

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColor.textSecondary)

            TextField("Search for repository", text: $viewModel.query)
                .foregroundStyle(AppColor.textPrimary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onChange(of: viewModel.query) {
                    viewModel.queryDidChange()
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(AppColor.searchField, in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Contenuto (dipende dallo stato)

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            emptyState

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let repositories):
            resultsList(repositories)

        case .empty:
            message(
                title: "No repositories found",
                subtitle: "Try a different search term."
            )

        case .failed(let errorMessage):
            message(
                title: "Something went wrong",
                subtitle: errorMessage,
                systemImage: "exclamationmark.triangle"
            )
        }
    }

    private func resultsList(_ repositories: [Repository]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(viewModel.resultCount) results")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)

            List(repositories) { repository in
                RepositoryRowView(repository: repository)
                    .background(
                        // Link nello sfondo: rende la riga navigabile senza mostrare
                        // il chevron di default, assente nel design.
                        NavigationLink(value: repository) { EmptyView() }
                            .opacity(0)
                    )
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Stati testuali

    private var emptyState: some View {
        EmptyStateView()
    }

    private func message(title: String, subtitle: String, systemImage: String = "magnifyingglass") -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(AppColor.textSecondary)

            Text(title)
                .font(.headline)
                .foregroundStyle(AppColor.textPrimary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchView()
}
