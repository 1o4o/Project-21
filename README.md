# 🃏 Project: Blackjack Horror Variant (Working Title)

A gritty, psychological horror 1v1 card game built in **Godot 4**. This project re-imagines classic Blackjack mechanics into a tense, tactical battle of wits against a calculating AI. Featuring dynamic rules, hidden information, and a game-altering inventory of reality-bending **Trump Cards**.

---

## 👁️ Core Mechanics

The foundation is built on Blackjack, but the house rules are twisted:
*   **The Volatile Deck:** The deck consists of a lean, single copy of card values `1` through `11`. Drawing rapidly burns safe numbers, drastically increasing high-end volatility.
*   **Dynamic Targets:** The round target isn't always 21. Players must adapt as target lines shift dynamically or are manipulated via card effects.
*   **Paranoia & Intel:** High difficulties introduce a percentage-based psychological "peek" chance where the AI can read your hidden card, forcing you to play against an opponent that can actively sense your bluffs.


## 🧠 Strategic AI Matrix

The game features an adaptive, predictive AI engine designed across four distinct difficulty tiers:
1.  **Easy (The Reckless Gambler):** High bust rate, panics easily, and is easily baited into over-drawing.
2.  **Normal (The Balanced Challenger):** Emulates standard, cautious human play patterns.
3.  **Hard (The Calculated Executioner):** Patient and predictive. Weaponizes player greed by standing early on mediocre hands and forcing you to take the risk of busting.
4.  **Insane (The Mastermind):** Possesses a high percentage chance to read your hidden card at the start of a round. Plays with absolute, terrifying defensive precision.


## 🔮 The Trump Card System

Matches are decided by an inventory phase executed right before standard draws. Trump cards alter stakes, manipulate card values, or disrupt the board state entirely.

### Featured Cards from the Registry:
*   **Perfect Draw:** Programmatically searches the remaining deck loop to draw the absolute highest value card that will not cause a bust.
*   **Pessimism:** A decoy card that does nothing on its own but creates stack duplicates on the table to act as a meat-shield against destructive mechanics.
*   **Tether:** Binds both players to the table, completely disabling the ability to `Stand` until a set number of cards have been drawn.
*   **Go for 17 / 24 / 27:** Instantly warps the reality of the board by overwriting the current target limit.

---

## 🛠️ Technical Stack & Environment

*   **Engine:** Godot 4+ (GDScript)
*   **Environment Layout:** 3D World Space.

---

## 🚀 Getting Started

### Prerequisites
*   Godot Engine 4.x (Standard or Mono edition)
