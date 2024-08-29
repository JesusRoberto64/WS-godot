extends Node

var socket = WebSocketPeer.new()
@export var nickName := "PalyerNick"
@export var room := ""
var Id := ""
signal Ws_connected

var tween: Tween

func _ready() -> void:
	server_connect()

func server_connect() -> void:
	#Guradia para padre
	var error = socket.connect_to_url("ws://localhost:3000")
	
	#Await server answer 
	tween = get_tree().create_tween().set_loops(50)
	tween.tween_callback(update_socket).set_delay(0.01)
	#Kill process at 10 sec
	
	
	#Throw error.
	
	

func update_socket():
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			tween.kill()
			var packet = socket.get_packet().get_string_from_utf8()
			resive_Package(packet)
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		print("Closed")
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %s, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
	elif state == WebSocketPeer.STATE_CONNECTING:
		print(randi(), " coneccting")

func resive_Package(pack: String) -> void:
	var json = JSON.new()
	var error = json.parse(pack)
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", pack, " at line ", json.get_error_line())
		return
	
	var data = json.data
	if data.has("action") and data.has("param"):
		action_JSON(data["action"], data["param"])
	else:
		print("JSON ERROR FORMAT")

func action_JSON(action, param):
	#All this logic es when resiving package from WSserver
	print(action, param)
	match action:
		"message":
			print(param)
		"sendMessageToPlayer":
			var playerId = "00000000-0000-0000-0000-000001E240"
			var message  = "Hola"
			var send = playerId + "*" + message
			socket.put_packet(JSON.stringify({"action": "sendMessageToPlayer", "param": send }).to_utf8_buffer())
			pass
		"connect":
			print("Connected...")
			socket.put_packet(JSON.stringify({"action": "connect","param": nickName}).to_utf8_buffer())
		"getRooms":
			for i in param:
				print(i)
				#get_parent().add_Room(i)
		"getNicks":
			for i in param:
				print(i)
				#get_parent().add_Player_Tag(i)
			pass

func send_Text_All():
	print("Sended Text")
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		#socket.send_text("Desde godot")
		socket.send(JSON.stringify({"action": "message", "param": "desde Godot 1"}).to_utf8_buffer(),WebSocketPeer.WRITE_MODE_TEXT)
		pass
	pass

func send_Text_Player():
	
	pass

func join_Room():
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		socket.send(JSON.stringify({"action": "joinRoom", "param": room}).to_utf8_buffer(),WebSocketPeer.WRITE_MODE_TEXT)
		pass
	pass
