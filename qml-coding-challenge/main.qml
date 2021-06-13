import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.1
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0



Window {

    visible: true
    width: 640
    height: 480
    color: "lightsteelblue"

    // json parsing stuff
        // this is just a test it probably doesn't make sense



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
                //ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                contentHeight: rect1.height+rect2.height+rect3.height

                TextArea {
                    id: chatWindow
                    text: ""
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
                //chatWindow.text += textInput.text + '\n'
                // don't send empty messages
                if (textInput.length > 0)
                {
                    socket.sendTextMessage(textInput.text)
                    textInput.text = ""
                } else {
                    textInput.sendTextMessage(textInput.text)
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
            console.log("Recieved:", message)
            chatWindow.text += message + '\n'
            chatScroll.scrollToBottom()
            //socket.sendTextMessage("I received (" + message + ")")

        }
    }
}


