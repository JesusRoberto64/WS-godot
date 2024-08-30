extends Node

signal connection_error(message)
signal connection_status(status)

func display_error(message: String)-> void:
	connection_error.emit(message)

func update_connection_status(status: String)-> void:
	connection_status.emit(status)
