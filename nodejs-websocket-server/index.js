const WebSocket = require('ws');
const uuid = require('uuid');

const wss = new WebSocket.Server({ port: 8080 });

var connected_users = {};


wss.on('connection', function connection(ws, request) {

  ws.client_id = uuid.v4();
  ws.send('Your client Id:' + ws.client_id)

  ws.on('message', function incoming(message) {
    console.log('Received: %s', message);
  })

  ws.on('close', function(){
    console.log('client droped:', ws.client_id)
  });

});