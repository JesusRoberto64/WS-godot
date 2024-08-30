extends Node

var ws: WebSocketPeer = null
var tween: Tween

signal ws_connected(is_connected: bool)
signal package_recived
var heart_beat :int= 50

func connect_to_server(url: String, _ws: WebSocketPeer) -> void:
	ws = _ws #Consturuct like
	print("log -- Try to connect...")
	var error = ws.connect_to_url(url)
	if error != OK:
		ws_connected.emit(false)
		return
	start_polling()

func start_polling():
	tween = get_tree().create_tween().set_loops(heart_beat)
	tween.tween_callback(update_socket).set_delay(0.01)

func update_socket():
	ws.poll()
	var state = ws.get_ready_state()
	match state:
		WebSocketPeer.STATE_CONNECTING:
			print(randi(), "-- connecting heart beat")
			heart_beat -=1
		WebSocketPeer.STATE_OPEN:
			tween.kill()
			handle_open_state()
	
	if heart_beat <= 0:
		heart_beat = 50
		ws_connected.emit(false)

func handle_open_state():
	ws_connected.emit(true)
	while ws.get_available_packet_count():
		var packet = ws.get_packet().get_string_from_utf8()
		package_recived.emit(packet)
