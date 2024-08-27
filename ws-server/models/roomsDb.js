let rooms = new Map();
//{_name: param, host: id, players: [id]} //Rooms object structure
for (let i = 0; i < 5; i++) {
    let tempName = `<Room${i}>`;
    let tempPlayersSet = []//new Set();
    tempPlayersSet.push(`"00000000-0000-0000-0000-000001E240"`)

    rooms.set(tempName, {_name: tempName, host:`masterHost`, players: tempPlayersSet});
}

export default rooms