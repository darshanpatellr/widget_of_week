## Block Demo — Flutter Cupertino + Material Showcase

Elegant, production‑quality Flutter app demonstrating modern Cupertino design with Material interoperability. This project features a TikTok/Reels‑style vertical video experience, reusable UI primitives, and curated Cupertino components — built with a focus on clarity, performance, and maintainability.

### Highlights
- **Reels‑style video player**: Vertical paging, lazy initialization, preloading, mute toggle, playback speed selector, and gradient overlays.
- **Cupertino‑first UI**: `CupertinoSliverNavigationBar`, `CupertinoSlidingSegmentedControl`, `CupertinoCheckbox`, `CupertinoActionSheet`, `CupertinoSwitch`, and more.
- **Material interoperability**: Smoothly mixes Material widgets where appropriate (e.g., navigation, list tiles, icons).
- **Composable widgets**: `ReusableContainer` for consistent section layout; `HeroLayoutCard` for image‑led hero tiles.
- **Search UX**: `SearchAnchor` with filtered suggestions backed by a typed `Product` model and `ItemTile` result rows.
- **Animation**: Tween‑driven text animation with `AnimatedBuilder` and an `AnimationController` lifecycle done right.

### Screens & Components
- **Home** (`lib/main.dart` → `HomeScreen`)
  - Tween demo, generated icon row, video player launcher, `SearchAnchor`, `SearchBar`, weighted `CarouselView`, switches, checkboxes, segmented control, sheet routes, and radio group.
- **Reels / Video Player** (`lib/screens/video_player_screen.dart`)
  - `PageView` vertical feed with `video_player` controllers pooled per index, on‑demand initialization, preloading adjacent items, resource cleanup, and subtle UI chrome.
- **Hero Cards** (`lib/widget/hero_layout_card.dart`)
  - `HeroLayoutCard` backed by the `ImageInfo` enum for curated titles/subtitles and remote images.
- **Reusable Section** (`lib/widget/reusable_container.dart`)
  - Consistent container for labeled sections with border, spacing, and theming.

### Project Structure
```text
lib/
  main.dart
  screens/
    video_player_screen.dart
  widget/
    hero_layout_card.dart
    reusable_container.dart
```

### Getting Started
1) Install Flutter (stable) and set up iOS/Android tooling.
2) Fetch dependencies and run:

```bash
flutter pub get
flutter run
```

For iOS, use a physical device or simulator with video playback enabled. For Android, ensure Internet permission is present (Flutter templates include it; if not, add it to `android/app/src/main/AndroidManifest.xml`).

### Dependencies
- `video_player` — network video playback with controller‑level control (looping, volume, speed).

Ensure your `pubspec.yaml` includes:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  video_player: ^2.9.1
```

Run `flutter pub get` after edits.

### How Things Work
- **Video lifecycle**
  - Each visible index gets a `VideoPlayerController` on demand; neighbors are preloaded for seamless swipes. Distant controllers are disposed to control memory.
  - Muting and playback speed propagate to all active controllers. Play/pause toggles on tap, progress is scrubbable via `VideoProgressIndicator`.
- **UI composition**
  - `ReusableContainer` standardizes section titles and layout, keeping Home readable and consistent.
  - `HeroLayoutCard` uses a constrained `OverflowBox` to preserve composition while filling the visual focus with imagery.
- **Search**
  - `SearchAnchor` narrows `Product.values` by label, yielding tappable `ItemTile` suggestions and clean focus management.

### Running Tips
- Prefer `--release` or `--profile` for realistic video performance:

```bash
flutter run --profile
```

- On iOS, verify background modes and ATS if switching to non‑HTTPS sources. Current demo URLs are HTTPS and work out of the box.

### Quality Notes
- Stateless/Stateful boundaries are intentional; state lives close to behavior (e.g., video page index and controllers), keeping rebuilds predictable.
- Controllers are disposed deterministically in `dispose()`; animations use `SingleTickerProviderStateMixin` and are stopped cleanly.
- Widgets avoid deep nesting; early returns keep code paths clear.

### Roadmap (Nice‑to‑have)
- Add like/share actions with haptic feedback.
- Persist mute and playback preferences.
- Inline subtitle tracks and captions styling.
- Snapshot tests for list generation and search filtering.

### Credits
Crafted with Flutter, blending Cupertino precision and Material pragmatism. Ideal as a reference for high‑signal UI composition, controller lifecycle patterns, and tasteful interactions.

# block_demo

A new Flutter bloc project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
