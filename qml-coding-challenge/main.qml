import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.1
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0


Window {

    id: mainWindow
    visible: true
    width: 640
    height: 480
    color: "lightsteelblue"

    // json parsing stuff
        // this is just a test it probably doesn't make sense
    property string uid
    property string username
    property string message
    property string jsonString
    property var jsonObject
//    property string name: jsonObject.name;
//    property int age: jsonObject.age;


    function buildJsonObject(outgoingText) {
        // format
        // {uid:<uid>, username:<username>, message:<message>}

        //jsonString = '{"username": "username"}';
        jsonString = '{"uid": "kkjdf", "username": "username", "message": "outgoingText"}';
//        var jsonData = {
//            uid: uid,
//            username: username,
//            message: message

//        }
        //jsonString = jsonData.stringify()
        jsonObject = JSON.parse(jsonString)

    }
    function parseJson (message) {

    }

    Control {
    // chat window

    bottomPadding: 30
    topPadding: 30
        Rectangle {

            color: "white"
            width: 440
            height: 400
            border.width: 1
            radius: 5
            ScrollView {
                id: chatScroll

                function scrollToBottom() {
                    contentItem.contentY = chatWindow.height - contentItem.height
                }
                anchors.fill: parent
                clip: true

                TextArea {
                    id: chatWindow
                    text: ""
                }
            }
        }
    }


    Popup {
        // this will popup and prompt the user for a login if they haven't logged in
        id: login
        x: 120
        y: 100
        width: 400

        height: 300
        modal: true
        focus: true

        TextArea {
            text: "Please enter your username"
            width: 400
            height: 50
            anchors.top: login

        }

        Control {

            Rectangle {
                height: 50
                width: 200
                y: 200
                border.width: 1
                radius: 5
                color: "white"
                TextInput {
                    id: loginPopupInput
                    clip: true
                    selectByMouse: true
                    color: "black"
                    visible: true
                    wrapMode: Text.WrapAnywhere
                    anchors.fill: parent

                }
            }
        }
        Button {
            y: 200
            x: 220
            text: "submit"
            onClicked: {
                // add some protection for valid input here
                username = loginPopupInput.text
                console.log("uid: " + username)
                login.close()
            }
        }
    }

    Control {
        // this is the container for the text input and send button

        bottomPadding: 30
        topPadding: 30
        Rectangle {
            radius: 5
            border.width: 1
            color: "white"
            width: 300
            // total width of above container is 440
            height: 60
            y: 410

            TextInput {
                id: textInput
                width: 50
                height: 200
                clip: true
                selectByMouse: true
                color: "black"
                visible: true
                wrapMode: Text.WrapAnywhere
                anchors.fill: parent

                }
            }

        Button {
            id: sendButton
            width: 130
            height: 60
            x: 310
            y: 410
            text: "send"


            onClicked: {
                // don't send empty messages
                if (textInput.length > 0)
                {
                    // call a function to build json string
                    //message = textInput.text
                    buildJsonObject(textInput.text)
                    socket.sendTextMessage(jsonObject)
                    textInput.text = ""
                }
            }
        }
    }
    Control {
        // this will list the users that are logged in
        horizontalPadding: 10
        verticalPadding: 10
        Rectangle {
            width: 180
            height: 400
            x: 450
            border.width: 1
            radius: 5

        }
    }

    title: qsTr("Chat Coding Challenge")
    WebSocket{
        id:socket
        active: true
        url: "ws://localhost:8080"
        onTextMessageReceived: function(message){

            if (username.length < 1)
            {
                // open login popup if the username isn't set
                login.open()
            }
            if (uid.length < 1)
            {
                // uid has not been assigned

            }

            // receive json string
            // if the json object has only 1 key then it is the initial connection json object
            // use this to assign the local uid property
                // objects in order
                    // uid of sender
                        // check if uid of sender is you
                    // username of sender
                    // message
                        // print message
                            // if this user sent the message print "You: <message>"
                            // else print "<username>: <message>"

                    // usernames of all users currently logged in
                        // loop through each user and add them to the users text area

           // property string str: message;


            // first thing the server will send when a user logs in is the connection id as a string
            // anything else it sends will be a json object message
                // can you do a conditional based on type of message?

            //parseJson(message)

            var jsonMessage = JSON.parse(message)


            console.log("json object count: " + Object.keys(jsonMessage).length)

            if (Object.keys(jsonMessage).length === 1) {
                // this is this users uid

                uid = jsonMessage.uid
                console.log("local uid: " + uid)
            } else {
                console.log("Recieved:", message)

                chatWindow.text += jsonMessage.uid + '\n'
                chatScroll.scrollToBottom()
            }


        }
    }
}


