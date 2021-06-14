const WebSocket = require('ws');
const uuid = require('uuid');
const { connect } = require('cookies');
const { connected } = require('process');

const wss = new WebSocket.Server({ port: 8080 });

var connected_users = {
};


wss.on('connection', function connection(ws, request) {

  ws.client_id = uuid.v4();
  
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
        client.send(message);
        if (Object.keys(connected_users).length > 0)
        {
          for(var key in connected_users) {
            var user = {
              "username": connected_users[key]
            };
            client.send(JSON.stringify(user));
         }
        }
      }
    });
  })

  ws.on('close', function(){
    // removes the user that left the chat
    var index;

    delete connected_users[ws.client_id];
    console.log('client droped:', ws.client_id)
  });
});
