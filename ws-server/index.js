import { WebSocketServer } from "ws";
import { handleConnection } from "./handlers/connectionHandler.js";
import Rooms from "./models/roomsDb.js";
import Players from "./models/playersDb.js";

const wss = new WebSocketServer({port: 3000});
console.log("Listening in ws://localhost:3000")

wss.on("connection", (ws) => handleConnection(ws, Players, Rooms));


