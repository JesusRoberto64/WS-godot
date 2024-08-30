extends Node

signal package_recived(packet)
signal closing(message)
signal close(message)

func update_socket(ws: WebSocketPeer):
	ws.poll()
	var state = ws.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while ws.get_available_packet_count():
			var packet = ws.get_packet().get_string_from_utf8()
			package_recived.emit(packet)
	elif state == WebSocketPeer.STATE_CLOSING:
		closing.emit("Closing time...")
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = ws.get_close_code()
		var reason = ws.get_close_reason()
		close.emit("WebSocket closed with code: %s, reason %s. Clean: %s" % [code, reason, code != -1])
