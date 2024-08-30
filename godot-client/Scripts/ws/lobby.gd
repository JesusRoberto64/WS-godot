extends Node
#Dummy script 
signal room_created(room_name: String)
signal room_list_updated(rooms: Array)
signal room_search_complete(results)

func create_room(room_name: String)-> void:
	room_created.emit(room_name)

func update_room_list(rooms: Array)-> void:
	room_list_updated.emit(rooms)

func search_room(query: String)-> void:
	#send query
	room_search_complete.emit(query)
