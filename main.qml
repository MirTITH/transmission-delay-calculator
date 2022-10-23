import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
	width: 660
	height: 460
	visible: true
	title: qsTr("过孔传输延时计算器")
	Item {
		anchors.fill: parent
		anchors.margins: 10
		Rectangle {
			id: rectOutput
			width: parent.width
			height: columnLOutput.height
			border.width: 2
			border.color: "steelblue"
			radius: 10
			color: "lavender"
			Column {
				id: columnLOutput
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.leftMargin: 20
				anchors.rightMargin: 20
				Item{
					width: parent.width
					height: 10
				}

				MTextField {
					id: textL
					width: parent.width
					height: 50
					selectByMouse: true
					label: "寄生电感 (nH)"
					onTextChanged: {
						textTd.updateValue()
					}

					function updateValue()
					{
						var len = Number(textLen.text) / 1000
						var d = Number(textD1.text) / 1000
						this.text = 5.08 * len * (Math.log(4 * len / d) + 1)
					}
				}

				MTextField {
					id: textC
					width: parent.width
					height: 50
					selectByMouse: true
					label: "寄生电容 (pF)"

					onTextChanged: {
						textTd.updateValue()
					}
					function updateValue()
					{
						var Er
						if(textEr.text)
						{
							Er = Number(textEr.text)
						}else{
							Er = Number(textEr.placeholderText);
						}

						var h = Number(textLen.text) / 1000
						var d1 = Number(textD1.text) / 1000
						var d2 = Number(textD2.text) / 1000

						this.text = 1.41 * Er * h * d1 / (d2 - d1)
					}
				}


				MTextField {
					id: textTd
					width: parent.width
					height: 50
					selectByMouse: true
					label: "过孔传输延时 (ps)"
					readOnly: true
					function updateValue()
					{
						var C = Number(textC.text)
						var L = Number(textL.text) * 1000
						this.text = Math.sqrt(C * L)
					}
				}

				RowLayout{
					width: parent.width
					height: 50
					MTextField {
						id: textMicroStripeTd
						width: parent.width
						height: parent.height
						Layout.fillWidth: true
						selectByMouse: true
						label: "微带线传输延时 (ps)"
						readOnly: true
						function updateValue()
						{
							var Er = Number(textEr.text)
							var len = Number(textMicroStripLen.text) / 1000
							this.text = (len * 85 * Math.sqrt(0.475 * Er + 0.67)).toPrecision(8)
						}
					}
					MTextField {
						id: textStripeLineTd
						width: parent.width
						height: parent.height
						Layout.fillWidth: true
						selectByMouse: true
						label: "带状线传输延时 (ps)"
						readOnly: true
						function updateValue()
						{
							var Er = Number(textEr.text)
							var len = Number(textStripLineLen.text) / 1000
							this.text = (len * 85 * Math.sqrt(Er)).toPrecision(8)
						}
					}
				}


			}
		}

		Rectangle {
			width: parent.width
			anchors.top: rectOutput.bottom
			anchors.bottom: parent.bottom
			anchors.topMargin: 10
			border.width: 2
			border.color: "black"
			radius: 10
			color: "transparent"

			Flow {
				anchors.fill: parent
				anchors.leftMargin: 10
				anchors.rightMargin: 10

				topPadding: 10

				spacing: 30

				Rectangle{
					height: 50
					width: parent.width > 600 ? parent.width / 2 - parent.spacing / 2 : parent.width
					color: "transparent"
					RowLayout{
						anchors.fill: parent
						MTextField {
							id: textLen
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "过孔长度 (mil)"

							onTextChanged: {
								if(focus)
								{
									var mil = Number(this.text) * 25.4 / 1000
									textLenMM.text = mil.toPrecision(5)
								}
								textL.updateValue()
								textC.updateValue()
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 5).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 5).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}

						MTextField {
							id: textLenMM
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "过孔长度 (mm)"
							onTextChanged: {
								if(focus)
								{
									var mil = Number(this.text) / 25.4 * 1000
									textLen.text = mil.toPrecision(5)
								}
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 0.1).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 0.1).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}
					}
				}

				Rectangle{
					height: 50
					width: parent.width > 600 ? parent.width / 2 - parent.spacing / 2 : parent.width
					color: "transparent"
					RowLayout{
						anchors.fill: parent
						MTextField {
							id: textD1
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "过孔内径 (mil)"
							onTextChanged: {
								if(focus)
								{
									var mm = Number(this.text) * 25.4 / 1000
									textD1MM.text = mm.toPrecision(5)
								}
								textL.updateValue()
								textC.updateValue()
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 5).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 5).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}

						MTextField {
							id: textD1MM
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "过孔内径 (mm)"
							onTextChanged: {
								if(focus)
								{
									var mil = Number(this.text) / 25.4 * 1000
									textD1.text = mil.toPrecision(5)
								}
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 0.1).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 0.1).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}
					}
				}

				Rectangle{
					height: 50
					width: parent.width > 600 ? parent.width / 2 - parent.spacing / 2 : parent.width
					color: "transparent"
					RowLayout{
						anchors.fill: parent
						MTextField {
							id: textEr
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "介电常数"
							placeholderText: "4.3"
							text: "4.3"
							onTextChanged: {
								textC.updateValue()
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 0.1).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 0.1).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}
					}
				}

				Rectangle{
					height: 50
					width: parent.width > 600 ? parent.width / 2 - parent.spacing / 2 : parent.width
					color: "transparent"
					RowLayout{
						anchors.fill: parent
						MTextField {
							id: textD2
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "过孔外径 (mil)"
							onTextChanged: {
								if(focus)
								{
									var mm = Number(this.text) * 25.4 / 1000
									textD2MM.text = mm.toPrecision(5)
								}
								textC.updateValue()
							}

							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 5).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 5).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}

						MTextField {
							id: textD2MM
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "过孔外径 (mm)"
							onTextChanged: {
								if(focus)
								{
									var mil = Number(this.text) / 25.4 * 1000
									textD2.text = mil.toPrecision(5)
								}
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 0.1).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 0.1).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}
					}

				}

				Rectangle{
					height: 50
					width: parent.width > 600 ? parent.width / 2 - parent.spacing / 2 : parent.width
					color: "transparent"
					RowLayout{
						anchors.fill: parent
						MTextField {
							id: textMicroStripLen
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "微带线长度 (mil)"

							onTextChanged: {
								if(focus)
								{
									var mil = Number(this.text) * 25.4 / 1000
									textMicroStripLenMM.text = mil.toPrecision(5)
								}
								textMicroStripeTd.updateValue()
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 5).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 5).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}

						MTextField {
							id: textMicroStripLenMM
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "微带线长度 (mm)"
							onTextChanged: {
								if(focus)
								{
									var mil = Number(this.text) / 25.4 * 1000
									textMicroStripLen.text = mil.toPrecision(5)
								}
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 0.1).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 0.1).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}
					}
				}

				Rectangle{
					height: 50
					width: parent.width > 600 ? parent.width / 2 - parent.spacing / 2 : parent.width
					color: "transparent"
					RowLayout{
						anchors.fill: parent
						MTextField {
							id: textStripLineLen
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "带状线长度 (mil)"
							onTextChanged: {
								if(focus)
								{
									var mm = Number(this.text) * 25.4 / 1000
									textStripLineLenMM.text = mm.toPrecision(5)
								}
								textStripeLineTd.updateValue()
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 5).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 5).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}

						MTextField {
							id: textStripLineLenMM
							height: parent.height
							Layout.fillWidth: true
							selectByMouse: true
							label: "带状线长度 (mm)"
							onTextChanged: {
								if(focus)
								{
									var mil = Number(this.text) / 25.4 * 1000
									textStripLineLen.text = mil.toPrecision(5)
								}
							}
							MouseArea{
								anchors.fill: parent
								propagateComposedEvents: true
								onWheel: {
									parent.focus = true
									if(wheel.angleDelta.y > 0){
										parent.text = (Number(parent.text) + 0.1).toPrecision(5)
									}else{
										parent.text = (Number(parent.text) - 0.1).toPrecision(5)
									}
								}
								onClicked: {
									mouse.accepted = false
								}
								onPressed: {
									mouse.accepted = false
								}
							}
						}
					}
				}
			}
		}
	}
}

