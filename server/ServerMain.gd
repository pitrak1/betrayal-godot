extends Node

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8910, 6)
	get_tree().network_peer = peer
	
