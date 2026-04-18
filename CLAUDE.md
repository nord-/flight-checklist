# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Offline Flutter app for pilot flight checklists ("Flygchecklistor"). UI text is in Swedish — keep new strings in Swedish to match. The only checklist currently shipped is a PA-28 *placeholder* (`assets/checklists/pa28.json`, see the `note` field) that is expected to be replaced with real operational content.

Requires Flutter `>=3.19.0` / Dart SDK `>=3.3.0 <4.0.0`.

## Setup (Android platform files are intentionally not committed)

The `android/` (and other platform) directories are not in the repo. Before the first run on a fresh clone:

```
flutter create . --platforms=android --project-name=flight_checklist
flutter pub get
flutter run
```

Re-running `flutter create .` later is safe — it only adds missing platform scaffolding.

## Common commands

- `flutter run` — run on attached device/emulator
- `flutter analyze` — lint (uses `flutter_lints` via `analysis_options.yaml`)
- `flutter test` — run widget/unit tests (`test/` — none yet)
- `flutter test test/path/to/foo_test.dart` — single test file
- `flutter test --name "pattern"` — filter by test name

## Architecture

Three layers, wired together in `lib/main.dart` before `runApp`:

1. **Assets** — each checklist is a JSON file in `assets/checklists/` with a fixed nested shape: `Checklist → pages[] → chapters[] → items[]` (`id`, `label`, optional `value`). Declared under `flutter.assets:` in `pubspec.yaml`.
2. **Loader** — `lib/services/checklist_loader.dart` reads the bundle at startup. **The file list is hardcoded in `_files`** — adding a new checklist requires both dropping the JSON in `assets/checklists/` *and* appending its filename to `_files`.
3. **State** — `lib/services/checklist_state.dart` is a `ChangeNotifier` holding a `Set<String>` of ticked item keys. Keys are composed as `"$checklistId:$pageId:$itemId"`; state is persisted as one JSON-encoded list under the single `SharedPreferences` key `checkedItems`. `resetPage` / `resetAll` work by prefix-matching those same keys, so the key format is load-bearing — don't change it without a migration.

UI (`lib/screens/`): `HomeScreen` lists checklists, `ChecklistScreen` shows one page at a time with `ListenableBuilder(listenable: state, …)` so ticks rebuild immediately. The checklist screen is deliberately sized for cockpit use — 36 px check icons, 72 px min row height, 22/18 pt item text. Preserve those touch-target sizes when editing.

## Models & JSON

`lib/models/checklist.dart` parses JSON with plain `fromJson` factories — no code generation, no `json_serializable`. If you change the JSON shape, update both the model and every asset file; there's no schema validation.

## Planned (not yet implemented)

- `flutter_tts` for read-aloud of items (noted in `pubspec.yaml` and the scaffold commit).
