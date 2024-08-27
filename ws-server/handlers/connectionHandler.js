import { v4 as uuidv4} from "uuid";
import { handleMessage } from './messageHandler.js';

export function handleConnection(ws, Players, Rooms){
    const id = uuidv4();
    Players.set(id, {nick: "", room: "Lobby", socket: ws});
    
    ws.send(JSON.stringify( {"action": "connect", "param": `Player ${id} connected` }));
    
    ws.on("message", (message) => handleMessage(message, ws, id, Players, Rooms));
    
    ws.on("close", ()=> handleDisconnection(id, Players));
    ws.on("error", (error) => handleError(error, ws));
    
}

function handleDisconnection(id, Players){
    const disconnectedPlayer = Players.get(id);

    if (disconnectedPlayer){
        Players.delete(id);
        console.log(`Player ${disconnectedPlayer.nick} disconnected`);
    } 
    console.log("Total players", Players.size);
}

function handleError(error, ws){
    console.error(`Error connection: `, error.message);
    ws.close();
}
