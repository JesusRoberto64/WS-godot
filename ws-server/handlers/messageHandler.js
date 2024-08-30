import { handleCreateRoom, handleJoinRoom, handleSendMessageToPlayer } from './roomHandler.js'

export function handleMessage(message, ws, id, Players, Rooms){
    let data = JSON.parse(message);
    let { action, param } = data;
    
    switch(action){
        case "connect":
            handleConnect(param, id, Players, ws);
            break;
        case "sendMessageToPlayer":
            handleSendMessageToPlayer(param, Players, ws);
            break;
        case "createRoom":
            handleCreateRoom(param, Rooms, id);
            break;
        case "joinRoom":
            handleJoinRoom(param, Rooms, id, ws);
            break;
        default:
            console.log(`Action ${action} is not recognized`);
            break;
    }
}

function handleConnect(param, id, Players, ws){
    const newPlayer = Players.get(id);
    newPlayer.nick = param;

    Players.set(id, newPlayer); //Update Map
    
    console.log(`${newPlayer.nick} connected, ID: ${id}`);
    console.log(`Total players ${Players.size}`)

    //let roomNames = Array.from(Rooms.values()).map(room => room._name);
   // ws.send(JSON.stringify({ "action": "getRooms", "param": roomNames }));
}