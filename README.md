# flight-checklist

Offline flygchecklist-app för Android. Flutter-projekt med enkla,
touch-vänliga checklistor som sparar ibockade punkter mellan sessioner.

## Funktioner

- Flera checklistor, varje med flera sidor och kapitel
- Stora tap-targets (rader ≥ 72px, text 20–22pt)
- Status persisteras lokalt — nollställ per sida eller hela checklistan
- Emergency-listor separeras och markeras i rött
- Allt fungerar offline — checklistor som JSON i app-bundlen

## Köra lokalt

**Förutsättningar:** Flutter SDK, Android SDK med API 36 system-image,
en emulator eller fysisk Android-enhet (USB-debug på).

```bash
flutter pub get
flutter run
```

Eller bygg + installera manuellt:
```bash
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

## Lägg till en checklista

1. Skapa `assets/checklists/<namn>.json` enligt schemat i `CLAUDE.md`.
2. Lägg till filnamnet i `ChecklistLoader._files`
   (`lib/services/checklist_loader.dart`).
3. Sätt `"emergency": true` för nödchecklistor — de sorteras sist och
   får röd styling.

## Struktur

Se [CLAUDE.md](./CLAUDE.md) för full arkitektur, UI-regler, state-format
och build-steg.

## Kommande

- Riktig PA-28-checklista (ersätter nuvarande placeholder)
- Uppläsning av punkter (`flutter_tts`)
