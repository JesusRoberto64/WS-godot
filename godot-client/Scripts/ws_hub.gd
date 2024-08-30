extends Node2D

@onready var webSocketClinet = $websocketClient
@onready var login = $Login

func _ready() -> void:
	webSocketClinet.is_connected.connect(login.on_connect)
	
	login.try_connect.connect(webSocketClinet.connect_to_server)
