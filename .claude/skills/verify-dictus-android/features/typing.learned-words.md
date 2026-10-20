# Learned words

Words the user types or picks repeatedly, and words whose correction was undone, are learned and no longer corrected.

- **ID:** `typing.learned-words`
- **Tier:** Gratuit
- **Statut Android:** partiel (no reset)
- **Screens:** `kbd.keys` — see [screens.md](screens.md)

## Sub-features

- `learned-words.learn`: A word typed (or picked in the bar) twice is learned; ⌫ right after an autocorrection learns the original at once. — présent
- `learned-words.reset`: — absent: no « Reset learned words » in Réglages; only clearing the app's data empties the personal dictionary.

## How to get to it (user POV)

1. Type a word Dictus does not know twice, or undo its correction with ⌫.
2. The next time, the word is left as typed.

## Driving it with Argent

Preconditions: Launch and Doctor OK, a scratch note focused, a nonsense word never typed before on this phone (e.g. `zorbik` plus the run id's last digits).

- **First time.** Type the word through the keys, tap space. → it may be corrected; tap ⌫ to restore it.
- **Second time.** Type it again, tap space. → left as typed (`evidence.sh learned`).
- **Proof.** The field value in the tree at both steps.

## Gotchas

- Learning is permanent on Pierre's phone and there is no reset: use a nonsense word nobody would type, and say so in the report.
- Learning is off in password/e-mail/URL/search fields and in apps that request no personalised learning.
