---
name: verify-dictus-android
description: Verify the Dictus Android app (dev.pivisolutions.dictus — the app, its Dictus keyboard IME and the dictation service) on Pierre's physical Pixel 4 over USB, driven with Argent — build and install the debug APK without losing data, check the device is worth driving, drive a mapped feature by its French labels, capture evidence outside the repo, clean up. Use when a change to app/, ime/ or core/ has to be seen working on the real phone rather than in unit tests, when a feature of features/README.md must be exercised, or when the screen map needs new captures.
---

# Verify Dictus on the Pixel

Five steps, always in this order: **Launch → Doctor → Drive → Evidence → Cleanup**. Helpers live in `helpers/` and run from the repository root. The phone is Pierre's own Pixel 4 (serial `99071FFAZ00EBN`, LineageOS, French): it holds his models, settings and notes. There is no second device and no way to run two instances side by side, so the run is serialized by a lock and **never** wipes or uninstalls anything.

Read first: `features/README.md` maps every user feature to its recipe, `features/screens.md` every screen. A pass here proves the debug build on this phone, nothing more.

**One driver at a time.** Argent (the `mcp__argent__*` tools, or `argent run <tool>` on the CLI) is the only UI driver. Its `describe` runs `uiautomator dump`, which needs UiAutomation for itself: never run mobile-mcp, Maestro, Appium or a hand-made `uiautomator dump` alongside it. mobile-mcp is removed from this machine; do not reinstall it.

## Launch

Take the Pixel lock first. Other threads install APKs on the same phone; the lock is the only thing that keeps two of them from installing over each other.

```bash
H=.claude/skills/verify-dictus-android/helpers
$H/lock.sh acquire verify-map     # waits (retry every 60 s, max 30 min) while another thread holds it
$H/launch.sh                      # build + install -r + IME + launch
$H/launch.sh --no-build           # same, reusing app/build/outputs/apk/debug/app-debug.apk
```

`launch.sh`, in order:

1. Refuses to run without the lock, without the phone (`adb devices`), or if the phone is locked (`dumpsys window`: `isKeyguardShowing=true` or `mDreamingLockscreen=true`). **Never unlock the phone**: release the lock, stop, report.
2. Creates the run directory `/home/pierre/Dev/dictus-proofs/verify-dictus-android/<YYYYMMDD-HHMMSS>-<sha>/` and points this worktree's session file at it (`…/sessions/<worktree-name>`), so two worktrees never resolve each other's run.
3. `git submodule update --init` then `./gradlew assembleDebug` (log in `build.log`; ~1 min warm, longer cold: whisper.cpp is compiled by CMake).
4. `adb install -r app-debug.apk` — **`-r` keeps the data. Never `adb uninstall`, never `pm clear`.** The debug keystore is shared with hermesbot, so the install updates in place.
5. Makes `dev.pivisolutions.dictus/.ime.DictusImeService` the default IME (`ime enable` + `ime set`) only if it is not already, and writes the previous IME to `run.env` for Cleanup.
6. `am start -W -n dev.pivisolutions.dictus/.MainActivity`.

**Ready means** the process is alive (`pidof`), `MainActivity` is the resumed activity, and the pid is unchanged 3 s later (an app that crashes on start fails here). Last line on success, the only one to rely on:

```
READY serial=99071FFAZ00EBN run=/home/pierre/Dev/dictus-proofs/verify-dictus-android/<run-id> pid=<pid> version=1.0.0 apk_sha=<16 hex>
```

Then confirm with Argent that the first screen is usable: `mcp__argent__describe` (udid `99071FFAZ00EBN`) lists the bottom tabs `Accueil`, `Modèles`, `Réglages` (onboarding completed) or `Commencer` (fresh install, onboarding step 1).

## Doctor

```bash
.claude/skills/verify-dictus-android/helpers/doctor.sh             # this worktree's run
.claude/skills/verify-dictus-android/helpers/doctor.sh <run-dir>   # a given run
```

Read-only: installs, taps and changes nothing. One `OK` / `WARN` / `FAIL` line per check, then `DOCTOR OK` or `DOCTOR FAIL <n>` (exit 1):

- `adb` and `argent` present; Pixel connected; **unlocked**; locale `fr-FR` (the labels below are French).
- The `.pixel-lock` is held (and by whom).
- Dictus installed (`versionName`, `lastUpdateTime`) and **the installed APK is this run's build** (sha256 of the on-device `base.apk` against `apk_sha` in `run.env`; reading 170 MB takes ~20 s).
- Dictus is the default IME; `RECORD_AUDIO` granted; the process runs; `files/dictus.log` readable with `run-as` (debug build only); which models are in `files/models` (none = every dictation ends on « Aucun modèle vocal »).
- No other UI driver: no long-lived `uiautomator`/Appium/Maestro on the phone, no `mobile-mcp`/Maestro/Appium on the host.

Run it after Launch and again before Evidence. A `FAIL` stops the run: fix it or report it, never drive past it.

## Drive with Argent

Device id for every call: `99071FFAZ00EBN`. Coordinates are normalized 0–1, taken from the tree that each interaction returns (`describe` when no fresh tree is at hand). Never guess them from pixels.

```text
mcp__argent__describe        { udid }                                  # tree with labels + frames
mcp__argent__gesture-tap     { udid, x, y }                            # centre of a frame from that tree
mcp__argent__await-ui-element{ udid, condition: "visible", selector: { text: "Réglages" }, timeoutMs: 8000 }
mcp__argent__keyboard        { udid, text: "…" }                       # types through adb, NOT through the Dictus keys
mcp__argent__screenshot      { udid }                                  # may show the previous frame: prove with evidence.sh
```

CLI equivalent: `argent run describe --udid 99071FFAZ00EBN`.

**Handles.** The app sets no `resource-id` (Compose without `testTagsAsResourceId`), so the stable handles are the French texts and content descriptions below, all from `values-fr/strings.xml`. Select by `text` (case-insensitive substring); prefer the longest unique label.

| Where | Handles (FR device) |
| --- | --- |
| Bottom tabs | `Accueil`, `Modèles`, `Réglages` |
| Accueil | `Nouvelle dictée`, `Modèle actif`, `Dernière transcription` + copy icon `Copier` |
| In-app recording | mic `Enregistrer`, `Arrêter`, `Toucher pour arrêter`, `Transcription en cours…`, `Résultat` + `Copier`, back `Retour` |
| Modèles | sections `Téléchargés` / `Disponibles`; card names `Tiny`, `Base`, `Small`, `Small Q5`, `Medium`, `Parakeet 110M`, `Parakeet 0.6B`; `Actif`, `Télécharger`, `Supprimer`, `Réessayer`; dialogs `Supprimer <nom> ?`, `Modèle anglais uniquement`, `RAM insuffisante` |
| Réglages | sections `TRANSCRIPTION`, `CLAVIER`, `APPARENCE`, `A PROPOS`; rows `Langue`, `Langue du clavier`, `Disposition du clavier`, `Mode par défaut`, `Suggestions`, `Correction automatique`, `Retour haptique`, `Sons du clavier`, `Sons`, `Thème`, `Langue de l'interface`, `Version`, `Debug Logs`, `Exporter les logs de débogage`, `Licences`, `GitHub`, `Mentions légales` |
| Sons | `Son de dictée`, `Volume`, `Son de début`, `Son de fin`, `Son d'annulation`, back `Retour` |
| Onboarding | `Commencer`, `Autoriser le micro`, `Continuer`, `Ouvrir les paramètres`, `Sélectionner Dictus`, `ABC` / `123`, `Télécharger`, `Réessayer` |

**The Dictus keyboard** is a separate window (the IME). Its keys are drawn by Compose; when Argent's tree does not list them, tap by coordinate from the screenshot of a known layout and prove the press with a log line (`log.sh wait`). Known handles inside it: the language code (`Keyboard language FR`: tap cycles FR→EN→ES→DE, long-press opens Dictus Réglages), the mic pill (`Microphone`, or `Microphone indisponible pendant le chargement…` while the model loads), during recording `✕` (cancel) and `✓` (insert), `Settings` (opens the system keyboard picker), `En écoute…`, `Transcription…`, the undo chip `Annuler la dernière dictée`, the emoji page's `ABC`.

**Text fields to type into.** Use a scratch note you create yourself, never one of Pierre's notes (keep the « bonjour » notes untouched). The test note is deleted at the end of the run.

**Logs that prove an action** (Timber, logcat of the Dictus process; `helpers/log.sh`):

| Action | Line (regex) |
| --- | --- |
| Mic tap from the keyboard | `handleMicTap called` / `Recording started via mic tap` (or the gate's `startRecording`) |
| Recording started (service) | `DictationService started foreground with ACTION_START` |
| ✕ in the keyboard | `Recording cancelled` (twice: IME and service, `samples discarded`) |
| ✓ in the keyboard | `confirmAndTranscribe: \d+ samples captured`, then `transcriptionInserted` (length only, never the text) |
| Undo chip | `Dictation undone: length=\d+` or `Dictation undo refused` |
| Model warm-up | `Engine prewarm complete for model=…` / `Engine prewarm skipped` |

```bash
H=.claude/skills/verify-dictus-android/helpers
M=$($H/log.sh mark)                          # device time, to assert only on what follows
$H/log.sh wait 'Recording cancelled' 15 "$M" # prints the line, exit 1 after 15 s
$H/log.sh since "$M"                         # everything Dictus logged since the mark
```

Rules that hold for every feature:

- **Do not change Pierre's settings**, or put them back exactly: transcription `Langue` stays `Automatique`, the active model stays the one Doctor reported, theme, keyboard language and layout unchanged. Open a picker only to capture it, then close it without choosing (system back).
- **Never download a model** unless the task needs one (Tiny is 75 MB; Medium and Parakeet 0.6B are over 500 MB). Never delete one.
- A dictation records the room through the phone's microphone. Cancel (`✕`) proves the chain without a transcript; a `✓` inserts whatever was heard.
- The keyboard only appears over a focused text field of another app; it is never in Dictus's own tree.

## Evidence

```bash
H=.claude/skills/verify-dictus-android/helpers
$H/evidence.sh 01-before            # screenshot only
$H/evidence.sh 02-after "$M"        # screenshot + every Dictus log line since the mark
$H/screen.sh kbd.recording          # a screen for the map: screens/kbd.recording.png in this skill
```

Everything for a run lands in `/home/pierre/Dev/dictus-proofs/verify-dictus-android/<run-id>/`, **never in the repository**:

| File | Written by | Content |
| --- | --- | --- |
| `report.txt` | all helpers | commit, branch, install, `READY`, each capture, `CLEANUP OK` |
| `run.env` | `launch.sh` | `PREV_IME`, `SERIAL`, `PID`, `APK_SHA`, `VERSION` |
| `build.log`, `install.log`, `am-start.log`, `00-launch.png` | `launch.sh` | build, install, first screen |
| `<name>.png` | `evidence.sh` | `adb exec-out screencap -p`, 1080×2280 |
| `<name>.log` | `evidence.sh` (with a mark) | Dictus logcat lines since the mark |
| `dictus.full.log` | `cleanup.sh` | the app's own `files/dictus.log` (privacy-safe: lengths, never text) |

Proof standards: drive the real user path (keys, buttons, the keyboard over a real app), not an internal setter or `am broadcast`; capture the screen **before** and **after** the action and the log line that proves it happened; check the side effect too (for a cancel: the field is unchanged; for an insert: the field holds the text). A screenshot without its log line is a picture, not a proof. Argent's `screenshot` can lag one frame: use `evidence.sh` (adb screencap) for the file you keep. Only screen-map captures (`screen.sh`, resized to 1140 px high and quantized with python3 PIL, < 300 KB) go in the repository, under `screens/`.

## Cleanup

```bash
.claude/skills/verify-dictus-android/helpers/cleanup.sh                     # this worktree's run, lock tag verify-map
.claude/skills/verify-dictus-android/helpers/cleanup.sh <run-dir> <lock-tag>
```

Then stop Argent's services **for the Pixel only**: `mcp__argent__stop-all-simulator-servers { devices: ["99071FFAZ00EBN"] }` (CLI: `argent run stop-all-simulator-servers --devices 99071FFAZ00EBN`). Never call it without `devices`: one tool-server serves every agent on this machine.

`cleanup.sh` copies `files/dictus.log` into the run, restores the IME that Launch replaced (if it replaced one), releases the lock **only if your tag owns it**, and ends with `CLEANUP OK run=… files=<n>`. It never uninstalls, never clears data, never kills a process by name, never deletes anything under `dictus-proofs/`. Delete your scratch note yourself before Cleanup. Run Cleanup after a failed run too, then check the evidence survived: `ls -la <run-dir>`.

## Helpers

All executable, run from the repository root; all read `helpers/env.sh` (overrides: `DICTUS_SERIAL`, `DICTUS_PROOFS`, `DICTUS_EVIDENCE_ROOT`, `DICTUS_VERIFY_RUN`).

| Script | Invocation | Ends with |
| --- | --- | --- |
| `helpers/lock.sh` | `lock.sh acquire\|release\|status [tag]` | `LOCK ACQUIRED …` / `LOCK RELEASED` / `free` |
| `helpers/launch.sh` | `launch.sh [--no-build]` | `READY serial=… run=… pid=… version=… apk_sha=…` |
| `helpers/doctor.sh` | `doctor.sh [run-dir]` | `DOCTOR OK` / `DOCTOR FAIL <n>` |
| `helpers/log.sh` | `log.sh mark` · `log.sh wait '<regex>' [secs] [mark]` · `log.sh since <mark>` | `found: <line>` / `error: …` |
| `helpers/evidence.sh` | `evidence.sh <name> [mark] [run-dir]` | `evidence <name>: <path>.png` |
| `helpers/screen.sh` | `screen.sh <screen-id>` | `screen <id>: <path> (<n> KB)` |
| `helpers/cleanup.sh` | `cleanup.sh [run-dir] [lock-tag]` | `CLEANUP OK run=… files=<n>` |
| `helpers/env.sh` | sourced, not run | `adbs`, `resolve_run`, `report` |

Keep the map honest as the app changes with `/maintain-verification-skill`.
