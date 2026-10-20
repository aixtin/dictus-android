# Dictation inside the app

Dictus's Home tab starts a full-screen recording without any keyboard; the result can be copied, and the last transcription stays on Home with a copy button.

- **ID:** `dictation.in-app`
- **Tier:** Gratuit
- **Statut Android:** présent
- **Screens:** `app.home`, `app.recording` — see [screens.md](screens.md)

## Sub-features

- `dictation.start-in-app`: « Nouvelle dictée » on Accueil opens the recording screen; tap the mic, speak, tap to stop. — présent
- `dictation.copy-last`: The « Dernière transcription » card on Accueil copies its text (`Copier`). — présent
- `dictation.download-prompt`: — partiel: Accueil never asks to download a model (it always shows « Modèle actif »); only the mic answers « Aucun modèle vocal » once tapped.
- `dictation.from-widget`: — absent: no home-screen widget.

## How to get to it (user POV)

1. Open Dictus, tab Accueil.
2. Tap « Nouvelle dictée », tap the mic, speak, « Toucher pour arrêter ».
3. Copy the result (`Copier`) on the recording screen, or later from the « Dernière transcription » card on Accueil.

## Driving it with Argent

Preconditions: Launch and Doctor OK, onboarding completed, a model downloaded.

- **Home.** Tap `Accueil`. → `Modèle actif`, `Nouvelle dictée` and, if any, `Dernière transcription` in the tree (`screen.sh app.home`).
- **Open the recorder.** Tap `Nouvelle dictée`. → title `Nouvelle dictée`, mic `Enregistrer` (`screen.sh app.recording`).
- **Leave without recording.** Tap `Retour`. → back on Accueil, nothing changed.
- **Record (only when the task accepts recording the room).** Tap `Enregistrer`, then `Arrêter`. → `Transcription en cours…` then `Résultat` with `Copier`; log `confirmAndTranscribe: N samples captured`.
- **Proof.** Screens before/after and, for a real dictation, the `Résultat` text in the tree plus the log line; the « Dernière transcription » card on Accueil shows the same text afterwards.

## Gotchas

- Copying writes to Pierre's clipboard; avoid it unless the task needs it.
- « Dernière transcription » is Pierre's last real dictation: it is private, do not paste it into evidence or a PR.
- History (`history.*`) is compiled but hidden (`PremiumFlags.HISTORY_VISIBLE = false`): no swipe-up, no « Historique » on Accueil.
