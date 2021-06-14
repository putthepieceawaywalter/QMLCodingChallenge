# QMLCodingChallenge
coding challenge for upcoming interview


// high level design
	// user is presented with a login screen
		// no authentication occurs, they just pick a user name
	// client connects to server
	// server assigns the client an id
	// client saves that id
	// user sends message to server from client
	// server should sends that message to all clients, including sender
	// client will determine if they were the sender (id's match)
	// client displays who sent message and the message
		// format: <user name>: <message>
			// if the user is the sender the client will display: 'You: <message>'
			// else it will display '<user name>: <message>'





// to do items

	// find out how to do qml json.stringify
	//

	// chat work cycle
		// send strings across the network
		// use json.stringify to send those strings
		// build the json object 
		// use the json fields whenever possible
		

	// switch from sending string message to sending json object
		// json format: <user id>  <user name> <string message> 