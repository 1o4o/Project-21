extends Control

@onready var tooltipPanel = $"../hoverInfo"
@onready var trumpButton = $trumpCard
@onready var abilitiesButton = $abilities
@onready var overviewButton = $overview
@onready var infoButton = $"../trumpcard/Panel/name/infoHover"

func _ready():
	# Connect Trump Card Button (Index 0)
	trumpButton.mouse_entered.connect(func(): tooltipPanel.showTooltip(0))
	trumpButton.mouse_exited.connect(tooltipPanel.hideTooltip)
	
	infoButton.mouse_entered.connect(func(): tooltipPanel.showTooltip(null))
	infoButton.mouse_exited.connect(tooltipPanel.hideTooltip)
	
	# Connect Abilities Button (Index 1)
	abilitiesButton.mouse_entered.connect(func(): tooltipPanel.showTooltip(1))
	abilitiesButton.mouse_exited.connect(tooltipPanel.hideTooltip)
	
	# Connect Overview Button (Index 2)
	overviewButton.mouse_entered.connect(func(): tooltipPanel.showTooltip(2))
	overviewButton.mouse_exited.connect(tooltipPanel.hideTooltip)
