extends Node
class_name  WebSocketClient

@export var nickName :String= "PalyerNick"
@export var room :String= ""
var Id :String= ""

enum STATE {CONNECTED, HOLD}
var state = STATE.HOLD
signal is_connected(bool)

var socket: WebSocketPeer = null

func resive_package(pack: String) -> void:
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
	#All this logic es when receiving package from WSserver
	match action:
		"connect":
			state = STATE.CONNECTED
			socket.put_packet(JSON.stringify({"action": "connect","param": nickName}).to_utf8_buffer())
		"message":
			print(param)
		"sendMessageToPlayer":
			var playerId = "00000000-0000-0000-0000-000001E240"
			var message  = "Hola"
			var send = playerId + "*" + message
			socket.put_packet(JSON.stringify({"action": "sendMessageToPlayer", "param": send }).to_utf8_buffer())
		"getRooms":
			for i in param:
				print(i)
		"getNicks":
			for i in param:
				print(i)

func closed_socket(message: String)-> void:
	state = STATE.HOLD
	#print(message)

func connected_socket(connected: bool)-> void:
	#print("websocketclass -- is connectd: ", connected)
	if !connected:
		socket.close()
	is_connected.emit(connected)
