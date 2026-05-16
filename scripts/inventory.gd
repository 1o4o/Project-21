extends Control

var selected = {}
var debug = -1
var tooltipText = ""

func update(data):
	$trumpcard/Panel/name.text = data.name
	$trumpcard/Panel/name/description.text = data.desc
	$trumpcard/Panel/name/flavorText.text = "[i]" + data.flavorText
	
	$trumpcard/Panel/infoText.visible = false
	$trumpcard/Panel/name.visible = true
	
func open():
	$trumpcard/Panel/name.visible = false
	initialiseTrumpcards()
	openTab(GLOBAL.tab.TRUMPCARD)
	visible = true
	modulate.a = 0
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 1, 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property($topButtons, "position:y", 19, 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property($trumpcard/Panel, "position:x", 740, 0.3).set_trans(Tween.TRANS_SINE)

func close():
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property($topButtons, "position:y", -74, 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property($trumpcard/Panel, "position:x", 900, 0.3).set_trans(Tween.TRANS_SINE)
	await tween.finished
	if modulate.a > 0:
		return
	visible = false



func _on_trump_card_pressed() -> void:
	openTab(GLOBAL.tab.TRUMPCARD)

func _on_abilities_pressed() -> void:
	openTab(GLOBAL.tab.ABILITIES)

func _on_overview_pressed() -> void:
	openTab(GLOBAL.tab.OVERVIEW)

func openTab(tab):
	var tabButtons = {
		GLOBAL.tab.TRUMPCARD: $topButtons/trumpCard,
		GLOBAL.tab.ABILITIES: $topButtons/abilities,
		GLOBAL.tab.OVERVIEW: $topButtons/overview
	}
	
	var tabMenus = {
		GLOBAL.tab.TRUMPCARD: $trumpcard,
		GLOBAL.tab.ABILITIES: $abilities,
		GLOBAL.tab.OVERVIEW: $overview
	}
	
	for t in tabButtons:
		tabButtons[t].disabled = (t == tab)
		if tabMenus.has(t):
			tabMenus[t].visible = (t == tab)
			
	GLOBAL.inventoryTab = tab
	
const TRUMP_CARD_SCENE = preload("res://scenes/trumpcard_ui.tscn")

func initialiseTrumpcards():
	# 1. Clear the old UI instances
	var grid = $trumpcard/Panel/BoxContainer/MarginContainer/GridContainer
	for child in grid.get_children():
		child.queue_free()
		
	# 2. Handle empty inventory states
	var has_cards = not GLOBAL.playerInventory.is_empty()
	$trumpcard/Panel/noTrumpCard.visible = not has_cards
	$trumpcard/Panel/infoText.visible = has_cards
	
	if not has_cards:
		return
		
	# 3. Group and count identical cards
	var card_counts = {}
	
	for i in range(GLOBAL.playerInventory.size()):
		var card_type = GLOBAL.playerInventory[i]
		if not card_counts.has(card_type):
			card_counts[card_type] = {
				"count": 1, 
				"first_index": TRUMP.data.find(GLOBAL.playerInventory[i]), 
				"data": GLOBAL.playerInventory[i]
			}
		else:
			card_counts[card_type]["count"] += 1

	# 4. Convert to an array so we can sort it
	var sorted_stacks = []
	for card_type in card_counts:
		sorted_stacks.append(card_counts[card_type])
		
	# 5. Custom Sorting Lambda
	# Sorts descending by count. If counts are equal, sorts ascending by first_index.
	sorted_stacks.sort_custom(func(a, b):
		if a["count"] != b["count"]:
			return a["count"] > b["count"] # Higher count comes first
		return a["first_index"] < b["first_index"] # Lower index (earlier discovered) comes first
	)

	# 6. Spawn uniquely stacked instances into the grid in sorted order
	for data in sorted_stacks:
		var clone = TRUMP_CARD_SCENE.instantiate()
		
		clone.id = data["first_index"]
		clone.data = data["data"]
		clone.count = data["count"]
		
		grid.add_child(clone)
		
		# Set up the visual stack count indicator
		var count_label = clone.get_node_or_null("count")
		if count_label:
			if data["count"] > 1:
				count_label.visible = true
				count_label.text = str(data["count"]) + "x"
			else:
				count_label.visible = false
