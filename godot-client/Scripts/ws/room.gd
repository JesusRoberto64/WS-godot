extends Node

signal message_received(message)
signal whisper_received(remitent, message)

func send_message_to_all(message: String)-> void:
	message_received.emit(message)

func send_whisper_to_player(player_id: String, message: String)-> void:
	whisper_received.emit(player_id, message)
