extends WebSocketClient

var Log = preload("res://Scripts/ws/log.gd").new()
var Lobby = preload("res://Scripts/ws/lobby.gd").new()
var Update = preload("res://Scripts/ws/update.gd").new()

func _ready() -> void:
	add_child(Log)
	add_child(Lobby)
	add_child(Update)
	
	Log.package_recived.connect(resive_package)
	Log.ws_connected.connect(connected_socket)
	
	Update.package_recived.connect(resive_package)
	Update.close.connect(closed_socket)
	

func _process(_delta: float) -> void:
	if state == STATE.CONNECTED:
		Update.update_socket(socket)

func connect_to_server(_nickname: String)-> void:
	nickName = _nickname
	socket = WebSocketPeer.new()
	Log.connect_to_server("ws://localhost:3000", socket)
