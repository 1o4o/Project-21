extends Area3D

var id = 1
var data: Dictionary
var thisOwner = GLOBAL.entity.PLAYER

func _ready():
	await get_tree().process_frame
	data = TRUMP.random()
	id = TRUMP.data.find(data) + 1
	$sides/frontside.texture.region = GLOBAL.getTrumpTexture(id)
	
func getData():
	return data
