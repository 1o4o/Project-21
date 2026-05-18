extends Node

var targetValue = 21
var playerValue = 0
var enemyValue = 0
var playerLives = 7
var enemyLives = 7
var roundBet = 1
var baseRoundBet = 1
var phase = GLOBAL.state.INTRO

var showdownTrigger = 0

var toProcess = null

func clearAllCards():
	for i in GLOBAL.playerDeck:
		i.instance.destroy()
	for i in GLOBAL.enemyDeck:
		i.instance.destroy()

func resetDeck():
	GLOBAL.deck.clear()
	for i in range(11):
		GLOBAL.deck.append(i + 1)
		
func initializeRound():
	var firstDraw = 2
	resetDeck()
	clearAllCards()
	GLOBAL.updateCounter()
	phase = GLOBAL.state.NEWROUND
	
	await await GLOBAL.wait(0.5)
	for i in range(firstDraw):
		if i == 0:
			GLOBAL.drawCard(GLOBAL.entity.PLAYER, true, null)
		else:
			GLOBAL.drawCard(GLOBAL.entity.PLAYER, false, null)
		await GLOBAL.wait(0.6)
	
	for i in range(firstDraw):
		if i == 0:
			GLOBAL.drawCard(GLOBAL.entity.ENEMY, true, null)
		else:
			GLOBAL.drawCard(GLOBAL.entity.ENEMY, false, null)
		await GLOBAL.wait(0.6)
	
	phase = GLOBAL.state.PLAYERTURN

func playerDraw():
	phase = GLOBAL.state.PROCESS
	GLOBAL.subtitle(GLOBAL.dialogue["playerDraw"].pick_random())
	showdownTrigger = 0
	
	await GLOBAL.wait(1)
	GLOBAL.drawCard(GLOBAL.entity.PLAYER, false, null)
	await GLOBAL.wait(2.5)
	passTurn(GLOBAL.entity.ENEMY)
	
func enemyDraw():
	phase = GLOBAL.state.PROCESS
	GLOBAL.subtitle(GLOBAL.dialogue["playerDraw"].pick_random())
	showdownTrigger = 0
	
	await GLOBAL.wait(1)
	GLOBAL.drawCard(GLOBAL.entity.ENEMY, false, null)
	await GLOBAL.wait(2.5)
	passTurn(GLOBAL.entity.PLAYER)

func playerStand():
	phase = GLOBAL.state.PROCESS
	GLOBAL.subtitle(GLOBAL.dialogue["stand"].pick_random())
	showdownTrigger += 1
	
	await GLOBAL.wait(2.5)
	if showdownTrigger >= 2:
		showdown()
	else:
		passTurn(GLOBAL.entity.ENEMY)

func enemyStand():
	phase = GLOBAL.state.PROCESS
	GLOBAL.subtitle(GLOBAL.dialogue["stand"].pick_random())
	showdownTrigger += 1
	
	await GLOBAL.wait(2.5)
	if showdownTrigger >= 2:
		showdown()
	else:
		passTurn(GLOBAL.entity.PLAYER)

func revealAllCards():
	for i in GLOBAL.playerDeck:
		if i.hidden:
			i.instance.revealCard()
	for i in GLOBAL.enemyDeck:
		if i.hidden:
			i.instance.revealCard()

func passTurn(entity):
	if entity == GLOBAL.entity.PLAYER:
		phase = GLOBAL.state.PLAYERTURN
		
	if entity == GLOBAL.entity.ENEMY:
		phase = GLOBAL.state.ENEMYTURN
		AI.processAI()
	return

func showdown():
	phase = GLOBAL.state.SHOWDOWN
	showdownTrigger = 0
	GLOBAL.subtitle(GLOBAL.dialogue["showdown"].pick_random())
	await GLOBAL.wait(2)
	revealAllCards()
	await GLOBAL.wait(3)
	processResult()

func processResult():
	baseRoundBet += 1
	initializeRound()
