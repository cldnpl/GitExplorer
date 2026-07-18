# GitExplorer

En iOS-app (SwiftUI), der søger i GitHub-repositories og viser deres vigtigste
egenskaber. Udviklet som en case for Dawn Health.

*Denne README findes også på [engelsk](README.md).*

## Funktioner

Tre skærme, i henhold til specifikationen:

1. **Splash** — vises ved cold start i mindst 3 sekunder, logo centreret.
2. **Søgning** — search-ahead, der starter fra 3 tegn, med antallet af resultater
   og, for hver række, et ikon (ejerens avatar eller et standard-mappeikon), en
   overskrift `<organization> / <repository name>` og "About"-beskrivelsen.
3. **Vis repository** — ikon, `org/navn`, sprog, forks, åbne issues, stargazers,
   seneste release og en tilbage-knap.

## Arkitektur

MVVM med SwiftUI og `NavigationStack`.

```
gitexplorer/
  App/         RootView (håndtering af splash → main)
  Models/      Repository, Owner, SearchResponse, Release (Codable)
  Networking/  GitHubServicing (protokol) + GitHubService (URLSession),
               GitHubEndpoint, APIError
  Features/
    Splash/    SplashView
    Search/    SearchView, SearchViewModel, RepositoryRowView, EmptyStateView
    Detail/    RepositoryDetailView, RepositoryDetailViewModel
  Support/     Color+Theme, RepositoryIconView, ViewState, String+Sanitizing
```

**Principper der er fulgt**
- **Dependency inversion**: view models afhænger af protokollen `GitHubServicing`,
  ikke af implementeringen. Det gør logikken testbar med en mock, uden netværk
  (se `gitexplorerTests/`).
- **Eksplicitte tilstande**: `ViewState` (`idle`/`loading`/`loaded`/`empty`/`failed`)
  i stedet for spredte boolske flag → forudsigelig UI.
- **Typede fejl**: `APIError` med brugervendte beskeder; rate limit på GitHubs
  offentlige API håndteres eksplicit (ingen crash).
- **Centraliseret design**: farver og genbrugelige komponenter taget fra Figma.

## GitHub API

- Søgning: `GET https://api.github.com/search/repositories?q={query}`
- Seneste release: `GET https://api.github.com/repos/{owner}/{repo}/releases/latest`
  (en 404 betyder "ingen release" og håndteres som et gyldigt tilfælde, ikke en fejl).

**Anonyme** kald (ingen token): specifikationen kræver det ikke, så der er ingen
hemmeligheder i koden. Headers der sendes: `Accept: application/vnd.github+json`,
`X-GitHub-Api-Version` og `User-Agent` (påkrævet af GitHub). Anonym grænse:
~10 søgninger/minut, håndteret med en fejlbesked.

## Beslutninger og trade-offs

- **Debounce + grænse på 3 tegn** i `SearchViewModel`, hvor den forrige søgning
  annulleres for at undgå races på svarene.
- **Antal resultater** = API'ets `total_count` (det reelle antal matches), ikke
  antallet af indlæste rækker. Tal formateres ud fra lokaliteten (locale).
- **Emoji fjernet** fra beskrivelser: GitHub returnerer dem både som Unicode-tegn
  og som shortcodes (`:rocket:`); de renses centralt i modellen
  (`String.removingEmoji()`) og er dækket af tests.
- **Standardikon**: mappeillustrationen og empty state er genskabt i SwiftUI
  (vektor) i stedet for at bruge PNG'erne fra Figma, så de forbliver skarpe ved
  enhver opløsning.

## Tests

`gitexplorerTests`-target (Swift Testing):
- `SearchViewModelTests` — grænse på 3 tegn, optælling, empty og fejl.
- `RepositoryParsingTests` — decoding af søgning og release, null-optional-felter.
- `RepositoryDetailViewModelTests` — indlæsning af release / fravær / fejl.
- `StringSanitizingTests` — fjernelse af emoji og shortcodes, bevarer klokkeslæt/forhold.

Kør:

```
xcodebuild test -project gitexplorer.xcodeproj -scheme gitexplorer \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:gitexplorerTests
```

## Brug af AI-værktøjer

Udviklingen er understøttet af et AI-værktøj (Claude), brugt til at generere og
finpudse SwiftUI-koden, drøfte arkitekturvalg og fremskynde gentagne opgaver
(modeller, views, tests). Alle designvalg, trade-offs og implementeringen er
gennemgået og forstået på egen hånd; koden er fuldt ud mit eget ansvar.

## Hvad jeg ville gøre med mere tid

- Valgfri token i Keychain for at hæve rate limits.
- Caching af billeder og paginering af resultater.
- End-to-end UI-tests og test af netværkslaget med en `URLProtocol`-stub.
- Lokalisering af strenge.
