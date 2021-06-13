const WebSocket = require('ws');
const uuid = require('uuid');
const { connect } = require('cookies');
const { connected } = require('process');

const wss = new WebSocket.Server({ port: 8080 });

var connected_users = {};

var connected_users_array = [];

wss.on('connection', function connection(ws, request) {

  ws.client_id = uuid.v4();
  connected_users_array.push(ws.client_id)
  ws.send('Your client Id:' + ws.client_id)

  ws.on('message', function incoming(message) {
    console.log('Received: %s', message);
    
//    broadcast message to all clients
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  })

  ws.on('close', function(){
    // removes the user that left the chat
    var index;
    for (i = 1; i < connected_users_array.length; i++)
    {
      console.log("looping...")
      if (connected_users_array[i] == ws.client_id) {
        
         index = i;
         console.log("index: " + i)
      }
    }
    if (index != null) {
      connected_users_array.splice(index, index)
    }
    console.log('client droped:', ws.client_id)
  });
});