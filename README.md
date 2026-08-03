//
//  README.md
//  MovieDiscover
//
//  Created by Nastia Gusev on 03/08/2026.
//

# MovieDiscover

An AI-native movie discovery app for iOS, built with SwiftUI and Apple's
on-device Foundation Models. Instead of another endless grid of posters,
MovieDiscover understands your taste — you describe a mood in plain
language, it explains why you'll like a film, and it organizes your
favorites into collections it names itself. Everything AI runs
**on-device**: private, offline, no API keys.

<!-- Screenshots: replace with your own. A 2x3 grid or a row reads well. -->
| Discover | Mood Search | Your Taste |
|---|---|---|
| ![Discover](screenshots/discover.png) | ![Mood search](screenshots/mood.png) | ![You tab](screenshots/you.png) |

## Features

**Conversational discovery.** Describe what you're in the mood for —
*"a slow-burn sci-fi thriller from the 90s"* — and the on-device model
turns it into structured search filters, grounded in real TMDB data so
results actually match.

**Taste profile.** Reads your favorites and describes your taste in a
few specific, human phrases — plus what you rarely watch.

**AI-curated collections.** Groups your favorites into named, evocative
collections like *"Mind-bending movies"* or *"Movies for a rainy Sunday."*
The model decides the groupings; the app maps them back to your real
saved films, so nothing is invented.

**Why you'll like this.** On any film's detail screen, a personalized
one-liner explaining why it fits your taste, referencing your favorites
by name.

**Personalized home feed.** A composable, non-templated feed:
recommendations tuned to your favorites, trending, an image-backed genre
explorer, and a "Where to Stream" section.

## Tech

- **SwiftUI** — fully declarative UI, `@Observable` view models (MVVM)
- **Apple Foundation Models** — on-device generative AI (iOS 26), using
  `@Generable` guided generation for structured output, behind protocol
  seams for testability, gated with graceful fallbacks on unsupported
  devices
- **Swift Concurrency** — `async/await`, task groups for parallel loads,
  cancellation-aware
- **SwiftData** — local persistence for favorites
- **Swift 6** strict concurrency
- **TMDB API** — movie data
- Custom **image caching layer** (`NSCache` + in-flight request
  coalescing) built to fix `AsyncImage`'s lack of caching
- Reusable **pagination** (infinite scroll) and composable feed
  architecture

## Architecture

MVVM with a clear core/feature split. AI features share a common shape:
a `@Generable` output type, a protocol (`MovieIntentParsing`,
`TasteProfiling`, `FavoriteGrouping`, `WatchReasoning`) with a real
Foundation Models implementation and a mock for previews/tests, and an
availability gate that degrades gracefully — every AI feature has a
non-AI fallback, so the app is fully usable without Apple Intelligence.

## Requirements

- iOS 26+ (AI features require an Apple Intelligence–capable device;
  the app runs and degrades gracefully without it)
- Xcode 26+
- A free [TMDB API key](https://www.themoviedb.org/settings/api)

## Setup

1. Clone the repo.
2. Add your TMDB API key to `Secrets.xcconfig` (see
   `Secrets.example.xcconfig`).
3. Open `MovieDiscover.xcodeproj` and run.

## Notes

Built as a portfolio project to explore on-device generative AI in a
real, shippable iOS app. The design goal throughout was to feel like a
discovery *product* with a point of view — not a streaming-service
clone.
