import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

ApplicationWindow {
    width: 320
    height: 480
    visible: true

    Text {
        text: "Hello World"
        anchors.centerIn: parent
    }

    AddressList { }
}
