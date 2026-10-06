extends Control

var multiplayerPeer = ENetMultiplayerPeer.new()
var username: String

func _ready() -> void:
	if "--server" in OS.get_cmdline_args():
		#$titleScreen/Button.text = "SERVER"
		#$titleScreen/Button.disabled = true
		$titleScreen/username.text = "SERVER"
		#return

func _on_connect_pressed() -> void:
	username = $titleScreen/username.text
	connect_to_server()

func connect_to_server() -> void:

	var error = multiplayerPeer.create_client(SERVER.serverIP, SERVER.serverPort)
	print("CLIENT CONNECTING... Name: " + username)
	if error != OK:
		print("Failed to connect: ", error)
		return

	multiplayer.multiplayer_peer = multiplayerPeer
	$titleScreen.visible = false
	$lobby.visible = true
