//
//  SearchView.swift
//  gitexplorer
//
//  Schermata 2 — Search Repositories.
//

import SwiftUI

/// Schermata di ricerca dei repository.
///
/// Step 3a: layout statico dello stato iniziale. All'apertura sono visibili
/// solo l'header "Repository library", il campo di ricerca e l'empty state,
/// come richiesto dal primo criterio di accettazione. La logica di ricerca
/// (debounce, soglia 3 caratteri, risultati) arriverà nello step successivo.
struct SearchView: View {
    @State private var query: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Repository library")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppColor.textPrimary)

                searchField

                emptyState
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Campo di ricerca

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColor.textSecondary)

            TextField("Search", text: $query)
                .foregroundStyle(AppColor.textPrimary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(AppColor.searchField, in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(AppColor.textSecondary)

            Text("Search the repository library")
                .font(.headline)
                .foregroundStyle(AppColor.textPrimary)

            Text("Type at least 3 characters to start searching.")
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
