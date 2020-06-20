/*eslint no-console: 0, no-unused-vars: 0, no-use-before-define: 0, no-redeclare: 0, no-undef: 0, */
/*eslint-env es6 */
//To use a javascript controller its name must end with .controller.js
sap.ui.define([
	"sap/openSAP/odataCRUDBatch/controller/BaseController",
	"sap/ui/model/json/JSONModel"
], function (BaseController, JSONModel) {
	"use strict"

	return BaseController.extend("sap.openSAP.odataCRUDBatch.controller.App", {

		onInit: function () {
			this.getView().addStyleClass("sapUiSizeCompact") // make everything inside this View appear in Compact mode
			var oConfig = this.getOwnerComponent().getModel("config")
			var userName = oConfig.getProperty("/UserName")
			var userModel = this.getOwnerComponent().getModel("userModel")
			var oTable = this.getView().byId("userTable")
			oTable.setModel(userModel)
		},

		callUserService: function () {
			var oModel = this.getOwnerComponent().getModel("userModel")
			var result = this.getView().getModel().getData()
			var oEntry = {}
			//oEntry.UserId = "0000000000"
			oEntry.FIRSTNAME = result.FIRSTNAME
			oEntry.LASTNAME = result.LASTNAME
			oEntry.EMAIL = result.EMAIL

			var mParams = {}
			mParams.success = function () {
				sap.ui.require(["sap/m/MessageToast"], (MessageToast) => {
					MessageToast.show("Create successful")
				})
			}
			mParams.error = onODataError;
			oModel.create("/User", oEntry, mParams);
		},

		callUserUpdate: function () {
			var oModel = this.getOwnerComponent().getModel("userModel")
			var mParams = {}
			mParams.error = onODataError
			sap.ui.require(["sap/m/MessageToast"], (MessageToast) => {
				MessageToast.show("Update successful")
			})
			oModel.submitChanges(mParams)
		},

		onBatchDialogPress: function () {
			var view = this.getView()
			view._bDialog = sap.ui.xmlfragment(
				"sap.openSAP.odataCRUDBatch.view.batchDialog", this // associate controller with the fragment
			)
			view._bDialog.addStyleClass("sapUiSizeCompact")
			view.addDependent(this._bDialog)
			view._bDialog.addContent(view.getController().getItem(true))
			view._bDialog.open()
		},

		onDialogCloseButton: function () {
			this.getView()._bDialog.close()
		},

		getItem: function (isFirstRow) {
			var view = this.getView()
			var addIcon = new sap.ui.core.Icon({
				src: "sap-icon://add",
				color: "#006400",
				size: "1.5rem",
				press: function () {
					view._bDialog.addContent(view.getController().getItem(false))
				}
			})

			var deleteIcon = new sap.ui.core.Icon({
				src: "sap-icon://delete",
				color: "#49311c",
				size: "1.5rem",
				press: function (oEvent) {
					view._bDialog.removeContent(oEvent.oSource.oParent.sId)
				}
			})

			var icon
			if (isFirstRow) {
				icon = addIcon
			} else {
				icon = deleteIcon
			}
			icon.addStyleClass("iconPadding")

			var firstNameTxt = new sap.m.Label({
				text: "First Name"
			})
			firstNameTxt.addStyleClass("alignText")
			var firstNameInput = new sap.m.Input({})

			var lastNameTxt = new sap.m.Label({
				text: "Last Name"
			})
			lastNameTxt.addStyleClass("alignText")
			var lastNameInput = new sap.m.Input({})

			var emailTxt = new sap.m.Label({
				text: "Email"
			})
			emailTxt.addStyleClass("alignText")
			var emailInput = new sap.m.Input({})

			return new sap.m.FlexBox({
				// enableFlexBox: true,
				//    fitContainer: true,
				//  justifyContent: sap.m.FlexJustifyContent.SpaceBetween,
				items: [firstNameTxt,
					firstNameInput,
					lastNameTxt,
					lastNameInput,
					emailTxt,
					emailInput,
					icon
				]
			})
		},

		onSubmitBatch: function () {
			var view = this.getView()
			var content = view._bDialog.getContent()
			var newUserList = []
			for (var i = 0; i < content.length; i++) {
				var user = {}
				//user.UserId = "0000000000"
				user.FIRSTNAME = content[i].getItems()[1].getValue()
				user.LASTNAME = content[i].getItems()[3].getValue()
				user.EMAIL = content[i].getItems()[5].getValue()
				newUserList.push(user)
			}

			//create an array of batch changes and save  
			var oParams = {}
			oParams.json = true
			oParams.defaultUpdateMethod = "PUT"
			oParams.useBatch = true

			var batchModel = new sap.ui.model.odata.v2.ODataModel("/odata/v2/MasterDataService/", oParams)
			//var batchChanges = []
			var mParams = {}
			mParams.groupId = "1001"
			mParams.success = function () {
				sap.ui.require(["sap/m/MessageToast"], (MessageToast) => {
					MessageToast.show("Create successful")
				})
			}
			mParams.error = onODataError

			for (var k = 0; k < newUserList.length; k++) {
				batchModel.create("/User", newUserList[k], mParams)
			}
		}
	})
})