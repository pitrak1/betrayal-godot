extends Control

func _ready():
	$PlayerNameLabel.visible = false
	$HostIndicator.visible = false

func set_player_name(name):
	$PlayerNameLabel.text = name
	$PlayerNameLabel.visible = true
	
func clear_player_name():
	$PlayerNameLabel.text = ""
	$PlayerNameLabel.visible = false
	
func set_host_indicator(host):
	$HostIndicator.visible = host
