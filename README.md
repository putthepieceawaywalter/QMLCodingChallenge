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
			// if the user is the sender the client will display: '(Me) <username> <message>'
			// else it will display '<user name>: <message>'


// lower level design

// when a user logs in the server assigns them a uid and sends the client a json object telling the client what their uid is
// the client saves their own uid
// Whenever a new user connects the server sends out a series of json objects with each connected user
	// the server saves a key value pair of uid and username for each user
	// for each connected user the server sends {username: <username>} to all clients
		// all clients have a current list of connected users now
		// client displays all OTHER connected users (not you)

// when a user sends a message the client makes a json string
	// format for json string: 'uid: <uid>, username: <username>, message: <message>'
// the server receives the message
	// server updates the key value pair of connected users
	// client sends out connected users list to clients
	// server broadcasts the message to all connected clients
// the clients receive the message
	// the client updates connected users
	// the client determines whether the uid of the sender matches their uid
		// if it does the message was from you!
			// note in the chat window that the message was from you
		// else the message was from someone else
			// client displays who it was from

// notes for interviewer

// I used a popup instead of a seperate qml page for the login screen because I was having trouble passing the username from one qml file to another
	// the popup seemed to fulfill all of the needs in the simplest way possible

// If you run the client and there is no server running no messages will appear, you can't even see messages that you've sent.  That was a decision I made 
// so the user would know something was wrong

// I think functionally everything is implemented. I could spend a lot more time on it and really build it up. The instructions say to not 
