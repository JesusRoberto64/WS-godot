extends Node

signal player_list_updated(players)
signal whisper_to_player(player_id, message)

func update_player_list(players: Array)-> void:
	player_list_updated.emit(players)

func whisper_player(playe_id: String, message: String)-> void:
	whisper_to_player.emit(playe_id, message)
