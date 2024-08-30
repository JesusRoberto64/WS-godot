extends WebSocketClient

#The objects that contains all the logic in a modular fashion
#it can be seted as a normal node but it's convenient to 
#instanciate this way beacuse it's easier to visualize in code
var Log = preload("res://Scripts/ws/log.gd").new()
var Lobby = preload("res://Scripts/ws/lobby.gd").new()
var Update = preload("res://Scripts/ws/update.gd").new()

func _ready() -> void:
	#A hub for all the logic between the scripts
	add_child(Log) #all login logic to start poll data
	add_child(Update)# update socket logic
	add_child(Lobby)
	
	Log.package_recived.connect(resive_package)
	Log.ws_connected.connect(connected_socket)
	
	Update.package_recived.connect(resive_package)
	Update.close.connect(closed_socket)
	

func _process(_delta: float) -> void:
	if state == STATE.CONNECTED:
		#Getting packages form server on real time
		Update.update_socket(socket) 

func connect_to_server(_nickname: String)-> void:
	nickName = _nickname
	socket = WebSocketPeer.new()
	Log.connect_to_server("ws://localhost:3000", socket)
