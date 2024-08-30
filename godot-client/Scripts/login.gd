extends Control

@onready var lineEdit = $Panel/LineEdit
@onready var joinBtn = $Panel/join
signal try_connect(nickName)

func _on_join_pressed()-> void:
	if lineEdit.text == "":
		lineEdit.placeholder_text = "Set a nickname please"
		return
	joinBtn.disabled = true
	lineEdit.editable = false
	print("Login -- try to connect...")
	try_connect.emit(lineEdit.text)

func on_connect(connected: bool)-> void:
	if !connected:
		joinBtn.disabled = false
		lineEdit.editable = true
	else:
		hide()
