import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

TextField {
	id: root
	property string label

	font.pixelSize: 20

	Text {
		id: labelText
		anchors.left: root.left
		anchors.verticalCenter: parent.verticalCenter

		readonly property int bigFontPixelSize: 18
		readonly property int smallFontPixelSize: 14

		text: root.label
		state: (root.placeholderText || root.text) ? "up" : "down"
		states: [
			State {
				name: "up"
				PropertyChanges {
					target: labelText
					color: Material.accentColor
					font.pixelSize: smallFontPixelSize
					anchors.verticalCenterOffset: -root.height / 2
				}
			},
			State {
				name: "down"
				PropertyChanges {
					target: labelText
					font.pixelSize: bigFontPixelSize
					color: root.placeholderTextColor
					anchors.verticalCenterOffset: -4
				}
			}
		]

		transitions: [
			Transition {
				from: "up"
				to: "down"
				PropertyAnimation {properties: "height,anchors.verticalCenterOffset,font.pixelSize";duration: 100}
				ColorAnimation {properties: "color";duration: 100}
			},
			Transition {
				from: "down"
				to: "up"
				PropertyAnimation {properties: "height,anchors.verticalCenterOffset,font.pixelSize";duration: 100}
				PropertyAnimation {properties: "color";duration: 100}
			}
		]
	}

	onFocusChanged: {
		if(focus){
			labelText.state = "up"
		}
		else if(!(placeholderText || text)){
			labelText.state = "down"
		}
	}

	onTextChanged: {
		if(focus){
			labelText.state = "up"
		}else{
			labelText.state = (root.placeholderText || root.text) ? "up" : "down"
		}
	}
}
