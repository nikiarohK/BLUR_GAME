extends Control
var peer
@export var Address = "127.0.0.1"
@export var port = 8910

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		HostGame()
	
	
#everyone
func peer_connected(id):
	print("Player Connected " + str(id))
	
	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
	
	
#only client
func connected_to_server():
	print("Connected to serverer")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
	
func connection_failed():
	print("Connection Failed")


@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : name,
			"id" : id
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
@rpc("any_peer","call_local")	
func StartGame():
	var scene = load("res://scenes/test scene/test2.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func HostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	
	
func _on_host_pressed() -> void:
	HostGame()
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	
func _on_join_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass
	
	
func _on_start_game_pressed() -> void:
	StartGame.rpc()
	pass # Replace with function body.
