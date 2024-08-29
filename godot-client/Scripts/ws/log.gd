extends Node

var ws: WebSocketPeer = null
signal Ws_Connected(is_connected: bool)

func connect_to_server(url: String, _ws: WebSocketPeer) -> void:
	print("Connecting...")
	ws = _ws #Consturuct like
	var error = ws.connect_to_url(url)
	if error != OK:
		Ws_Connected.emit(false)
		return
	
	Ws_Connected.emit(true)
	start_polling()

func start_polling():
	var tween = get_tree().create_tween().set_loops(50)
	tween.tween_callback(update_socket).set_delay(0.01)
	

func update_socket():
	ws.poll()
	var state = ws.get_ready_state()
	
	
	
	pass
