extends Node
#The idea of this code is to expand as a form like, asking player's password and nickName
# returning error in auth query, but now it just trying to reach the server.
var ws: WebSocketPeer = null
var tween: Tween

signal ws_connected(is_connected: bool)
signal package_recived
var heart_beat :int= 50 # times trying reaching the serever

func connect_to_server(url: String, _ws: WebSocketPeer) -> void:
	ws = _ws #Consturuct like
	print("log -- Try to connect...")
	var error = ws.connect_to_url(url)
	if error != OK:
		ws_connected.emit(false)
		return
	start_polling()

func start_polling():
	#This is a loop that trying to reach server and it will kill the loop at the moment
	#it reach the server. Used tween insted of await due to getting less code.
	#It is use in this way to make it _process() routine independent and parallel 
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
	
	#server don't reached
	if heart_beat <= 0:
		heart_beat = 50
		ws_connected.emit(false)

func handle_open_state():
	ws_connected.emit(true)
	while ws.get_available_packet_count():
		var packet = ws.get_packet().get_string_from_utf8()
		package_recived.emit(packet)
