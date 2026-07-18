# GitExplorer

App iOS (SwiftUI) che cerca repository su GitHub e ne mostra le caratteristiche
principali. Sviluppata come case per Dawn Health.

## Funzionalità

Tre schermate, secondo la specifica:

1. **Splash** — mostrata al cold start per almeno 3 secondi, logo centrato.
2. **Search** — ricerca "search-ahead" a partire da 3 caratteri, con numero di
   risultati e, per ogni riga, icona (avatar del proprietario o icona folder di
   default), header `<organization> / <repository name>` e descrizione "About".
3. **Show Repository** — icona, `org/nome`, linguaggio, forks, open issues,
   stargazers, ultima release e pulsante indietro.

## Architettura

MVVM con SwiftUI e `NavigationStack`.

```
gitexplorer/
  App/         RootView (gestione splash → main)
  Models/      Repository, Owner, SearchResponse, Release (Codable)
  Networking/  GitHubServicing (protocol) + GitHubService (URLSession),
               GitHubEndpoint, APIError
  Features/
    Splash/    SplashView
    Search/    SearchView, SearchViewModel, RepositoryRowView, EmptyStateView
    Detail/    RepositoryDetailView, RepositoryDetailViewModel
  Support/     Color+Theme, RepositoryIconView, ViewState, String+Sanitizing
```

**Principi seguiti**
- **Dependency inversion**: i view model dipendono dal protocollo
  `GitHubServicing`, non dall'implementazione. Questo rende la logica testabile
  con un mock, senza rete (vedi `gitexplorerTests/`).
- **Stati espliciti**: `ViewState` (`idle`/`loading`/`loaded`/`empty`/`failed`)
  al posto di flag booleani sparsi → UI prevedibile.
- **Errori tipizzati**: `APIError` con messaggi mostrabili; il rate limit
  dell'API pubblica di GitHub è gestito esplicitamente (nessun crash).
- **Design centralizzato**: colori e componenti riutilizzabili presi dal Figma.

## API GitHub

- Ricerca: `GET https://api.github.com/search/repositories?q={query}`
- Ultima release: `GET https://api.github.com/repos/{owner}/{repo}/releases/latest`
  (un 404 significa "nessuna release" e viene gestito come caso valido, non errore).

Chiamate **anonime** (nessun token): la specifica non lo richiede e così non ci
sono segreti nel codice. Header inviati: `Accept: application/vnd.github+json`,
`X-GitHub-Api-Version` e `User-Agent` (richiesto da GitHub). Limite anonimo:
~10 ricerche/minuto, gestito con un messaggio d'errore.

## Scelte e trade-off

- **Debounce + soglia 3 caratteri** nel `SearchViewModel`, con annullamento della
  ricerca precedente per evitare race sulle risposte.
- **Numero di risultati** = `total_count` dell'API (il conteggio reale dei match),
  non il numero di righe caricate. Formattazione dei numeri in base al locale.
- **Emoji rimosse** dalle descrizioni: GitHub le restituisce sia come caratteri
  Unicode sia come shortcode (`:rocket:`); vengono ripulite in modo centralizzato
  nel modello (`String.removingEmoji()`), coperto da test.
- **Icona di default**: l'illustrazione folder e l'empty state sono ricreati in
  SwiftUI (vettoriali) invece di usare i PNG del Figma, per restare nitidi a ogni
  risoluzione.

## Test

Target `gitexplorerTests` (Swift Testing):
- `SearchViewModelTests` — soglia 3 caratteri, conteggio, empty ed errore.
- `RepositoryParsingTests` — decoding di search e release, campi opzionali null.
- `RepositoryDetailViewModelTests` — caricamento release / assenza / errore.
- `StringSanitizingTests` — rimozione emoji e shortcode, preservando orari/rapporti.

Esecuzione:

```
xcodebuild test -project gitexplorer.xcodeproj -scheme gitexplorer \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:gitexplorerTests
```

## Uso di strumenti AI

Lo sviluppo è stato assistito da un tool AI (Claude), usato per generare e
rifinire il codice SwiftUI, discutere le scelte di architettura e velocizzare
attività ripetitive (modelli, viste, test). Ogni scelta di design, i trade-off e
l'implementazione sono stati rivisti e compresi in prima persona; il codice è
sotto la mia piena responsabilità.

## Cosa farei con più tempo

- Token opzionale in Keychain per alzare i rate limit.
- Caching delle immagini e paginazione dei risultati.
- UI test end-to-end e test del layer di rete con `URLProtocol` stub.
- Localizzazione delle stringhe.
