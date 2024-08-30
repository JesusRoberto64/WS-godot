extends Node2D
#This script is a HUB for all signal its to recomended to dont use lots of logic here.
#The control objects are the UI that then connects to the Web Socket Client, and then
#the cleint try to rech a server.

@onready var webSocketClinet = $websocketClient
@onready var login = $Login

func _ready() -> void:
	#the data is returning is the string with the nick name
	#but it can be expand to an auth system in the future as 
	# web form
	login.try_connect.connect(webSocketClinet.connect_to_server)
	
	#a signal that notifys if the connection is succes to the server
	# it passes a bool value
	webSocketClinet.is_connected.connect(login.on_connect)
