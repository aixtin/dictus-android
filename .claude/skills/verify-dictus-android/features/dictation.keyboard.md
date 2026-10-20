# Dictation from the keyboard

In any app, the Dictus keyboard's blue mic pill records the voice on the phone, transcribes it offline with the active model and inserts the text at the cursor. ✕ cancels without inserting anything; after an insertion, the « Annuler » chip removes what was just inserted.

- **ID:** `dictation.keyboard`
- **Tier:** Gratuit (nothing is gated on Android)
- **Statut Android:** présent
- **Screens:** `kbd.keys`, `kbd.recording`, `kbd.dictation-error`, `kbd.model-loading`, `sys.notification.recording`, `sys.ime-picker` — see [screens.md](screens.md)

## Sub-features

- `dictation.start`: Tap the mic pill (top right of the keyboard) to start recording. — présent
- `dictation.stop`: ✓ stops, transcribes (« Transcription… ») and inserts the text at the cursor. — présent
- `dictation.cancel`: ✕ stops and discards the audio; nothing is inserted. — présent
- `dictation.status`: Recording panel with waveform, MM:SS timer and « En écoute… », then « Transcription… »; while the model loads the mic is dimmed and an overlay reads « Préparation de la reconnaissance vocale ». — présent
- `dictation.undo-insert`: After an insertion, the suggestion bar shows « Annuler » (`Annuler la dernière dictée`): it deletes the inserted text if it is still right before the cursor. — présent (#137)
- `dictation.handoff`: — Spécifique iOS (Android's IME binds to the app's `DictationService` directly; no app switch).
- `dictation.requires-full-access`: — Spécifique iOS (no Full Access on Android; only the `RECORD_AUDIO` permission).
- `dictation.device-gating`: — absent: no device is refused as a whole; only heavy models are refused per RAM (`models.device-gating`).
- `dictation.notification` *(Spécifique Android)*: while recording, a foreground-service notification « Dictus - Recording » with a « Stop » action (required by Android for microphone use in the background).
- `dictation.switch-keyboard` *(Spécifique Android)*: during a recording the gear (`Settings`) under the waveform opens the system keyboard picker.

## How to get to it (user POV)

1. Dictus → onboarding, or Android Paramètres → Système → Langues et saisie → Clavier à l'écran: enable « Clavier Dictus » and select it.
2. In any text field (Notes, Messages…), the Dictus keyboard opens with the mic pill at the top right.
3. Tap the mic, speak, tap ✓ to insert or ✕ to cancel. Tap « Annuler » in the bar right after to remove the insertion.

## Driving it with Argent

Preconditions: Launch and Doctor OK (Dictus is the default IME, `RECORD_AUDIO` granted, at least one model in `files/models`); a scratch note you created, focused, so the keyboard is up.

- **Open a scratch field.** Open the notes app (`mcp__argent__launch-app` with its package, see Gotchas), create a new note, tap its body. → the Dictus keyboard is visible (`evidence.sh 01-keyboard`).
- **Mark the log.** `M=$(helpers/log.sh mark)`.
- **Start.** Tap the mic pill (`Microphone` in the tree, else top-right of the keyboard's top bar). → `helpers/log.sh wait 'ACTION_START' 15 "$M"`; the panel shows ✕, ✓, the timer and « En écoute… » (`evidence.sh 02-recording "$M"`).
- **Cancel.** Tap `✕` (left pill). → `helpers/log.sh wait 'Recording cancelled' 10 "$M"`; the keys come back.
- **Check nothing was inserted.** `mcp__argent__describe`: the note's body is still empty (or unchanged). (`evidence.sh 03-after-cancel "$M"`).
- **Stop instead (optional, records the room).** Tap `✓`. → `confirmAndTranscribe: N samples captured`, then a `transcriptionInserted` line; the field holds the text and the bar shows « Annuler ».
- **Proof.** Before/after screenshots + the `ACTION_START` and `Recording cancelled` lines after the mark + the unchanged field in the tree. For `dictation.stop`: the inserted text in the tree + `transcriptionInserted`. For `dictation.undo-insert`: tap « Annuler » → `Dictation undone: length=N` and the field is back as before.

## Gotchas

- The IME's tree may expose the keys only partially (Compose in an `InputMethodService`): tap by coordinate from a screenshot when a key has no label, and let the log line prove the press.
- With no model downloaded, a mic tap shows « Aucun modèle vocal — Téléchargez un modèle vocal pour commencer à dicter. » (`kbd.dictation-error`) and nothing records: that is the expected end state, not a failure of the recipe.
- The first tap after the app process was killed can land while the model loads: the mic is dimmed (`Microphone indisponible pendant le chargement…`) and the recording starts by itself once the engine is ready (pending mic gate). Wait for `Engine prewarm complete` before asserting.
- Clips under 0.5 s are dropped before transcription (no insertion, a warning in the log).
- Fields marked password, e-mail, URL or search still accept dictation, but nothing is kept for learning (`typing.private-fields`).
- A `✓` inserts what the room said. Use `✕` unless the task needs a transcript.
