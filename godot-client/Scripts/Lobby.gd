extends Node2D

var webSocket = preload("res://Scenes/websocket_client.tscn") 
var Player = null
@onready var enterBtn = $enterlobby
@onready var createRoomBtn = $createRoom
@onready var RoomsList = $PanelContainer/HBoxContainer/ScrollContainer/Rooms
@onready var PlayersList = $PanelContainer/HBoxContainer/ScrollContainer2/Players

#Connections 
@onready var sendBtn = $PanelContainer/HBoxContainer/ColorRect/Send

var nick := ""
var isEnteringRoom =  false

func _on_enterlobby_pressed():
	if enterBtn.get_child(0).text.is_empty():
		return
	nick = "@" + enterBtn.get_child(0).text
	enterBtn.disabled = true
	enterBtn.get_child(0).editable = false
	create_Player_Peer()

func _on_create_room_pressed():
	if createRoomBtn.get_child(0).text.is_empty():
		return
	var roomName = createRoomBtn.get_child(0).text
	var btn = Button.new()
	btn.text = roomName
	RoomsList.add_child(btn)
	createRoomBtn.disabled = true
	createRoomBtn.get_child(0).editable = false
	pass # Replace with function body.

func add_Other_Player_Tag(_nick: String):
	var nickName = "@" + _nick
	var tag = Label.new()
	tag.text = nickName
	PlayersList.add_child(tag)
	pass

func add_Room(_room: String):
	var roomName = _room
	var btn = Button.new()
	btn.text = roomName
	RoomsList.add_child(btn)
	btn.connect("pressed",Callable(self,"on_Room_Btn_Pressed"))
	pass

func on_Room_Btn_Pressed():
	if isEnteringRoom: return
	#isEnteringRoom = false
	for i in RoomsList.get_children():
		if i is Button and i.button_pressed:
			Player.room = i.text
			print("Triying join ", i.text, " room" )
			Player.join_Room()
			break
	pass

func create_Player_Peer():
	Player = webSocket.instantiate()
	Player.nickName = nick
	add_child(Player)
	#connect Inputs
	sendBtn.show()
	sendBtn.connect("pressed", Callable(Player, "send_Text"))
	pass

func add_Player_Tag(_nick):
	var tag = Label.new()
	tag.text = _nick
	PlayersList.add_child(tag)
