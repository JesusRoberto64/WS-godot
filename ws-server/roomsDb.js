let rooms = new Map();
//{_name: param, host: id, players: [id]} //Rooms object structure
for (let i = 0; i < 5; i++) {
    let tempName = `<Room${i}>`;
    let tempPlayersSet = new Set();
    tempPlayersSet.add(`host${i}`)

    rooms.set(tempName, {name: tempName, host:`host${i}`, playersSet: tempPlayersSet});
}

export default rooms