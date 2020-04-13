extends Node

var playerHasTheKey: bool setget _has_the_key, _get_key_status

func _has_the_key(value: bool) -> void:
	playerHasTheKey = value

func _get_key_status() -> bool:
	return playerHasTheKey
