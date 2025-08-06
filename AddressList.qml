import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import "./Pinyin.js" as PinyinUtil

Item {
    width: 320
    height: 480

    property int expandedIndex: -1
    property string searchKeyword: ""

    // ✅ 固定联系人数据：姓名 + 电话统一管理
    property var contacts: [
        {"name": "皮皮",       "phone1": "029-8888-1111", "phone2": "138-1234-5678", "phone3": "029-6666-2222"},
        {"name": "日历",       "phone1": "029-8888-2222", "phone2": "139-8765-4321", "phone3": "029-6666-3333"},
        {"name": "父亲",       "phone1": "029-8888-3333", "phone2": "136-1122-3344", "phone3": "029-6666-4444"},
        {"name": "额额额",     "phone1": "029-8888-4444", "phone2": "135-5555-6666", "phone3": "029-6666-5555"},
        {"name": "高大上",     "phone1": "029-8888-5555", "phone2": "134-7777-8888", "phone3": "029-6666-6666"},
        {"name": "黑凤梨",     "phone1": "029-8888-6666", "phone2": "137-9999-0000", "phone3": "029-6666-7777"},
        {"name": "阿文",       "phone1": "029-8888-7777", "phone2": "133-1111-2222", "phone3": "029-6666-8888"},
        {"name": "阿南",       "phone1": "029-8888-8888", "phone2": "132-3333-4444", "phone3": "029-6666-9999"},
        {"name": "#特殊",      "phone1": "029-8888-9999", "phone2": "131-5555-6666", "phone3": "029-6666-0000"},
        {"name": "*特殊",      "phone1": "029-8888-0000", "phone2": "130-7777-8888", "phone3": "029-6666-1111"},
        {"name": "aaa",        "phone1": "029-8888-1111", "phone2": "138-1234-5678", "phone3": "029-6666-2222"},
        {"name": "AAA",        "phone1": "029-8888-2222", "phone2": "139-8765-4321", "phone3": "029-6666-3333"},
        {"name": "a啊a",       "phone1": "029-8888-3333", "phone2": "136-1122-3344", "phone3": "029-6666-4444"},
        {"name": "啊aa",       "phone1": "029-8888-4444", "phone2": "135-5555-6666", "phone3": "029-6666-5555"},
        {"name": "阿亮",       "phone1": "029-8888-5555", "phone2": "134-7777-8888", "phone3": "029-6666-6666"},
        {"name": "1阿1",       "phone1": "029-8888-6666", "phone2": "137-9999-0000", "phone3": "029-6666-7777"},
        {"name": "爸爸",       "phone1": "029-8888-7777", "phone2": "133-1111-2222", "phone3": "029-6666-8888"},
        {"name": "第八个",     "phone1": "029-8888-8888", "phone2": "132-3333-4444", "phone3": "029-6666-9999"},
        {"name": "奶奶",       "phone1": "029-8888-9999", "phone2": "131-5555-6666", "phone3": "029-6666-0000"},
        {"name": "叔叔",       "phone1": "029-8888-0000", "phone2": "130-7777-8888", "phone3": "029-6666-1111"},
        {"name": "智障啊",     "phone1": "029-8888-1111", "phone2": "138-1234-5678", "phone3": "029-6666-2222"},
        {"name": "满意",       "phone1": "029-8888-2222", "phone2": "139-8765-4321", "phone3": "029-6666-3333"},
        {"name": "岁月",       "phone1": "029-8888-3333", "phone2": "136-1122-3344", "phone3": "029-6666-4444"},
        {"name": "可能",       "phone1": "029-8888-4444", "phone2": "135-5555-6666", "phone3": "029-6666-5555"},
        {"name": "黄河",       "phone1": "029-8888-5555", "phone2": "134-7777-8888", "phone3": "029-6666-6666"}
    ]

    Item {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        Rectangle {
            anchors.fill: parent
            color: "#f0f0f0"
        }

        // 搜索框
        Item {
            width: parent.width
            height: 50
            anchors.top: parent.top

            Rectangle {
                width: parent.width - 40
                height: 30
                anchors.centerIn: parent
                radius: 15
                color: "#ffffff"
                border.color: "#cccccc"
                border.width: 1

                Item {
                    width: parent.width
                    height: parent.height

                    Image {
                        source: "qrc:/search.png"
                        width: 15
                        height: 15
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextField {
                        width: parent.width - 40
                        height: parent.height
                        anchors.left: parent.left
                        anchors.leftMargin: 23
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        placeholderText: "搜索联系人..."
                        font.pixelSize: 14
                        color: "#333333"
                        background: Item {}
                        onTextChanged: {
                            searchKeyword = text
                            filterContacts()
                        }
                    }
                }
            }
        }

        // 分组标题
        Component {
            id: sectionHeader
            Item {
                width: 80
                height: 30
                Text {
                    text: section.toUpperCase()
                    font.pixelSize: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    color: "#666666"
                    anchors.bottom: parent.bottom
                }
            }
        }

        // 联系人列表
        ListView {
            id: listView
            width: parent.width
            height: parent.height - 50
            anchors.bottom: parent.bottom
            clip: true

            model: searchKeyword.length > 0 ? filteredModel : testModel

            delegate: Item {
                width: parent.width
                height: isExpanded ? 100 : 35

                readonly property int itemIndex: index
                readonly property bool isExpanded: listView.parent.parent.expandedIndex === itemIndex

                readonly property string phone1: model.phone1
                readonly property string phone2: model.phone2
                readonly property string phone3: model.phone3

                // 展开时背景为白色
                Rectangle {
                    anchors.fill: parent
                    color: isExpanded ? "#ffffff" : "transparent"
                }

                // 联系人基本信息区域
                Item {
                    width: parent.width
                    height: 35

                    Rectangle {
                        width: parent.width
                        height: 35
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            onClicked: {
                                if (isExpanded) {
                                    listView.parent.parent.expandedIndex = -1
                                } else {
                                    listView.parent.parent.expandedIndex = itemIndex
                                }
                            }
                        }

                        Text {
                            text: listView.getShowTextSpecial(model.name)
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#333333"
                            font.pixelSize: 16
                            x: 24
                        }
                    }
                }

                // 电话信息区域（可展开）
                Item {
                    y: 35
                    width: parent.width
                    height: isExpanded ? 65 : 0
                    opacity: isExpanded ? 1 : 0

                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    Behavior on height { NumberAnimation { duration: 200 } }

                    // 三个电话号码（带标签）
                    Text {
                        text: "单位电话：" + phone1
                        y: 0
                        x: 48
                        color: "#333333"
                        font.pixelSize: 14
                    }

                    Text {
                        text: "家庭座机：" + phone3
                        y: 20
                        x: 48
                        color: "#333333"
                        font.pixelSize: 14
                    }

                    Text {
                        text: "手机：" + phone2
                        y: 40
                        x: 48
                        color: "#333333"
                        font.pixelSize: 14
                    }
                }
            }

            ScrollIndicator.vertical: ScrollIndicator {
                anchors.right: parent.right
                anchors.rightMargin: 8
                contentItem: Rectangle {
                    implicitWidth: 3
                    radius: implicitWidth / 2
                    color: "#cccccc"
                }
            }

            function getShowTextSpecial(str) {
                var first = str[0]
                if (first === "#") return str.substr(1)
                return str
            }

            section.property: "pinyin"
            section.criteria: ViewSection.FirstCharacter
            section.delegate: sectionHeader
        }

        // 右侧字母栏
        Item {
            width: 30
            height: parent.height - 50
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.right: parent.right
            anchors.rightMargin: 5

            MouseArea {
                anchors.fill: parent

                function changeBigText() {
                    bigTip.visible = true
                    var index = parseInt(mouseY / 10)
                    if (index < 0) index = 0
                    if (index > 26) index = 26
                    bigText.text = qsTr(letters[index] + "")
                    var search_index = getIndexByLab(bigText.text)
                    if (search_index >= 0)
                        listView.positionViewAtIndex(search_index, ListView.Beginning)
                }

                function getIndexByLab(lab) {
                    for (var i = 0; i < testModel.count; i++) {
                        if (testModel.get(i).pinyin.substr(0, 1).toUpperCase() === lab) {
                            return i
                        }
                    }
                    return -1
                }

                onPositionChanged: changeBigText()
                onPressed: changeBigText()
                onReleased: bigTip.visible = false
            }

            Column {
                spacing: 0
                Repeater {
                    model: letters
                    delegate: Text {
                        width: 30
                        height: 14
                        text: modelData
                        font.pixelSize: 12
                        color: "#666666"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // 大字母提示
        Rectangle {
            width: 30
            height: width
            radius: width / 2
            color: "#ffffff"
            anchors.centerIn: parent
            visible: false
            id: bigTip

            Text {
                id: bigText
                text: qsTr("A")
                font.pixelSize: 16
                color: "#333333"
                anchors.centerIn: parent
            }
        }
    }

    property var letters: ["A","B","C","D","E","F","G","H","I","J","K",
                          "L","M","N","O","P","Q","R","S","T","U","V","W",
                          "X","Y","Z","#"]

    function generateData(contact) {
        var name = contact.name
        var pinyin = PinyinUtil.pinyin.getFullChars(name)
        return {
            name: name,
            pinyin: pinyin,
            phone1: contact.phone1,
            phone2: contact.phone2,
            phone3: contact.phone3
        }
    }

    function chack_special(str) {
        var pattern1 = new RegExp("[`～!@#$^&*()=|{}':;',\\[\\].<>《》/?～！@#￥……&*（）——|{}【】‘；：”“'。，、？ ]")
        var pattern2 = /^[0-9]*$/
        return pattern1.test(str) || pattern2.test(str)
    }

    function moveFirstToEnd(array) {
        var first = array[0]
        array.push(first)
        array.shift()
    }

    ListModel {
        id: filteredModel
    }

    function filterContacts() {
        filteredModel.clear()
        if (searchKeyword.length === 0) return
        for(var i = 0; i < testModel.count; i++) {
            var item = testModel.get(i)
            if (item.name.toLowerCase().indexOf(searchKeyword.toLowerCase()) !== -1 ||
                item.pinyin.toLowerCase().indexOf(searchKeyword.toLowerCase()) !== -1) {
                filteredModel.append(generateData(item))
            }
        }
    }

    ListModel {
        id: testModel

        Component.onCompleted: {
            var resultArray = []
            for (var i = 0; i < contacts.length; i++) {
                var contact = contacts[i]
                var pinyin = PinyinUtil.pinyin.getFullChars(contact.name)
                resultArray.push({
                    name: contact.name,
                    pinyin: pinyin,
                    phone1: contact.phone1,
                    phone2: contact.phone2,
                    phone3: contact.phone3
                })
            }

            resultArray.sort(function(a, b) {
                return a.pinyin.localeCompare(b.pinyin)
            })

            var specialNumber = 0
            for (var i = 0; i < resultArray.length; i++) {
                if (chack_special(resultArray[i].name.substr(0, 1))) {
                    resultArray[i].name = "#" + resultArray[i].name
                    specialNumber++
                }
            }

            for (i = 0; i < specialNumber; i++) moveFirstToEnd(resultArray)

            for (i = 0; i < resultArray.length; i++) {
                testModel.append(resultArray[i])
            }
        }
    }
}
