export function handleCreateRoom(param, Rooms, id){
   const isRoomExists = Rooms.find(room => room._name === param)
   if (!isRoomExists){
        Rooms.set(param, {_name: param, host: id, players: [id]});
        console.log(`Room ${param} was created`);
   } else {
        console.log(`Room ${param} already exists`);
   }
};

export function handleJoinRoom(param, Rooms, id, Players, ws){
    const currPlayer = Players.get(id);
    const room = Rooms.find(room => room._name === param);

    if (room){
        if (room.players.includes(currPlayer.id) || currPlayer.room !== "lobby"){
            console.log("Already in room or has room");
            return;
        }

        room.players.push(currPlayer.id);
        console.log(`Player ${currPlayer.nick} joined room ${param}`);

        let otherPlayersInRoom = room.players.filter(id => id !== currPlayer.id);
        ws.send(JSON.stringify({ "action": "getIds", "param": otherPlayersInRoom }));
    } else {
        console.log(`No room named ${param} found`);
        ws.send(JSON.stringify({ "action": "message", "param": "Room not found" }));
    }
}

export function handleSendMessageToPlayer(param, Players, ws){
    const [playerId, message] = param.split("*");
    const targetPlayer = Players.get(playerId);
    if (targetPlayer){
        targetPlayer.socket.send(JSON.stringify({ "action": "message", "param": message }))
    } else {
        ws.send(JSON.stringify({ "action": "message", "param": "Player Not Found" }));
    }
}