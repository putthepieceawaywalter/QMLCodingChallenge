const WebSocket = require('ws');
const uuid = require('uuid');
const { connect } = require('cookies');
const { connected } = require('process');

const wss = new WebSocket.Server({ port: 8080 });

var connected_users = {
};

var connected_users_array = [];

wss.on('connection', function connection(ws, request) {

  ws.client_id = uuid.v4();
  connected_users_array.push(ws.client_id)

  
  var jsonid = {
    uid: ws.client_id
  };
  var jsonString = JSON.stringify(jsonid);
  console.log(jsonString);
  ws.send(jsonString);

  ws.on('message', function incoming(message) {
    // check if this user is added to connected users
    var jsonData = JSON.parse(message)

    if (connected_users[jsonData.uid] == null){
      connected_users[jsonData.uid] = jsonData.username;
      console.log("added this user: " + connected_users[jsonData.uid])
    }

    var connectedUsersString = JSON.stringify(connected_users);
    


    console.log('Received: %s', message);
//    broadcast message to all clients
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        //client.send(connectedUsersString);
        client.send(message);
        if (Object.keys(connected_users).length > 0)
        {
          for(var key in connected_users) {
            console.log("inside loop");
            var user = {
              "username": connected_users[key]
            };
            console.log("this user is logged in, sending to client: " + JSON.stringify(user))
            client.send(JSON.stringify(user));
         }
        }
      }
    });
  })

  ws.on('close', function(){
    // removes the user that left the chat
    var index;
    // for (i = 1; i < connected_users_array.length; i++)
    // {
    //   console.log("looping...")
    //   if (connected_users_array[i] == ws.client_id) {
        
    //      index = i;
    //      console.log("index: " + i)
    //   }
    // }
    // if (index != null) {
    //   connected_users_array.splice(index, index)
    // }
    console.log("connected users before: " + connected_users[ws.client_id])

    delete connected_users[ws.client_id];
    console.log(connected_users[ws.client_id])
    console.log('client droped:', ws.client_id)
  });
});