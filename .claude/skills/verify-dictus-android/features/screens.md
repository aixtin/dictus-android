# Dictus Android screen map

One stable ID per screen, `<surface>.<area>[.<sub>]`, **the same IDs as the iOS screen map** when the screen exists on both: `app` (the Dictus app), `kbd` (the Dictus keyboard, drawn over any app), `sys` (Android system screens Dictus depends on), `share` and `widget` (iOS only today). Android-only screens get new IDs in the same format and are listed last.

Captures are in [`../screens/`](../screens/), one `<screen-id>.png` each: Pixel 4, LineageOS, French, with Pierre's own theme and settings, taken with `helpers/screen.sh` (adb screencap, resized to 1140 px high, quantized). Re-take one with `helpers/screen.sh <screen-id>` (see `../SKILL.md`, Evidence). Recipes use the labels of `../SKILL.md` → Drive.

| Screen ID | Screen | How to reach it | Features | States | Capture |
| --- | --- | --- | --- | --- | --- |
| `app.onboarding.welcome` | Onboarding 1/7 : « Dictus — Dictation vocale, 100 % offline », « Commencer » | fresh install only | onboarding | — | non — Onboarding terminé sur le Pixel ; le revoir exige d'effacer les données (interdit) |
| `app.onboarding.language` | — | — | onboarding | absent sur Android | — |
| `app.onboarding.keyboard-setup` | — | — | onboarding | Spécifique iOS ; voir app.onboarding.ime-setup | — |
| `app.onboarding.apple-intelligence` | — | — | onboarding | Spécifique iOS | — |
| `app.onboarding.smart-modes-scene` | — | — | onboarding, smart-modes | absent | — |
| `app.onboarding.smart-mode-pick` | — | — | onboarding, smart-modes | absent | — |
| `app.onboarding.voice-notes-scene` | — | — | onboarding, voice-notes | absent | — |
| `app.onboarding.vocabulary-scene` | — | — | onboarding, vocabulary | absent | — |
| `app.onboarding.history-scene` | — | — | onboarding, history | absent | — |
| `app.onboarding.model-preparation` | Onboarding 5/7 : « Modèle vocal », modèle recommandé, « Télécharger » | fresh install, after step 4 | onboarding, models.transcription | à télécharger / « Téléchargement — N% » / « Extraction des fichiers… » / « Échec du téléchargement. » + « Réessayer » / « Continuer » | non — Onboarding terminé ; en plus, l'étape télécharge un modèle |
| `app.onboarding.microphone` | Onboarding 2/7 : « Microphone », « Autoriser le micro » | fresh install, after step 1 | onboarding | non accordé / accordé (« Continuer ») | non — Onboarding terminé sur le Pixel |
| `app.onboarding.first-dictation` | Onboarding 6/7 : « Testez la dictée », micro, « Résultat » | fresh install, after step 5 | onboarding, dictation.in-app | repos / enregistrement « Toucher pour arrêter » / « Transcription en cours… » / résultat | non — Onboarding terminé sur le Pixel |
| `app.onboarding.stop-standby` | — | — | onboarding | Spécifique iOS | — |
| `app.onboarding.completion` | Onboarding 7/7 : « C'est prêt ! », « Commencer » | fresh install, after step 6 | onboarding | — | non — Onboarding terminé sur le Pixel |
| `app.whats-new` | — | — | onboarding | absent | — |
| `app.home` | Onglet Accueil : logo, « Modèle actif », « Dernière transcription » + Copier, « Nouvelle dictée » | tap `Accueil` | dictation.in-app | sans dernière transcription (capturé) / avec | [oui](../screens/app.home.png) |
| `app.recording` | Dictée plein écran : minuteur, « Arrêter », « Toucher pour arrêter » | Accueil → `Nouvelle dictée` (starts recording at once; `Retour` does not stop it) | dictation.in-app | repos / enregistrement / transcription / « Résultat » + Copier / overlay de chargement ou « Aucun modèle vocal » | [oui](../screens/app.recording.png) |
| `app.history` | — | route non enregistrée (`PremiumFlags.HISTORY_VISIBLE = false`) | history | absent (code présent) | — |
| `app.history.detail` | — | idem | history | absent (code présent) | — |
| `app.models` | Onglet Modèles : « Téléchargés », « Disponibles », stockage | tap `Modèles` | models.transcription | carte active « Actif » / téléchargement « N% » / échec « Réessayer » / grisée « Nécessite N Go de RAM ou plus » / dialogues « Supprimer … ? », « Modèle anglais uniquement », « RAM insuffisante » | [oui](../screens/app.models.png) |
| `app.models.languages` | — | — | models.transcription | absent | — |
| `app.models.loading` | « Chargement du modèle… » (snackbar) | Modèles → tap a downloaded model | models.transcription | partiel : pas d'overlay plein écran ici (voir kbd.model-loading) | non — Changer de modèle actif modifierait le réglage de Pierre |
| `app.settings` | Onglet Réglages : TRANSCRIPTION, CLAVIER, APPARENCE, A PROPOS | tap `Réglages`; also long-press the keyboard's language code (no bottom tabs) | keyboard.languages, typing.*, feedback.sounds-haptics, appearance, diagnostics.logs | haut / bas de page (scroll) / ouvert depuis le clavier (sans onglets) | [oui](../screens/app.settings.png) |
| `app.settings.sounds` | Réglages → Sons | Réglages → `Sons` | feedback.sounds-haptics | son activé / désactivé | [oui](../screens/app.settings.sounds.png) |
| `app.settings.diagnostic` | — | — | diagnostics.logs | Spécifique iOS | — |
| `app.settings.debug-logs` | Réglages → Debug Logs, menu Effacer / Copier | Réglages, scroll → `Debug Logs` | diagnostics.logs | logs / « Aucun log disponible » / menu ouvert | [oui](../screens/app.settings.debug-logs.png) |
| `app.settings.licences` | Réglages → Licences | Réglages, scroll → `Licences` | diagnostics.logs | — | [oui](../screens/app.settings.licences.png) |
| `app.settings.polish-debug` | — | — | polish | Spécifique iOS | — |
| `app.pro.hub` | — | — | pro.subscription | absent | — |
| `app.pro.smart-modes` | — | — | smart-modes | absent | — |
| `app.pro.history` | — | — | history | absent | — |
| `app.pro.vocabulary` | — | — | vocabulary | absent | — |
| `app.pro.vocabulary.term-editor` | — | — | vocabulary | absent | — |
| `app.pro.voice-notes` | — | — | voice-notes | absent | — |
| `app.paywall` | — | — | pro.subscription | absent | — |
| `app.pro.trial-announcement` | — | — | pro.subscription | absent | — |
| `app.voice-note.result` | — | — | voice-notes | absent | — |
| `kbd.keys` | Clavier Dictus : barre de suggestions, rangée code langue + micro, touches AZERTY | focus a text field in another app (scratch note) | dictation.keyboard, typing.*, keyboard.languages | lettres / 123 / #+= / maj / bandeau d'accents / trackpad (étiquettes masquées) / FR EN ES DE | [oui](../screens/kbd.keys.png) |
| `kbd.no-full-access` | — | — | dictation.keyboard | Spécifique iOS | — |
| `kbd.dictation-error` | Overlay du clavier : « Aucun modèle vocal » ou « Impossible de démarrer la reconnaissance vocale » + Réessayer / Annuler | mic tap with no model / engine failure | dictation.keyboard | modèle absent / échec de chargement | non — Pierre a un modèle : provoquer l'erreur exigerait de supprimer son modèle |
| `kbd.recording` | Clavier en dictée : ✕ / ✓, onde, minuteur, « En écoute… », engrenage | mic tap | dictation.keyboard | enregistrement / « Transcription… » | [oui](../screens/kbd.recording.png) |
| `kbd.panel` | — | — | keyboard.languages | absent (tap sur le code langue à la place) | — |
| `kbd.emoji` | Sélecteur d'emoji, ABC et ⌫ en bas | tap 😊 | keyboard.emoji | catégories / récents | [oui](../screens/kbd.emoji.png) |
| `kbd.voice-note-reader` | — | — | voice-notes | absent | — |
| `kbd.smart-mode-fan` | — | — | smart-modes | absent | — |
| `kbd.suggestions` | Barre de suggestions (3 cases) ; puce « Annuler » après une dictée | type in a scratch note | typing.autocorrect, dictation.keyboard | complétions / prédictions / puce d'annulation de dictée | [oui](../screens/kbd.suggestions.png) |
| `sys.settings.full-access` | — | — | dictation.keyboard | Spécifique iOS | — |
| `share.voice-note` | — | — | voice-notes | absent | — |
| `widget.live-activity` | — | — | live-activity | Spécifique iOS | — |
| **Spécifique Android** | | | | | |
| `app.onboarding.ime-setup` | Onboarding 3/7 : « Ajouter le clavier », « Ouvrir les paramètres » / « Sélectionner Dictus » / « Continuer » | fresh install, after step 2 | onboarding | non activé / activé non sélectionné / prêt | non — Onboarding terminé sur le Pixel |
| `app.onboarding.default-page` | Onboarding 4/7 : « Choisissez votre clavier », ABC / 123 | fresh install, after step 3 | onboarding | ABC / 123 | non — Onboarding terminé sur le Pixel |
| `app.settings.sound-picker` | Liste de sons (Son de début / de fin / d'annulation) | Réglages → Sons → `Son de début` | feedback.sounds-haptics | son sélectionné coché | [oui](../screens/app.settings.sound-picker.png) |
| `app.settings.picker` | Feuilles de choix : Langue, Langue du clavier, Disposition du clavier, Mode par défaut, Thème, Langue de l'interface | Réglages → tap a row | keyboard.languages, appearance | une feuille par réglage | [oui](../screens/app.settings.picker.png) |
| `kbd.model-loading` | Overlay du clavier : « Préparation de la reconnaissance vocale », micro grisé | mic tap while the model loads (first use after the process starts) | dictation.keyboard, models.transcription | chargement / échec | non — Fenêtre de chargement trop brève pour être capturée de façon fiable sans tuer le process |
| `sys.ime-picker` | Sélecteur de clavier Android : « Clavier Android (AOSP) », « Clavier Dictus » avec « AZERTY (Français) » / « QWERTY (Anglais) » | long-press the nav bar's keyboard button (never a tap), onboarding « Sélectionner Dictus », or the gear during a keyboard recording | dictation.keyboard, onboarding | — | [oui](../screens/sys.ime-picker.png) |
| `sys.settings.ime` | Paramètres Android → Clavier à l'écran | onboarding « Ouvrir les paramètres » | onboarding | — | non — Hors de l'app ; écran système, non nécessaire à la carte |
| `sys.notification.recording` | Notification « Dictus - Recording » + Stop | pull down the shade during a recording | dictation.keyboard | — | non — Notifications refusées pour Dictus sur le Pixel (réglage de Pierre) : la notification n'apparaît pas ; seul « 1 appli est active » dans les réglages rapides |

14 of the 26 screens that exist on Android are captured (the 31 others are absent on Android or Spécifique iOS, marked « — »). Each « non » gives its reason: a step that needs a fresh install or a data wipe, a model download, deletion or switch, a permission Pierre refused, or a state too brief to capture reliably.
