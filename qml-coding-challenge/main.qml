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



    property string username
    property string jsonString : '{"name":"Patrick", "age" : "31"}';
    property var jsonObject:  JSON.parse(jsonString);
    property string name: jsonObject.name;
    property int age: jsonObject.age;


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


        TextInput {
            id: loginPopupInput
            height: 100
            width: 200
            y: 200
            anchors.left: login

        }

        Button {
            y: 200
            x: 220
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
                anchors {
                    fill: parent
                }
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
                    socket.sendTextMessage(textInput.text)
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
                console.log("length")
                login.open()
            }

            console.log("Recieved:", message)
            chatWindow.text += message + '\n'
            chatScroll.scrollToBottom()

        }
    }
}


