extends Node

var data = [
	{
		"name": "Hush",
		"desc": "Draw one card. Its value will be hidden from the opponent.",
		"flavorText": "“Silence speaks louder than any number.”",
		"tooltip": null,
		"weight": 320,
		"weightChange": 10
	},
	{
		"name": "Perfect Draw",
		"desc": "Draw the best possible card.",
		"flavorText": "“Some chances were meant for those who never stopped believing.”",
		"tooltip": "Searches the deck and draws the most favorable card for your current hand. If no possible best card is found, nothing happens.",
		"weight": 340,
		"weightChange": -25
	},
	{
		"name": "Draw 1",
		"desc": "Draw the card number 1. If this card is already on the table, nothing happens.",
		"flavorText": "“The Spark”",
		"tooltip": null,
		"weight": 290,
		"weightChange": -15
	},
	{
		"name": "Draw 2",
		"desc": "Draw the card number 2. If this card is already on the table, nothing happens.",
		"flavorText": "“The Pair”",
		"tooltip": null,
		"weight": 290,
		"weightChange": -15
	},
	{
		"name": "Draw 3",
		"desc": "Draw the card number 3. If this card is already on the table, nothing happens.",
		"flavorText": "“The Triad”",
		"tooltip": null,
		"weight": 290,
		"weightChange": -15
	},
	{
		"name": "Draw 4",
		"desc": "Draw the card number 4. If this card is already on the table, nothing happens.",
		"flavorText": "“The Stagnant”",
		"tooltip": null,
		"weight": 290,
		"weightChange": -15
	},
	{
		"name": "Draw 5",
		"desc": "Draw the card number 5. If this card is already on the table, nothing happens.",
		"flavorText": "“The Quinary”",
		"tooltip": null,
		"weight": 290,
		"weightChange": -15
	},
	{
		"name": "Draw 6",
		"desc": "Draw the card number 6. If this card is already on the table, nothing happens.",
		"flavorText": "“The Ritual”",
		"tooltip": null,
		"weight": 290,
		"weightChange": -15
	},
	{
		"name": "Draw 7",
		"desc": "Draw the card number 7. If this card is already on the table, nothing happens.",
		"flavorText": "“The Zenith”",
		"tooltip": null,
		"weight": 290,
		"weightChange": -15
	},
	{
		"name": "Go for 17",
		"desc": "Set the target number to 17.",
		"flavorText": "“To settle for less is still to reach for something.”",
		"tooltip": "If multiple \"Go for X\" cards are in the table, only the most recently played one takes effect.",
		"weight": 270,
		"weightChange": 25
	},
	{
		"name": "Go for 24",
		"desc": "Set the target number to 24.",
		"flavorText": "“Hope demands more than reason ever allowed.”",
		"tooltip": "If multiple \"Go for X\" cards are in the table, only the most recently played one takes effect.",
		"weight": 270,
		"weightChange": 25
	},
	{
		"name": "Go for 27",
		"desc": "Set the target number to 27.",
		"flavorText": "“Greed whispers louder than reason.”",
		"tooltip": "If multiple \"Go for X\" cards are in the table, only the most recently played one takes effect.",
		"weight": 270,
		"weightChange": 25
	},
	{
		"name": "Disservice",
		"desc": "Opponent draws a card.",
		"flavorText": "“Kindness is just cruelty wearing a borrowed face.”",
		"tooltip": "If the opponent's total value already exceeds the target value, nothing happens.",
		"weight": 170,
		"weightChange": -10
	},
	{
		"name": "Exchange",
		"desc": "Swap the last card you drew with the opponent's last drew card.",
		"flavorText": "“What fate gives freely, envy teaches us to reclaim.\"",
		"tooltip": null,
		"weight": 210,
		"weightChange": -8
	},
	{
		"name": "Refresh",
		"desc": "Return all of your card to the deck and draw two new cards.",
		"flavorText": "“To begin again is to bury what failed before.”",
		"tooltip": null,
		"weight": 210,
		"weightChange": -5
	},
	{
		"name": "Rewind",
		"desc": "Return the last card you drew to the deck.",
		"flavorText": "“If only every mistake had a handle.”",
		"tooltip": null,
		"weight": 320,
		"weightChange": -10
	},
	{
		"name": "Safe Draw",
		"desc": "Draw a card, if it causes you to go over the target value, return that card to the deck immediately.",
		"flavorText": "“Safety is only mercy pretending to care.”",
		"tooltip": "If your total value is greater than or equal to the target value, nothing happens.",
		"weight": 310,
		"weightChange": -10
	},
	{
		"name": "Friendship",
		"desc": "You and your opponent receive two trump cards.",
		"flavorText": "“Two smiles. Two daggers hidden behind them.”",
		"tooltip": null,
		"weight": 110,
		"weightChange": 30
	},
	{
		"name": "Recall",
		"desc": "Destroy a random trump card in your inventory. Receive two trump cards.",
		"flavorText": "“Memory is cruel as it asks for loss before it offers wisdom.\"",
		"tooltip": "You'll receive two trump cards regardless if a trump card exist in your inventory or not.",
		"weight": 190,
		"weightChange": 15
	},
	{
		"name": "Black Clover",
		"desc": "Next round, trump cards are disabled and all cards' value are hidden from each other. If destroyed, increase this round's bet by 3.",
		"flavorText": "“Luck evens the odds by erasing them.”",
		"tooltip": "Also blocks ability usage such as external traits and charms.",
		"weight": 70,
		"weightChange": -5
	},
	{
		"name": "Shield",
		"desc": "Reduce this round's bet by 1.",
		"flavorText": "“We defend ourselves with the belief that something still matters.”",
		"tooltip": null,
		"weight": 240,
		"weightChange": 20
	},
	{
		"name": "Shield+",
		"desc": "Reduce this round's bet by 2.",
		"flavorText": "“Even fragile walls remember why they stand.”",
		"tooltip": null,
		"weight": 240,
		"weightChange": 10
	},
	{
		"name": "Borrowed Time",
		"desc": "Set this round's bet to 0. Next round's bet is increased by 1.",
		"flavorText": "\"To what end will the last gleam of hope lead?\"",
		"tooltip": "If this trump card is destroyed, the round’s bet reverts to its previous value before this trump card was played.",
		"weight": 50,
		"weightChange": 40
	},
	{
		"name": "Mimic",
		"desc": "Copy the effect of the last trump card played this round.",
		"flavorText": "“Desperation makes us mimic the miracles of others.”",
		"tooltip": "Playing this as the first trump card of the round or trying to copy another \"Mimic\" trump card will cause nothing to happen.",
		"weight": 40,
		"weightChange": 20
	},
	{
		"name": "Imaginary",
		"desc": "Draw two cards. Then immediately return one of them to the deck.",
		"flavorText": "“Possibility is a kindness that reality cannot keep.”",
		"tooltip": null,
		"weight": 220,
		"weightChange": -10
	},
	{
		"name": "Backdoor",
		"desc": "Choose even or odd. The next card you draw will be that value, if possible.",
		"flavorText": "“The world bends for those who gamble with certainties.”",
		"tooltip": "If the selected parity cards are not in the deck, the draw proceeds randomly as normal.",
		"weight": 310,
		"weightChange": -15
	},
	{
		"name": "Insolence",
		"desc": "Increase this round’s bet by 1.",
		"flavorText": "“The desperate mistake arrogance for courage.”",
		"tooltip": null,
		"weight": 200,
		"weightChange": 10
	},
	{
		"name": "Insolence+",
		"desc": "Increase this round’s bet by 2.",
		"flavorText": "“If defiance is a sin, then sin keeps us alive.”",
		"tooltip": null,
		"weight": 210,
		"weightChange": 10
	},
	{
		"name": "Momentum",
		"desc": "If you win this round, draw an extra trump card.",
		"flavorText": "“Victory is a hunger that teaches itself to grow.”",
		"tooltip": null,
		"weight": 280,
		"weightChange": -10
	},
	{
		"name": "Tide Turner",
		"desc": "If you lose this round, draw 2 extra trump cards.",
		"flavorText": "“The drowning grasp hardest at what remains.”",
		"tooltip": null,
		"weight": 270,
		"weightChange": -10
	},
	{
		"name": "Destroy",
		"desc": "Destroy the opponent's last placed trump card on the table.",
		"flavorText": "“All it takes to end a miracle is silence.”",
		"tooltip": null,
		"weight": 280,
		"weightChange": 35
	},
	{
		"name": "Defibrillate",
		"desc": "Lose 1 life immediately. Increase this round’s bet by 2.",
		"flavorText": "“Pain sharpens the wire that binds us.”",
		"tooltip": "This trump card cannot be played while you are at 1 life.",
		"weight": 80,
		"weightChange": 15
	},
	{
		"name": "Adrenaline",
		"desc": "Lose 1 life immediately, then draw two trump cards.",
		"flavorText": "“To force the heart awake is to remind it how to suffer.”",
		"tooltip": "This trump card cannot be played while you are at 1 life.",
		"weight": 100,
		"weightChange": 15
	},
	{
		"name": "Pessimism",
		"desc": "This trump card has no effect whatsoever, but playing it puts it and another copy of it on the table.",
		"flavorText": "“Doing nothing is still a choice. Just rarely the right one.”",
		"tooltip": "Useful for protecting another trump card you've placed on the table from a \"Destroy\" trump card.",
		"weight": 150,
		"weightChange": 10
	},
	{
		"name": "Volatility",
		"desc": "Next round's bet is increased by 1. If this trump card is destroyed, the effect is increased to 3.",
		"flavorText": "“Stability is just chaos waiting for its cue.”",
		"tooltip": null,
		"weight": 170,
		"weightChange": 35
	},
	{
		"name": "Tether",
		"desc": "While this trump card is on the table, neither player can stand until at least two cards have been drawn from the deck since this is played.",
		"flavorText": "“Some fates bind us together until suffering is shared.”",
		"tooltip": "Cards drawn from trump cards effect and charm abilities also count toward breaking the tether.",
		"weight": 210,
		"weightChange": -15
	},
	{
		"name": "Parity",
		"desc": "Opponent discards their highest value card back to the deck.",
		"flavorText": "“Balance demands that the fortunate bleed first.”",
		"tooltip": null,
		"weight": 300,
		"weightChange": 5
	},
	{
		"name": "Recursive",
		"desc": "When played, you may guess the value of the card you will gain next. If correct, you may take another turn.",
		"flavorText": "“To name fate is to tempt it into repeating itself.”",
		"tooltip": null,
		"weight": 220,
		"weightChange": 10
	},
	{
		"name": "Entomb",
		"desc": "Lock the deck until your next turn ends. Players cannot ask to draw a card while the deck is locked.",
		"flavorText": "“Some destinies are kinder when left unopened.”",
		"tooltip": "Cards may still be drawn through trump card effects and charm abilities.",
		"weight": 140,
		"weightChange": -10
	},
	{
		"name": "Hereditary",
		"desc": "Once played, select a trump card. That trump card will have a significantly higher chance of appearing until your next turn ends.",
		"flavorText": "“Inheritance is only the passing down of old burdens.”",
		"tooltip": "Temporarily quadruples the base weight chance of the selected trump card until your next turn ends.",
		"weight": 200,
		"weightChange": 5
	},
	{
		"name": "Condemn",
		"desc": "Select two trump cards. If the opponent has any of it in their inventory, it is completely destroyed.",
		"flavorText": "“A curse is merely hatred that learned to endure.”",
		"tooltip": null,
		"weight": 150,
		"weightChange": 10
	},
	{
		"name": "Reprieve",
		"desc": "Reduce this round's bet by 2. While this is on the table, every newly played trump card increases this round's bet by 1, capped at 4 total increases.",
		"flavorText": "“We call it a second chance, but it is merely an extension of the sentence.”",
		"tooltip": null,
		"weight": 150,
		"weightChange": 10
	},
	{
		"name": "Will to Survive",
		"desc": "Increase your life by 1, then immediately draw a card from the deck.",
		"flavorText": "“Like a stranded whale, there is no struggle, just despair.”",
		"tooltip": null,
		"weight": 200,
		"weightChange": -15
	},
	{
		"name": "Spectator Effect",
		"desc": "Select one of your placed trump cards on the table to protect, making it nullify the first negative trump card effects that targets it for this round.",
		"flavorText": "“A room full of witnesses, and not a single hand raised to stop it.”",
		"tooltip": null,
		"weight": 150,
		"weightChange": -15
	},
	{
		"name": "Calamity",
		"desc": "Receive four trump cards, then immediately draw an OVERKILL card into your hand.",
		"flavorText": "“To flood a dry well is only to invite a different kind of drowning.”",
		"tooltip": "A round is lost regardless of your value when an OVERKILL card is in your hand when it ends.",
		"weight": 220,
		"weightChange": -30
	},
	{
		"name": "Audience Effect",
		"desc": "While active on the table, draw an extra trump card at the start of your every turn. This card is not cleaned up when the round ends.",
		"flavorText": "“Do not disappoint an audience that came only to watch an execution.”",
		"tooltip": null,
		"weight": 270,
		"weightChange": -15
	},
	{
		"name": "Curiosity",
		"desc": "Draw the highest value card available in the deck.",
		"flavorText": "“We peer into the dark simply to prove we can survive what looks back.”",
		"tooltip": "If your total value is greater than or equal to the target value, nothing happens.",
		"weight": 200,
		"weightChange": 15
	},
	{
		"name": "Hawthorne Effect",
		"desc": "Increase this round's bet by 1 for each active trump card the opponent has placed on the table.",
		"flavorText": "“The subject strictly alters their parameters when they realize the lens is focused on them.”",
		"tooltip": null,
		"weight": 220,
		"weightChange": -15
	},
	{
		"name": "Frenzy",
		"desc": "At the end of this round, if on the table, this card destroys two random trump cards currently on the board.",
		"flavorText": "“A growing power, strong enough to destroy everything.”",
		"tooltip": null,
		"weight": 190,
		"weightChange": 20
	},
	{
		"name": "Targeted Destroy",
		"desc": "Select one of the opponent's placed trump card on the table to destroy.",
		"flavorText": "“A growing power, strong enough to destroy everything.”",
		"tooltip": null,
		"weight": 350,
		"weightChange": -35
	},
	{
		"name": "Flywheel Effect",
		"desc": "If the current round's bet is equal or higher than your remaining lives, nullify the bet completely when the round is lost.",
		"flavorText": "“A growing power, strong enough to destroy everything.”",
		"tooltip": null,
		"weight": 100,
		"weightChange": 15
	},
		{
		"name": "Reincarnation",
		"desc": "Destroy the opponent's last placed trump card on the table. Receive 1 random trump card.",
		"flavorText": "“A growing power, strong enough to destroy everything.”",
		"tooltip": null,
		"weight": 200,
		"weightChange": 15
	}
]

var DIFFICULTY_PROFILES = {
	"EASY": {
		"safety_threshold": 0.25,        # Reckless gambler, hits blindly
		"desperation_trigger": 0.50,     # Panics and overdraws easily
		"peek_chance": 0.0,               # Never knows your hidden card
	},
	"NORMAL": {
		"safety_threshold": 0.35,        # Balanced, average human play style
		"desperation_trigger": 0.60,     # Standard caution parameters
		"peek_chance": 0.0,               # Never knows your hidden card
	},
	"HARD": {
		"safety_threshold": 0.40,        # The highly patient baseline we discovered
		"desperation_trigger": 0.70,     # Lets the player bust themselves
		"peek_chance": 0.20,              # 20% chance to possess perfect information
	},
	"INSANE": {
		"safety_threshold": 0.45,        # Ultra-conservative, tight defense
		"desperation_trigger": 0.80,     # Incredibly patient
		"peek_chance": 0.40,              # 40% chance to completely read your hand
	}
}

var TAGS = [
	{
		"name": "Perishable",
		"description": "This trump card is automatically destroyed if it remains in your hand for more than 2 rounds."
	},
	{
		"name": "Bleed",
		"description": "When this trump card is played, it will feed on a random trump card in your inventory, destroying it."
	},
	{
		"name": "Imaginary",
		"description": "When this trump card is played, creatre a non-imaginary copy of it in your inventory."
	},
	{
		"name": "Fragile",
		"description": "25% chance this trump card has no effect when played."
	},
	{
		"name": "Volatile",
		"description": "This trump card is destroyed if the current round's bet increases."
	},
	{
		"name": "Joker",
		"description": "15% chance this trump card transforms into a random trump card once played."
	}
]
