# Keyboard languages and layouts

The Dictus keyboard types and corrects in French, English, Spanish or German, in AZERTY or QWERTY, opening on letters or numbers; the transcription language is set separately.

- **ID:** `keyboard.languages`
- **Tier:** Gratuit
- **Statut Android:** partiel (no panel, no QWERTZ, no number row)
- **Screens:** `kbd.keys`, `app.settings`, `app.settings.picker` — see [screens.md](screens.md)

## Sub-features

- `keyboard.language-switch`: Tap the language code at the top left of the keyboard (`FR`, `EN`, `ES`, `DE`) to cycle; also « Langue du clavier » in Réglages. — présent (a tap that cycles, not a panel)
- `keyboard.layout`: « Disposition du clavier »: AZERTY or QWERTY. — partiel: no QWERTZ (German types on QWERTY).
- `keyboard.number-row`: — absent.
- `keyboard.default-page`: « Mode par défaut »: ABC or 123. — présent
- `keyboard.transcription-language`: « Langue » under TRANSCRIPTION: Automatique, Français, English, Español, Deutsch. — partiel: no « Suivre la langue du clavier »; the two settings are independent.
- `keyboard.open-app`: Long-press the language code: Dictus opens on Réglages (without the bottom tabs). — présent

## How to get to it (user POV)

1. In the Dictus keyboard, tap `FR` at the top left to switch to `EN`, `ES`, `DE`.
2. Dictus → Réglages → CLAVIER for the language, layout and default page; TRANSCRIPTION → Langue for dictation.

## Driving it with Argent

Preconditions: Launch and Doctor OK. Note the keyboard language, layout, default mode and transcription language shown in Réglages: they must read the same at the end.

- **Réglages.** Tap `Réglages`. → `Langue` (value `Automatique`), `Langue du clavier`, `Disposition du clavier`, `Mode par défaut` (`screen.sh app.settings`).
- **A picker without choosing.** Tap `Disposition du clavier`. → bottom sheet titled `Disposition du clavier` (`screen.sh app.settings.picker`); dismiss with `mcp__argent__button {button:"back"}`.
- **Cycle in the keyboard.** With a scratch note focused, tap the language code four times. → `FR`→`EN`→`ES`→`DE`→`FR` (back to the start).
- **Open the app.** Long-press the language code (`gesture-custom` Down, 600 ms, Up). → Dictus on `Réglages`, no bottom tabs.
- **Proof.** The code label in the tree after each tap; the Réglages values identical before and after.

## Gotchas

- Every change here is Pierre's setting. Cycle the keyboard language a full turn (4 taps) so it ends where it started.
- The transcription language must stay `Automatique` (#130 maps unknown languages to auto).
- The IME settings in Android (`ime enable/set`) are not this feature: those are `onboarding.ime-setup`.
