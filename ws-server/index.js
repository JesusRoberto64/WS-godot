import { WebSocketServer } from "ws";
import { v4 as uuidv4} from "uuid";

const wss = new WebSocketServer({port: 3000});
console.log("Listening in ws://localhost:3000")
//Set the players map
let Players = new Map();
//set a Dummie player
let tempID = "132185452";
Players.set(tempID, {nick: "MasterHost", room: "", socket: undefined})
//{_id: id, nick: "", room: "", socket: ws} //Players Object structure

//Set rooms map
let Rooms = new Map();
//set dummie rooms
for (let i = 0; i < 5; i++) {
    let tempName = `<Room${i}>`;
    let tempPlayersSet = new Set();
    tempPlayersSet.add(`host${i}`)

    Rooms.set(tempName, {name: tempName, host:`host${i}`, playersSet: tempPlayersSet});
}

//{_name: param, host: id, players: [id]} //Rooms object structure
wss.on("connection", ws =>{
    const id = uuidv4();
    Players.set(id, {nick: "", room: "", socket: ws});
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
           
           let arr = []
           Rooms.forEach(rm =>{
                arr.push(rm.name)
           });
           ws.send(JSON.stringify({"action": "getRooms", "param": arr}))

       } else if (action === "message"){//Message to consol
            console.log(param);

       } else if (action === "findRoom") {
            const searchRoom = Rooms.find(rm => rm._name === param);
            if (searchRoom){
                
            }else{
                console.log("Aint no room with that name")
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

