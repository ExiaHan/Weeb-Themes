import QtQuick 2.0
import SddmComponents 2.0
import QtMultimedia 5.0

Rectangle {
    id: container
    width: 1024
    height: 768
    property int sessionIndex: session.index
    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
        }
        onLoginFailed: {
            txtMessage.text = textConstants.loginFailed
            listView.currentItem.password.text = ""
        }
    }

    /********************************
               Background
    *********************************/
    Repeater {
        model: screenModel
        Item {
            anchors.fill: parent
            MediaPlayer {
                id: mediaPlayer
                source: "resources/vid.mp4"
                autoPlay: true
                autoLoad: true
                loops: -1
            }
            VideoOutput {
                source: mediaPlayer
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectCrop
            }
        }
    }

    /*******************************
               Foreground
    ********************************/
    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        color: "transparent"

        /********* Hashtag *********/
        Image {
            id: hashtag
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 60
            source: "resources/Illya-Dance.png"
        }
        
        /********* Login Box *********/
        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            id: loginBoximage
            width: 180
            height: 98
            source: "resources/login.png"
        }
        Rectangle {
            id: loginBox
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: 174
            height: 90
            color: "transparent"
            
            Column {
                width: parent.width
                height: parent.height
                spacing: 2
            
                /*** Username ***/
                Row {
                    spacing: 4
                    Image {
                        id: userimage
                        width: parent.height
                        source: "resources/power.png"
                    }
                    TextInput {
                        id: name
                        y: 6
                        width: 150; height: 16
                        horizontalAlignment: TextInput.AlignHCenter
                        text: userModel.lastUser
                        font.pixelSize: 12
                        KeyNavigation.backtab: btnShutdown; KeyNavigation.tab: password
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }
                /*** Password ***/
                Row {
                    spacing: 4
                    Image {
                        id: passwordimage
                        width: parent.height
                        source: "resources/reboot.png"
                    }
                    TextInput {
                        id: password
                        y: 6
                        width: 150; height: 16
                        horizontalAlignment: TextInput.AlignHCenter
                        echoMode: TextInput.Password
                        font.pixelSize: 12
                        autoScroll: false
                        KeyNavigation.backtab: name; KeyNavigation.tab: session
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }		
                    }
                }
                /***  Buttons ***/
                Row {
                    spacing: 4
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    ImageButton {
                        id: session
                        width: parent.height
                        source: "resources/reboot.png"
                        
                        onClicked: if (menu_session.state === "visible") menu_session.state = ""; else menu_session.state = "visible"
                        KeyNavigation.backtab: password; KeyNavigation.tab: btnSuspend
                    }
                    ImageButton {
                        id: btnSuspend
                        width: parent.height
                        x: 30
                        source: "resources/reboot.png"

                        visible: sddm.canSuspend
                        onClicked: sddm.suspend()
                        KeyNavigation.backtab: session; KeyNavigation.tab: btnHibernate
                    }
                    ImageButton {
                        id: btnHibernate
                        width: parent.height
                        source: "resources/reboot.png"

                        visible: sddm.canHibernate
                        onClicked: sddm.hibernate()
                        KeyNavigation.backtab: btnSuspend; KeyNavigation.tab: btnReboot
                    }
                    ImageButton {
                        id: btnReboot
                        width: parent.height
                        source: "resources/reboot.png"

                        visible: sddm.canReboot 
                        onClicked: sddm.reboot()
                        KeyNavigation.backtab: btnHibernate; KeyNavigation.tab: btnShutdown
                    }
                    ImageButton {
                        id: btnShutdown
                        width: parent.height
                        source: "resources/power.png"

                        visible: sddm.canPowerOff
                        onClicked: sddm.powerOff()
                        KeyNavigation.backtab: btnReboot; KeyNavigation.tab: name
                    }
                }
                Menu {
                        id: menu_session
                        width: 100
                        model: sessionModel
                        index: sessionModel.lastIndex
                }
            }
        }
    }
}