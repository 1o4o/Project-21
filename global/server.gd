extends Node

var serverPort: int = 8000
var serverIP: String = "localhost"
var multiplayerPeer = ENetMultiplayerPeer.new()


var rooms = {}


func _ready():
	if "--server" not in OS.get_cmdline_args():
		return

	var error = multiplayerPeer.create_server(serverPort)
	if error != OK:
		print("Failed to start server: ", error)
		return

	multiplayer.multiplayer_peer = multiplayerPeer
	print("Server started on port ", serverPort)
	multiplayer.peer_connected.connect(_on_peer_connected)

func _on_peer_connected(id: int) -> void:
	print("Player connected with ID: ", id)

# =========================
# CLIENT → SERVER
# =========================







# SERVER ---> CLIENT
