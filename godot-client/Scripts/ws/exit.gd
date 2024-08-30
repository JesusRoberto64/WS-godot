extends Node

signal exit_room
signal disconnected

func exit_current_room()-> void:
	exit_room.emit()

func disconnect_from_server()-> void:
	disconnected.emit()
