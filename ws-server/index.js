import { WebSocketServer } from "ws";
import { v4 as uuidv4} from "uuid";
import rooms from "./roomsDb.js";
import players from "./playersDb.js";

const wss = new WebSocketServer({port: 3000});
console.log("Listening in ws://localhost:3000")
//Set the players map
let Players = players
//Set rooms map WIP from server
let Rooms = rooms

wss.on("connection", ws =>{
    const id = uuidv4();
    Players.set(id, {nick: "", room: "Lobby", socket: ws});
    console.log("Total de Players", Players.size);
    //Notify connection
    ws.send(JSON.stringify({"action": "connect", "param": `PlayerID ${id} conectado!`}));
    
    ws.on("message", message =>{
       let data = JSON.parse(message);
       let {action, param} = data;
       
       if (action === "connect") { //Connect
           const newPlayer = Players.get(id);
           newPlayer.nick = param;
           Players.set(id,newPlayer);//Update object in map 
           console.log(`${newPlayer.nick} connected `, `ID: ${id}`);
           
           let array = []
           Rooms.forEach(rm =>{
                array.push(rm.name)
           });
           ws.send(JSON.stringify({"action": "getRooms", "param": array}))

       } else if (action === "message"){//Message to server consol Debug
            console.log(param);
       }
        else if (action === "sendMessageToPlayer"){
            const [playerId, message] = param.split("*");
            const targetPlayer = Players.get(playerId);
            if (targetPlayer){
                targetPlayer.socket.send(JSON.stringify({action: "message", param: message}))
            }else{
                ws.send(JSON.stringify({"action": "message", "param": "Player not founded"}))
            }
        }
        else if (action === "findRoom") {
            const searchRoom = Rooms.find(rm => rm._name === param);
            if (searchRoom){
                //return room 
                
            }else{
                ws.send(JSON.stringify({"action": "message", "param": "Room not found"}))
            }

       } else if (action === "createRoom") { //Create Room
           const isRoomExists = Rooms.find(rm => rm._name === param);
           if (!isRoomExists){
               Rooms.push({_name: param, host: id, players: [id]});
               console.log(`Room ${param} was created`);
           } else {
               console.log(`Room ${param} already exist`);
           }

       } else if ( action === "joinRoom") { // JoinRoom
            const currPlayer = Players.get(id);
            const room = Rooms.get(param);
            
            // is room exist
            if (room){
                //is in room? or has room
                if (room.playersSet.has(currPlayer.nick) || currPlayer.room !== ""){
                    console.log("already in room or has room");
                    return
                }
                room.playersSet.add(currPlayer.nick);
                console.log(`player ${currPlayer.nick} joined room ${param}`);
                
                let arr = []
                room.playersSet.forEach(nick =>{
                    if (currPlayer.nick !== nick) {
                        arr.push(nick)
                    }
                });
                ws.send(JSON.stringify({"action": "getNicks", "param": arr}))
            } else {
                console.log(`No room named ${param} exists`)
            }
       }
       
    });
    
    ws.on("close", ()=>{
        const disconnectedPlayer = Players.get(id);
        if (disconnectedPlayer){
            Players.delete(id);
            console.log(`Player ${disconnectedPlayer.nick} disconnected`);
        }
        console.log("Total de Players", Players.size); 
    });

    ws.on("error", (error)=>{
        console.error('Error en la conexión:', error.message);
        ws.close();
    });
});

