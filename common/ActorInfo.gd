extends Control

func _ready():
	$MightAttribute.set_attribute_name("Might")
	$SpeedAttribute.set_attribute_name("Speed")
	$KnowledgeAttribute.set_attribute_name("Knowledge")
	$SanityAttribute.set_attribute_name("Sanity")
	
func set_character_from_entry(entry):
	$NameLabel.text = entry["display_name"]
	$ActorSprite.texture = load("res://assets/" + entry["portrait_asset"])
	$MightAttribute.set_attribute_values(entry["might"])
	$MightAttribute.set_attribute_index(entry["might_index"])
	$SpeedAttribute.set_attribute_values(entry["speed"])
	$SpeedAttribute.set_attribute_index(entry["speed_index"])
	$KnowledgeAttribute.set_attribute_values(entry["knowledge"])
	$KnowledgeAttribute.set_attribute_index(entry["knowledge_index"])
	$SanityAttribute.set_attribute_values(entry["sanity"])
	$SanityAttribute.set_attribute_index(entry["sanity_index"])
	
func set_status_label(status):
	$StatusLabel.text = status
	
func get_status_label():
	return $StatusLabel.text
	
func get_display_name():
	return $NameLabel.text
