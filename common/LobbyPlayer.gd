extends Control

func _ready():
	$PlayerNameLabel.visible = false
	$HostIndicator.visible = false

func set_player_name(name):
	$PlayerNameLabel.text = name
	$PlayerNameLabel.visible = true
	
func get_player_name():
	return $PlayerNameLabel.text
	
func clear_player_name():
	$PlayerNameLabel.text = ""
	$PlayerNameLabel.visible = false
	
func set_host_indicator(host):
	$HostIndicator.visible = host
	
func get_host_indicator():
	return $HostIndicator.visible
