import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    id: loginWindow
    visible: true
    width: 640
    height: 480
    color: "lightsteelblue"
    function sendUserToMainWindow() {

        pageLoader.source = "main.qml"
        loginWindow.visible = false;
        var mainWindow = component.createObject();
        mainWindow.uid = "patrick";
    }

    Loader { id: pageLoader }

    Control {
       // user login input and button
        bottomPadding: 30
        topPadding: 30
        Rectangle {
            radius: 5
            border.width: 1
            color: "white"
            width: 300
            height: 60
            y: 200

            TextInput {
                id: usernameInput
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
            id: loginButton
            width: 130
            height: 60
            x: 310
            y: 200
            text: "login"
            onClicked: sendUserToMainWindow()
        }
    }
}
