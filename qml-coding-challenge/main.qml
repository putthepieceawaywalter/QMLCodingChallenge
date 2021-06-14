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

    property string uid
    property string username
    property string message

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
            font.pixelSize: 25
            width: 400
            height: 50
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
                    font.pixelSize: 15
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
            font.pixelSize: 15
            onClicked: {
                // add some protection for valid input here
                username = loginPopupInput.text
                console.log("uid: " + username)
                var jsonData = {
                    uid: uid,
                    username: username,
                    message: ""

                }
                var jsonString = JSON.stringify(jsonData)
                socket.sendTextMessage(jsonString)
                login.close()
            }
        }
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
                    readOnly: true
                    id: chatWindow
                    text: ""
                    font.pixelSize: 15
                }
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
                font.pixelSize: 15
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
            font.pixelSize: 15
            onClicked: {
                // don't send empty messages
                if (textInput.length > 0)
                {
                    var jsonData = {
                        uid: uid,
                        username: username,
                        message: textInput.text

                    }
                    // users must be logged in to send messages
                    if (username === "")
                    {
                        login.open()
                    } else {
                    var jsonStr = JSON.stringify(jsonData)

                    socket.sendTextMessage(jsonStr)
                    textInput.text = ""
                    }
                }
            }
        }
    }
    Control {
        // this will list the users that are logged in
        horizontalPadding: 0
        verticalPadding: 10
        Rectangle {
            height: 30
            width: 180
            x:450
            color: "lightsteelblue"
            TextArea {
                id: usersTitle
                text: "Connected Users"
                font.pixelSize: 15



            }
        }

        Rectangle {
            width: 180
            height: 430
            x: 450
            y: 30
            color: "lightsteelblue"

            ScrollView {
                id: userScroll
                anchors.fill: parent
                clip: true

                TextArea {
                    readOnly: true
                    id: usersWindow
                    text: ""
                    font.pixelSize: 15
                    anchors.fill: parent
                }
            }
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

            var jsonMessage = JSON.parse(message)

            if (Object.keys(jsonMessage).length === 1) {
                // this sets this users id
                //uid = jsonMessage.uid

                if (jsonMessage.uid != null) {
                    uid = jsonMessage.uid
                    // this is the initial message from the server letting you know you've connected


                }
                else if (jsonMessage.username !== null) {
                    // this is listing connected users


                    console.log("logged in user: " + jsonMessage.username)
                    if (jsonMessage.username !== username)
                    {
                        usersWindow.text +=jsonMessage.username + '\n'

                    }
                }
            } else {
                usersWindow.text = ""
                console.log("Recieved:", message)

                if (jsonMessage.message !== "") {

                // this builds the message string

                if (jsonMessage.uid === uid)
                {
                    // this message was sent by this user
                    chatWindow.text += "(Me) "
                }

                chatWindow.text += jsonMessage.username + ": " + jsonMessage.message + '\n'
                chatScroll.scrollToBottom()
                }
            }
        }
    }
}
