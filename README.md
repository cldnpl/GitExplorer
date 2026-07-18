# GitExplorer

An iOS app (SwiftUI) that searches GitHub repositories and shows their main
characteristics. Built as a case for Dawn Health.

*This README is also available in [Danish](README.da.md).*

## Features

Three screens, as per the specification:

1. **Splash** — shown on cold start for at least 3 seconds, logo centred.
2. **Search** — search-ahead starting from 3 characters, with the number of
   results and, for each row, an icon (owner avatar or default folder icon), a
   header `<organization> / <repository name>` and the "About" description.
3. **Show Repository** — icon, `org/name`, language, forks, open issues,
   stargazers, latest release and a back button.

## Architecture

MVVM with SwiftUI and `NavigationStack`.

```
gitexplorer/
  App/         RootView (splash → main handling)
  Models/      Repository, Owner, SearchResponse, Release (Codable)
  Networking/  GitHubServicing (protocol) + GitHubService (URLSession),
               GitHubEndpoint, APIError
  Features/
    Splash/    SplashView
    Search/    SearchView, SearchViewModel, RepositoryRowView, EmptyStateView
    Detail/    RepositoryDetailView, RepositoryDetailViewModel
  Support/     Color+Theme, RepositoryIconView, ViewState, String+Sanitizing
```

**Principles followed**
- **Dependency inversion**: the view models depend on the `GitHubServicing`
  protocol, not on the implementation. This makes the logic testable with a mock,
  without networking (see `gitexplorerTests/`).
- **Explicit states**: `ViewState` (`idle`/`loading`/`loaded`/`empty`/`failed`)
  instead of scattered boolean flags → predictable UI.
- **Typed errors**: `APIError` with user-facing messages; GitHub's public API
  rate limit is handled explicitly (no crash).
- **Centralised design**: colours and reusable components taken from Figma.

## GitHub API

- Search: `GET https://api.github.com/search/repositories?q={query}`
- Latest release: `GET https://api.github.com/repos/{owner}/{repo}/releases/latest`
  (a 404 means "no release" and is handled as a valid case, not an error).

**Anonymous** calls (no token): the specification does not require one, so there
are no secrets in the code. Headers sent: `Accept: application/vnd.github+json`,
`X-GitHub-Api-Version` and `User-Agent` (required by GitHub). Anonymous limit:
~10 searches/minute, handled with an error message.

## Decisions and trade-offs

- **Debounce + 3-character threshold** in `SearchViewModel`, cancelling the
  previous search to avoid races on responses.
- **Number of results** = the API's `total_count` (the real number of matches),
  not the number of loaded rows. Numbers are formatted based on the locale.
- **Emoji removed** from descriptions: GitHub returns them both as Unicode
  characters and as shortcodes (`:rocket:`); they are cleaned up centrally in the
  model (`String.removingEmoji()`), covered by tests.
- **Default icon**: the folder illustration and the empty state are recreated in
  SwiftUI (vector) instead of using the Figma PNGs, to stay sharp at any
  resolution.

## Tests

`gitexplorerTests` target (Swift Testing):
- `SearchViewModelTests` — 3-character threshold, count, empty and error.
- `RepositoryParsingTests` — decoding of search and release, null optional fields.
- `RepositoryDetailViewModelTests` — release loading / absence / error.
- `StringSanitizingTests` — emoji and shortcode removal, preserving times/ratios.

Run:

```
xcodebuild test -project gitexplorer.xcodeproj -scheme gitexplorer \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:gitexplorerTests
```

## Use of AI tools

Development was assisted by an AI tool (Claude), used to generate and refine the
SwiftUI code, discuss architecture choices and speed up repetitive tasks (models,
views, tests). Every design choice, the trade-offs and the implementation were
reviewed and understood first-hand; the code is fully my own responsibility.

## What I would do with more time

- Optional token in the Keychain to raise the rate limits.
- Image caching and pagination of results.
- End-to-end UI tests and testing of the networking layer with a `URLProtocol` stub.
- String localisation.
