# Dictus Android feature map

Every user-facing feature of Dictus Android, one file each, with **the same IDs as the iOS map** (`getdictus/dictus-ios`, `.claude/skills/verify-dictus-ios/features/`, develop at `685b4b2`). An ID names what the user gets, never a module, a composable or a class, so both platforms compare line by line. An ID never changes once published; a feature that goes away keeps its ID retired. A feature that exists only on Android gets a new ID in the same format, marked *Spécifique Android*.

Each feature file has the same four sections: **Sub-features** (each with its stable ID and its Android status), **How to get to it (user POV)**, **Driving it with Argent** (the recipe, with the helpers of `../SKILL.md`), **Gotchas**. Screens are mapped in [screens.md](screens.md), captures in [`../screens/`](../screens/).

## Baseline preconditions

- Pierre's Pixel 4 (`99071FFAZ00EBN`, LineageOS, French), unlocked, on USB; the `.pixel-lock` taken by this session (`helpers/lock.sh acquire`: one token per session, see `../SKILL.md` → Launch).
- `launch.sh` printed `READY`, `doctor.sh` printed `DOCTOR OK`: debug build of the current branch installed with `adb install -r` (data kept), Dictus is the default IME, `RECORD_AUDIO` granted, onboarding completed, at least one model downloaded (Small Q5 at the time of writing).
- Pierre's data stays as it is: his notes (including the « bonjour » ones), his active model, his settings (transcription language `Automatique`). A journey types only into a scratch note it creates and deletes.
- What a journey cannot reach without wiping data (onboarding, a download in progress) is reported as not driven, with the precondition; the data is never cleared to reach it.

## Driving conventions

- Argent is the only driver (`mcp__argent__*`, device id `99071FFAZ00EBN`). Coordinates come from the tree Argent returns, never from guesses.
- Select by French label or content description (no resource-ids in this app); the handles are listed in `../SKILL.md` → Drive.
- Inside the keyboard, type by tapping the Dictus keys; `mcp__argent__keyboard` sends `adb input text` and bypasses the keyboard.
- Start every assertion from a log mark (`M=$(helpers/log.sh mark)`) and wait on the line (`helpers/log.sh wait '<regex>' 15 "$M"`).
- Leave every setting as found; a picker is captured, then closed with system back without choosing.

## Proof and skip reporting

- Capture the user action and the resulting state: a screenshot before, one after (`helpers/evidence.sh <name> "$M"`), the log line that proves the action, and the side effect (the field's value in the tree, the file on the device).
- Record the feature ID and the entry point with every artifact (name the file `<NN>-<feature-id>-<step>`).
- An unreachable path is reported with the command attempted and the unmet precondition. A skipped entry point is never reported as verified through a different path.
- Evidence lives in `/home/pierre/Dev/dictus-proofs/verify-dictus-android/<run-id>/`, never in the repository. Only screen-map captures go in `../screens/`.

## Feature entry contract

Each feature file starts with an H1 title and one paragraph describing the user-visible behaviour, then a short metadata list (ID, tier, Android status, screens), then exactly four H2 in this order:

1. `Sub-features`: short IDs with one line each, ending with the Android status (présent / partiel: what is missing / absent / Spécifique iOS); Android-only ones are marked *(Spécifique Android)*.
2. `How to get to it (user POV)`: every user entry point.
3. `Driving it with Argent`: starts with `Preconditions:`, then labelled bullets pairing each user action with an exact call or helper and its observable result, ending with a **Proof.** bullet.
4. `Gotchas`: traps that waste or invalidate a run, including what the Pixel cannot show and what would touch Pierre's data.

Implementation details stay out of the map: only user paths, stable handles, required state, commands and observable proof.

## Features

**Tier on Android.** Nothing is sold on Android yet: there is no purchase flow and no Pro entitlement. The only switch is `PremiumFlags.HISTORY_VISIBLE = false` (`core/.../premium/PremiumFlags.kt`), which hides history entirely (no entry point, no route, nothing recorded). Everything else that exists is **Gratuit**. When iOS sells a feature Android ships free, the table says « Gratuit (Pro sur iOS) » (no such case today); iOS Pro features absent on Android say « Pro sur iOS — absent ».

| ID | Feature | Tier | Statut Android | Drivable on the Pixel |
| --- | --- | --- | --- | --- |
| [`dictation.keyboard`](dictation.keyboard.md) | Dictation from the keyboard | Gratuit | présent | Yes — start + cancel proven on the Pixel (2026-10-20); ✓ records the room |
| [`dictation.in-app`](dictation.in-app.md) | Dictation inside the app | Gratuit | présent | Screens yes; opening the recorder records at once (and `Retour` does not stop it) |
| [`models.transcription`](models.transcription.md) | Transcription models | Gratuit | présent | Browsing yes; no download/delete on Pierre's phone |
| [`typing.autocorrect`](typing.autocorrect.md) | Autocorrect and suggestions | Gratuit | présent | Yes, keys by coordinate in a scratch note; the ⌫ undo step on a test device only |
| [`typing.learned-words`](typing.learned-words.md) | Learned words | Gratuit | partiel | No on Pierre's Pixel (learning is permanent, no reset): test device only |
| [`keyboard.languages`](keyboard.languages.md) | Keyboard languages and layouts | Gratuit | partiel | Yes (cycle a full turn) |
| [`keyboard.emoji`](keyboard.emoji.md) | Emoji | Gratuit | partiel | Yes |
| [`feedback.sounds-haptics`](feedback.sounds-haptics.md) | Sounds and haptics | Gratuit | présent | Settings only; no sound or vibration captured |
| [`onboarding`](onboarding.md) | Onboarding | Gratuit | partiel | No: needs a fresh install (data wipe forbidden) |
| [`diagnostics.logs`](diagnostics.logs.md) | Debug logs and diagnostics | Gratuit | présent | Yes (never « Effacer », never send) |
| [`appearance`](appearance.md) | Appearance: theme, interface language | Gratuit | Spécifique Android | Pickers only |

Not in the map as files, on purpose: the iOS features absent on Android (`smart-modes`, `history`, `vocabulary`, `voice-notes`, `pro.subscription`) and those that only make sense on iOS (`dictation.return-to-app`, `polish`, `live-activity`). They keep their row in the table below. `history` is the special case: implemented and unit-tested, but compiled out of every user path by `PremiumFlags.HISTORY_VISIBLE`. The debug-only `TestSurfaceScreen` is not reachable from any route and is not a feature.

## All IDs

Every iOS ID (the 176 of the iOS « All IDs » table, same order: 18 features, 109 sub-features, 49 screens), then the Android-only IDs. **Statut Android**: présent, partiel (with what is missing), absent, or Spécifique iOS (N/A: the iOS keyboard-to-app hand-off and Full Access, return to the host app, Apple Intelligence, Dynamic Island, App Group). Statuses come from the code of `develop` at `f2b15c5`, checked on the Pixel for every screen marked « oui » in [screens.md](screens.md) (2026-10-20).

| ID | Gratuit/Pro | Statut Android | Spécifique Android |
| --- | --- | --- | --- |
| [`dictation.keyboard`](dictation.keyboard.md) | Gratuit | présent | non |
| [`dictation.in-app`](dictation.in-app.md) | Gratuit | présent | non |
| `dictation.return-to-app` | N/A | Spécifique iOS (N/A) | non |
| [`models.transcription`](models.transcription.md) | Gratuit | présent | non |
| `polish` | N/A | Spécifique iOS (N/A) | non |
| `smart-modes` | Pro sur iOS — absent | absent | non |
| `history` | Pro (masqué : `PremiumFlags.HISTORY_VISIBLE = false`) | absent — implémenté (liste, détail, suppression) mais masqué | non |
| `vocabulary` | Pro sur iOS — absent | absent | non |
| `voice-notes` | Pro sur iOS — absent | absent | non |
| [`typing.autocorrect`](typing.autocorrect.md) | Gratuit | présent | non |
| [`typing.learned-words`](typing.learned-words.md) | Gratuit | partiel — pas de réinitialisation | non |
| [`keyboard.languages`](keyboard.languages.md) | Gratuit | partiel — pas de panneau, pas de QWERTZ, pas de rangée de chiffres | non |
| [`keyboard.emoji`](keyboard.emoji.md) | Gratuit | partiel — pas de recherche | non |
| [`feedback.sounds-haptics`](feedback.sounds-haptics.md) | Gratuit | présent | non |
| `live-activity` | N/A | Spécifique iOS (N/A) | non |
| [`onboarding`](onboarding.md) | Gratuit | partiel — pas d'étape langue, ni scènes Pro, ni Nouveautés | non |
| `pro.subscription` | Pro sur iOS — absent | absent | non |
| [`diagnostics.logs`](diagnostics.logs.md) | Gratuit | présent | non |
| `dictation.start` | Gratuit | présent | non |
| `dictation.stop` | Gratuit | présent | non |
| `dictation.cancel` | Gratuit | présent | non |
| `dictation.status` | Gratuit | présent | non |
| `dictation.undo-insert` | Gratuit | présent — puce « Annuler » (#137) | non |
| `dictation.handoff` | N/A | Spécifique iOS (N/A) | non |
| `dictation.requires-full-access` | N/A | Spécifique iOS (N/A) | non |
| `dictation.device-gating` | Gratuit | absent — aucun appareil refusé en bloc ; seul le filtre RAM des modèles existe | non |
| `dictation.start-in-app` | Gratuit | présent | non |
| `dictation.copy-last` | Gratuit | présent | non |
| `dictation.download-prompt` | Gratuit | partiel — pas d'invite sur Accueil ; seul le micro répond « Aucun modèle vocal » | non |
| `dictation.from-widget` | Gratuit | absent — pas de widget | non |
| `return.swipe-back` | N/A | Spécifique iOS (N/A) | non |
| `return.auto-return` | N/A | Spécifique iOS (N/A) | non |
| `models.catalogue` | Gratuit | présent | non |
| `models.recommended` | Gratuit | partiel — recommandation seulement dans l'onboarding, pas de badge dans Modèles | non |
| `models.download` | Gratuit | présent | non |
| `models.select` | Gratuit | présent | non |
| `models.delete` | Gratuit | présent | non |
| `models.retry` | Gratuit | partiel — « Réessayer » oui ; pas de suppression explicite d'un téléchargement partiel | non |
| `models.languages` | Gratuit | partiel — pas de fiche des langues ; seul Parakeet 110M porte « Anglais uniquement » | non |
| `models.preparation` | Gratuit | présent — overlay dans le clavier et l'enregistreur, snackbar dans Modèles | non |
| `models.device-gating` | Gratuit | présent — seuil RAM, carte grisée avec la raison (#121) | non |
| `polish.toggle` | N/A | Spécifique iOS (N/A) | non |
| `polish.clean-up` | N/A | Spécifique iOS (N/A) | non |
| `polish.in-keyboard` | N/A | Spécifique iOS (N/A) | non |
| `polish.debug` | N/A | Spécifique iOS (N/A) | non |
| `smart-modes.fan` | Pro sur iOS — absent | absent | non |
| `smart-modes.structured` | Pro sur iOS — absent | absent | non |
| `smart-modes.list` | Pro sur iOS — absent | absent | non |
| `smart-modes.message` | Pro sur iOS — absent | absent | non |
| `smart-modes.summary` | Pro sur iOS — absent | absent | non |
| `smart-modes.translate` | Pro sur iOS — absent | absent | non |
| `smart-modes.pin` | Pro sur iOS — absent | absent | non |
| `smart-modes.toggle` | Pro sur iOS — absent | absent | non |
| `history.list` | Pro (masqué : `PremiumFlags.HISTORY_VISIBLE = false`) | absent — code présent, masqué | non |
| `history.search` | Pro sur iOS — absent | absent — absent du code | non |
| `history.delete` | Pro (masqué : `PremiumFlags.HISTORY_VISIBLE = false`) | absent — code présent, masqué | non |
| `history.detail` | Pro (masqué : `PremiumFlags.HISTORY_VISIBLE = false`) | absent — code présent (copier, partager), masqué | non |
| `history.clear` | Pro sur iOS — absent | absent — absent du code | non |
| `history.toggle` | Pro sur iOS — absent | absent — absent du code | non |
| `history.home-entry` | Pro (masqué : `PremiumFlags.HISTORY_VISIBLE = false`) | absent — glisser vers le haut sur Accueil, masqué | non |
| `vocabulary.add` | Pro sur iOS — absent | absent | non |
| `vocabulary.edit` | Pro sur iOS — absent | absent | non |
| `vocabulary.delete` | Pro sur iOS — absent | absent | non |
| `vocabulary.reset` | Pro sur iOS — absent | absent | non |
| `vocabulary.suggestions` | Pro sur iOS — absent | absent | non |
| `vocabulary.apply` | Pro sur iOS — absent | absent | non |
| `vocabulary.toggle` | Pro sur iOS — absent | absent | non |
| `voice-notes.share-in` | Pro sur iOS — absent | absent | non |
| `voice-notes.transcribe` | Pro sur iOS — absent | absent | non |
| `voice-notes.after-mode` | Pro sur iOS — absent | absent | non |
| `voice-notes.language` | Pro sur iOS — absent | absent | non |
| `voice-notes.reader` | Pro sur iOS — absent | absent | non |
| `voice-notes.insert` | Pro sur iOS — absent | absent | non |
| `voice-notes.delete` | Pro sur iOS — absent | absent | non |
| `voice-notes.toggle` | Pro sur iOS — absent | absent | non |
| `voice-notes.progress-activity` | N/A | Spécifique iOS (N/A) | non |
| `typing.suggestions` | Gratuit | présent | non |
| `typing.autocorrect-on-space` | Gratuit | présent | non |
| `typing.undo-correction` | Gratuit | partiel — ⌫ juste après la correction ; pas de puce dans la barre | non |
| `typing.auto-full-stop` | Gratuit | absent | non |
| `typing.accents` | Gratuit | présent — appui long, bandeau d'accents | non |
| `typing.dead-keys` | Gratuit | absent | non |
| `typing.autocorrect-toggle` | Gratuit | présent | non |
| `learned-words.learn` | Gratuit | présent | non |
| `learned-words.reset` | Gratuit | absent — pas de bouton ; seul l'effacement des données de l'app | non |
| `keyboard.language-switch` | Gratuit | présent — tap sur le code langue (FR→EN→ES→DE), pas de panneau | non |
| `keyboard.layout` | Gratuit | partiel — AZERTY / QWERTY, pas de QWERTZ | non |
| `keyboard.number-row` | Gratuit | absent | non |
| `keyboard.default-page` | Gratuit | présent | non |
| `keyboard.transcription-language` | Gratuit | partiel — Automatique ou fixe ; pas de « Suivre la langue du clavier » | non |
| `keyboard.open-app` | Gratuit | présent — appui long sur le code langue → Réglages | non |
| `emoji.picker` | Gratuit | présent | non |
| `emoji.recents` | Gratuit | présent — « UTILISÉS RÉCEMMENT » (EmojiPickerView), vu sur le Pixel | non |
| `emoji.search` | Gratuit | absent | non |
| `emoji.back-to-letters` | Gratuit | présent | non |
| `sounds.toggle` | Gratuit | présent | non |
| `sounds.volume` | Gratuit | présent | non |
| `sounds.per-event` | Gratuit | présent | non |
| `haptics.toggle` | Gratuit | présent | non |
| `live-activity.standby` | N/A | Spécifique iOS (N/A) | non |
| `live-activity.states` | N/A | Spécifique iOS (N/A) | non |
| `live-activity.stop-standby` | N/A | Spécifique iOS (N/A) | non |
| `live-activity.controls` | N/A | Spécifique iOS (N/A) | non |
| `live-activity.toggle` | N/A | Spécifique iOS (N/A) | non |
| `onboarding.welcome` | Gratuit | présent | non |
| `onboarding.language` | Gratuit | absent — pas d'étape langue/disposition | non |
| `onboarding.keyboard-setup` | N/A | Spécifique iOS (N/A) — équivalent Android : onboarding.ime-setup | non |
| `onboarding.apple-intelligence` | N/A | Spécifique iOS (N/A) | non |
| `onboarding.pro-scenes` | Gratuit | absent | non |
| `onboarding.smart-mode-pick` | Gratuit | absent | non |
| `onboarding.model-download` | Gratuit | présent | non |
| `onboarding.microphone` | Gratuit | présent | non |
| `onboarding.first-dictation` | Gratuit | présent | non |
| `onboarding.stop-standby` | N/A | Spécifique iOS (N/A) | non |
| `onboarding.completion` | Gratuit | présent | non |
| `onboarding.resume` | Gratuit | partiel — survit à la mort du process, pas à un arrêt forcé | non |
| `onboarding.whats-new` | Gratuit | absent | non |
| `pro.hub` | Pro sur iOS — absent | absent | non |
| `pro.paywall` | Pro sur iOS — absent | absent | non |
| `pro.restore` | Pro sur iOS — absent | absent | non |
| `pro.trial` | Pro sur iOS — absent | absent | non |
| `pro.trial-end` | Pro sur iOS — absent | absent | non |
| `pro.demo` | Pro sur iOS — absent | absent | non |
| `diagnostics.log-view` | Gratuit | présent | non |
| `diagnostics.log-export` | Gratuit | présent | non |
| `diagnostics.app-group-check` | N/A | Spécifique iOS (N/A) | non |
| `diagnostics.about` | Gratuit | présent | non |
| `app.onboarding.welcome` | Gratuit | présent | non |
| `app.onboarding.language` | Gratuit | absent | non |
| `app.onboarding.keyboard-setup` | N/A | Spécifique iOS (N/A) — équivalent : app.onboarding.ime-setup | non |
| `app.onboarding.apple-intelligence` | N/A | Spécifique iOS (N/A) | non |
| `app.onboarding.smart-modes-scene` | Gratuit | absent | non |
| `app.onboarding.smart-mode-pick` | Gratuit | absent | non |
| `app.onboarding.voice-notes-scene` | Gratuit | absent | non |
| `app.onboarding.vocabulary-scene` | Gratuit | absent | non |
| `app.onboarding.history-scene` | Gratuit | absent | non |
| `app.onboarding.model-preparation` | Gratuit | présent | non |
| `app.onboarding.microphone` | Gratuit | présent | non |
| `app.onboarding.first-dictation` | Gratuit | présent | non |
| `app.onboarding.stop-standby` | N/A | Spécifique iOS (N/A) | non |
| `app.onboarding.completion` | Gratuit | présent | non |
| `app.whats-new` | Gratuit | absent | non |
| `app.home` | Gratuit | présent | non |
| `app.recording` | Gratuit | présent | non |
| `app.history` | Pro (masqué : `PremiumFlags.HISTORY_VISIBLE = false`) | absent — code présent, route non enregistrée | non |
| `app.history.detail` | Pro (masqué : `PremiumFlags.HISTORY_VISIBLE = false`) | absent — code présent, masqué | non |
| `app.models` | Gratuit | présent | non |
| `app.models.languages` | Gratuit | absent | non |
| `app.models.loading` | Gratuit | partiel — pas d'overlay plein écran dans Modèles ; voir kbd.model-loading | non |
| `app.settings` | Gratuit | présent | non |
| `app.settings.sounds` | Gratuit | présent | non |
| `app.settings.diagnostic` | N/A | Spécifique iOS (N/A) | non |
| `app.settings.debug-logs` | Gratuit | présent | non |
| `app.settings.licences` | Gratuit | présent | non |
| `app.settings.polish-debug` | N/A | Spécifique iOS (N/A) | non |
| `app.pro.hub` | Pro sur iOS — absent | absent | non |
| `app.pro.smart-modes` | Pro sur iOS — absent | absent | non |
| `app.pro.history` | Pro sur iOS — absent | absent | non |
| `app.pro.vocabulary` | Pro sur iOS — absent | absent | non |
| `app.pro.vocabulary.term-editor` | Pro sur iOS — absent | absent | non |
| `app.pro.voice-notes` | Pro sur iOS — absent | absent | non |
| `app.paywall` | Pro sur iOS — absent | absent | non |
| `app.pro.trial-announcement` | Pro sur iOS — absent | absent | non |
| `app.voice-note.result` | Pro sur iOS — absent | absent | non |
| `kbd.keys` | Gratuit | présent | non |
| `kbd.no-full-access` | N/A | Spécifique iOS (N/A) | non |
| `kbd.dictation-error` | Gratuit | présent — « Aucun modèle vocal » / « Impossible de démarrer la reconnaissance vocale » | non |
| `kbd.recording` | Gratuit | présent | non |
| `kbd.panel` | Gratuit | absent | non |
| `kbd.emoji` | Gratuit | présent | non |
| `kbd.voice-note-reader` | Pro sur iOS — absent | absent | non |
| `kbd.smart-mode-fan` | Pro sur iOS — absent | absent | non |
| `kbd.suggestions` | Gratuit | présent | non |
| `sys.settings.full-access` | N/A | Spécifique iOS (N/A) | non |
| `share.voice-note` | Pro sur iOS — absent | absent | non |
| `widget.live-activity` | N/A | Spécifique iOS (N/A) | non |
| [`appearance`](appearance.md) | Gratuit | présent — thème et langue de l'interface | oui |
| `appearance.theme` | Gratuit | présent | oui |
| `appearance.ui-language` | Gratuit | présent | oui |
| `dictation.notification` | Gratuit | présent — notification « Dictus - Recording » + Stop (invisible sur le Pixel : notifications refusées) | oui |
| `dictation.switch-keyboard` | Gratuit | présent — engrenage pendant l'enregistrement → sélecteur de clavier | oui |
| `typing.trackpad` | Gratuit | présent — appui long sur espace + glisser | oui |
| `typing.adaptive-accent-key` | Gratuit | présent — touche ' AZERTY → é à ù î ô | oui |
| `typing.suggestions-toggle` | Gratuit | présent | oui |
| `typing.private-fields` | Gratuit | présent — pas de suggestions ni d'apprentissage dans les champs sensibles | oui |
| `sounds.key-clicks` | Gratuit | présent — « Sons du clavier » | oui |
| `onboarding.ime-setup` | Gratuit | présent | oui |
| `onboarding.default-page` | Gratuit | présent — ABC / 123 | oui |
| `models.english-only-warning` | Gratuit | présent — Parakeet 110M | oui |
| `models.storage` | Gratuit | présent — « Stockage utilisé » | oui |
| `app.onboarding.ime-setup` | Gratuit | présent | oui |
| `app.onboarding.default-page` | Gratuit | présent | oui |
| `app.settings.sound-picker` | Gratuit | présent | oui |
| `app.settings.picker` | Gratuit | présent — feuilles de choix des Réglages | oui |
| `kbd.model-loading` | Gratuit | présent | oui |
| `sys.ime-picker` | Gratuit | présent | oui |
| `sys.settings.ime` | Gratuit | présent | oui |
| `sys.notification.recording` | Gratuit | présent | oui |

**Décompte** (198 IDs : 176 iOS + 22 Spécifique Android) : présent **59**, partiel **13**, absent **75**, Spécifique iOS (N/A) **29**, Spécifique Android **22**.

Sur les 147 IDs iOS applicables à Android : 59 présents, 13 partiels, 75 absents. 55 de ces absents sont des fonctions Pro d'iOS (Smart Modes, historique, vocabulaire, notes vocales, abonnement, avec leurs écrans) ; les 20 autres sont gratuits sur iOS.

## Écarts de design avec iOS

Écran par écran, ce qui se voit différemment entre les captures Android de `../screens/` et le design iOS (captures `docs/agents/screens/` du repo iOS, simulateur iPhone 17 en thème clair, et `verify-dictus-ios/features/`). Chaque écart est formulé pour devenir une issue : **écran**, **iOS**, **Android**, **proposition**. Les écarts qui découlent d'une fonctionnalité absente (Smart Modes, Pro…) sont dans le tableau ci-dessus, pas ici. Le thème diffère par construction : iOS suit l'apparence du système, Android est en thème Sombre par défaut ; les comparaisons portent sur la structure, pas sur les couleurs.

1. **Barre du clavier — `kbd.keys`, `kbd.suggestions`** (issue #139, en attente d'une maquette validée par Pierre ; non lancée ici).
   - iOS : une seule barre au-dessus des touches : ☰ à gauche, les suggestions au centre, le micro (pilule bleue) à droite ; « Annuler » s'y affiche aussi.
   - Android : deux rangées empilées : la barre de suggestions (3 cases, puce « Annuler » après une dictée) puis la rangée code langue `FR` à gauche + micro à droite. Le clavier est plus haut et le micro est séparé des suggestions.
   - Proposition : fusionner en une barre unique selon la maquette de #139.
2. **Dictée dans le clavier — `kbd.recording`**
   - iOS : ✕ et ✓ dans la barre du clavier, onde au-dessus des touches.
   - Android : panneau qui remplace tout le clavier : ✕ / ✓ en haut, onde + minuteur + « En écoute… » au centre, et en bas à gauche un engrenage collé à la barre de navigation du clavier système (à côté de ⌄), dont le libellé d'accessibilité est en anglais (`Settings`) et qui ouvre… le sélecteur de clavier Android, pas les réglages.
   - Proposition : aligner la barre d'enregistrement sur #139 ; remplacer l'engrenage par une icône de changement de clavier libellée « Changer de clavier ».
3. **Langues du clavier — `kbd.panel`**
   - iOS : appui long sur ☰ : un panneau liste Français / English / Español / Deutsch et les dispositions, fermé par ✕.
   - Android : pas de panneau ; un tap sur le code `FR` passe à la langue suivante (FR→EN→ES→DE), un appui long ouvre Réglages. Rien n'indique ces gestes.
   - Proposition : un menu ☰ (ou un appui long sur le code) qui liste les langues et la disposition, comme iOS.
4. **Accueil sans modèle — `app.home`**
   - iOS : sans modèle, une carte « Télécharger un modèle pour commencer » renvoie vers Modèles et remplace « Nouvelle dictée ».
   - Android : Accueil affiche toujours « Modèle actif » et « Nouvelle dictée » ; l'absence de modèle n'apparaît qu'au tap sur le micro (« Aucun modèle vocal »).
   - Proposition : la même carte d'invite sur Accueil quand aucun modèle n'est téléchargé.
5. **Cartes de modèle — `app.models`**
   - iOS : badge du moteur (`WK`, `PK`), badge « Recommandé » sur le modèle conseillé pour l'appareil, ⓘ « Langues prises en charge » sur chaque carte.
   - Android : badges moteur `WK` / `NV` présents, mais pas de badge Recommandé (seulement dans l'onboarding) ni de ⓘ ; seul Parakeet 110M porte « Anglais uniquement » ; descriptions sans accents (« Rapide et leger », « Precis et equilibre », « Haute precision », « Detection automatique ») ; ligne « Stockage utilisé » en bas.
   - Proposition : badge « Recommandé » et fiche des langues par modèle ; accentuer les descriptions.
6. **Réglages — `app.settings`**
   - iOS : en-têtes de section en casse normale (« Transcription », « Clavier »), langue de transcription « Suivre la langue du clavier », choix ABC / 123 en segment avec un aperçu du clavier.
   - Android : pas de titre de page (l'écran commence directement par « TRANSCRIPTION », alors que Modèles a son grand titre) ; en-têtes en capitales, dont « A PROPOS » sans accent ; tous les choix passent par des feuilles (`app.settings.picker`) ; section APPARENCE en plus ; pas d'option « Suivre la langue du clavier ».
   - Proposition : titre « Réglages » comme sur Modèles ; corriger « À PROPOS » ; un segment ABC / 123 inline ; ajouter « Suivre la langue du clavier » à la langue de transcription.
7. **Sons — `app.settings.sounds`**
   - iOS : « Activer les sons » avec une note explicative, « Sons par événement » : Début, Fin, Annuler avec le son choisi affiché à droite.
   - Android : « Son de dictée » sans note explicative, sections « GENERAL » (sans accent) et « SONS », lignes « Son de début / de fin / d'annulation » avec le son à droite (grisées tant que le son est coupé).
   - Proposition : « GÉNÉRAL » ; libellés courts d'iOS (Début, Fin, Annuler) et une note sous l'interrupteur.
8. **Notification d'enregistrement — `sys.notification.recording`**
   - iOS : pas de notification (Dynamic Island, Spécifique iOS).
   - Android : notification en anglais « Dictus - Recording » avec l'action « Stop », sur un appareil en français.
   - Proposition : traduire (« Dictus — Enregistrement », « Arrêter »).
9. **Onboarding — `app.onboarding.*`**
   - iOS : barre de progression en tirets en haut, illustrations, accroche « Parlez. Dictus écrit. », étape langue + disposition.
   - Android : points de progression, accroche « Dictation vocale, 100 % offline » (« Dictation » est de l'anglais ; en français : « Dictée vocale »), pas d'étape langue mais une étape ABC / 123.
   - Proposition : corriger l'accroche ; remplacer l'étape ABC / 123 par l'étape langue + disposition d'iOS (le mode par défaut reste dans Réglages).
10. **Emoji — `kbd.emoji`**
    - iOS : catégories en bas avec 🔍 « Rechercher des Emoji » et ABC.
    - Android : `EmojiPickerView` d'androidx, catégories en haut, pas de recherche ; ABC et ⌫ en bas ; la rangée micro disparaît pendant le choix d'emoji (sur iOS, ☰ et le micro restent visibles).
    - Proposition : ajouter la recherche d'emoji (mots-clés français) et garder la barre du clavier visible (avec #139).
11. **Sélecteur de clavier système — `sys.ime-picker`**
    - iOS : le clavier apparaît une fois, « Dictus », dans la liste du globe.
    - Android : Dictus y déclare deux sous-types, « AZERTY (Français) » et « QWERTY (Anglais) », sans rapport avec les quatre langues réelles (FR, EN, ES, DE) ni avec la disposition choisie dans Réglages.
    - Proposition : un seul sous-type « Dictus » (ou un par langue réellement prise en charge).
12. **Libellés d'accessibilité du clavier — `kbd.keys`, `kbd.recording`**
    - iOS : libellés en français sur un appareil français.
    - Android : `Keyboard language DE`, `Settings` en anglais (le reste est en français : `Microphone`, `Annuler la dernière dictée`).
    - Proposition : traduire ces content descriptions (strings.xml FR/EN).

## Anomalie fonctionnelle constatée pendant les captures (hors design)

- **`app.recording` — `Retour` n'arrête pas l'enregistrement** (Pixel 4, build de `develop` `f2b15c5`, 2026-10-20 21:43). « Nouvelle dictée » démarre l'enregistrement aussitôt ; quitter l'écran par `Retour` ramène à Accueil mais `DictationService` reste au premier plan (`isForeground=true`), le témoin micro reste vert, aucune ligne `Recording cancelled`. Il a fallu « Applis actives → Arrêter » pour libérer le micro. Preuve hors repo : `/home/pierre/Dev/dictus-proofs/verify-dictus-android/20261020-214307-0f15824/90-bug-recording-continues-after-retour.png`. Proposition : annuler l'enregistrement (ou demander confirmation) en quittant l'écran ; à ouvrir en issue avec le label `needs-physical-test`.
