# flight-checklist

Offline flygchecklist-app för Android, byggd i Flutter. UI-strängar på
svenska; checklistinnehåll följer källmaterialet (PA-28 SEKMR är engelska).

Kräver Flutter `>=3.19.0` / Dart SDK `>=3.3.0 <4.0.0`.

## Arkitektur

```
lib/
├── main.dart                           # entry, laddar state + checklistor
├── models/checklist.dart               # Checklist → Page → Chapter → Item
├── services/
│   ├── checklist_loader.dart           # läser JSON från assets/checklists/
│   └── checklist_state.dart            # ChangeNotifier + shared_preferences
└── screens/
    ├── home_screen.dart                # lista över checklistor
    ├── checklist_index_screen.dart     # sid-index för en checklista
    └── page_screen.dart                # en sida med items
```

Navigation: **Home → ChecklistIndex → Page** (pushReplacement mellan sidor).

## Data

Checklistor är JSON i `assets/checklists/`. Manifestet är hårdkodat i
`ChecklistLoader._files` — lägg till nya filer där.

Modellen parsar med vanliga `fromJson`-factories — ingen kodgenerering,
ingen `json_serializable`. Om du ändrar shape: uppdatera modell *och*
alla asset-filer. Ingen schema-validering.

Shape (`Checklist`):
```json
{
  "id": "pa28",
  "title": "PA-28-181",
  "aircraft": "SE-KMR",
  "emergency": false,
  "note": "valfritt",
  "pages": [
    {
      "id": "preflight",
      "title": "Preflight",
      "chapters": [
        {
          "title": "Cockpit",
          "items": [
            { "id": "docs", "label": "Dokument ombord", "value": "KONTROLL" }
          ]
        }
      ]
    }
  ]
}
```

`emergency: true` → sorteras sist i Home, röd text, röd titlebar + vit text
när man öppnar listan.

Items utan `value` renderas enbart med label — används för
instruktionstexter ("Land as soon as practicable", "Prepare for EMERGENCY
LANDING" etc.) som ska bockas av för bekräftelse.

## State

`ChecklistState` håller ett `Set<String>` av ibockade items, persisteras som
JSON-lista under nyckeln `checkedItems` i `SharedPreferences`.

**Key-format: `"$checklistId:$pageId:$itemId"`** — load-bearing eftersom
`resetPage` / `resetAll` prefix-matchar. Ändra inte utan migration.

## UI-regler

- Ingen checkbox framför items — hela raden är tap-target
- Item rendras i två rader: label överst (vänster), `value` under
  (högerställt)
- Ibockad rad: `Colors.green.withValues(alpha: 0.35)` bakgrund
- Items minst 72px höga, label 22px, value 20px
- Emergency: `Colors.red.shade700` bakgrund på AppBar + bottennav, vit text
- Botten-nav på sidor: två knappar med namn på föregående/nästa sida, eller
  "Index" i ytterkanterna
- Index-skärm visar status per sida: grå `chevron_right` (orörd), amber
  `check_circle_outline` (påbörjad), grön `check_circle` (alla klara)

## Commands

- `flutter run` — kör på enhet/emulator
- `flutter analyze` — lint (`flutter_lints` via `analysis_options.yaml`)
- `flutter test` — widget/unit tests (inga än)
- `flutter build apk --debug` — lokal utvecklingsbuild
- `adb -s emulator-5554 install -r build/app/outputs/flutter-apk/app-debug.apk`
- `adb -s emulator-5554 shell am start -n com.example.flight_checklist/.MainActivity`

Rickards dev-emulator: AVD `flight_test` på API 36 x86_64, Pixel 5 profile.

## Release-pipeline

`.github/workflows/release.yml` triggas vid push till master (+ manuell).
Om HEAD är taggad `vMajor.Minor.Patch` används den versionen; annars
bumpas patch från senaste tag (eller `v1.0.0` om inga finns), ny tag
pushas, release-APK byggs (debug-signerad) och laddas upp som artifact +
GitHub Release.

## Att tänka på

- CRLF line endings (se global CLAUDE.md + `.gitattributes`)
- Inga AI-co-author trailers i commits, PRs eller taggar
- Android-plattformfiler committade, genererade med Flutter 3.41.7 —
  kör `flutter create . --platforms=android --project-name=flight_checklist`
  om de behöver regenereras

## TODO

- TTS-uppläsning av punkter — `flutter_tts` (noterat i `pubspec.yaml`)
