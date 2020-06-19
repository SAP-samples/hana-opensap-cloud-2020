/*eslint no-console: 0, no-unused-vars: 0, no-use-before-define: 0, no-redeclare: 0, no-undef: 0*/
/*eslint-env es6 */
//To use a javascript controller its name must end with .controller.js
sap.ui.define([
	"sap/openSAP/odataAdv/controller/BaseController",
	"sap/ui/model/json/JSONModel"
], function (BaseController, JSONModel) {
	"use strict"

	return BaseController.extend("sap.openSAP.odataAdv.controller.App", {

		onInit: function () {

			var oConfig = this.getOwnerComponent().getModel("config")
			var userName = oConfig.getProperty("/UserName")

			var urlMulti = "/odata/v2/POService/"
			this.getOwnerComponent().getModel().setProperty("/mPath", urlMulti)
			this.getOwnerComponent().getModel().setProperty("/mEntity1", "POs")
			this.getOwnerComponent().getModel().setProperty("/mEntity2", "POItems")

		},
		callMultiService: function () {
			var oTable = this.getView().byId("frg1--tblPOHeader")
			var oTableItem = this.getView().byId("frg2--tblPOItem")

			var mPath = this.getOwnerComponent().getModel().getProperty("/mPath")
			var mEntity1 = this.getOwnerComponent().getModel().getProperty("/mEntity1")
			var mEntity2 = this.getOwnerComponent().getModel().getProperty("/mEntity2")

			var oParams = {}
			oParams.json = true
			oParams.useBatch = true
			var oModel = new sap.ui.model.odata.v2.ODataModel(mPath, oParams)
			oModel.attachEvent("requestFailed", oDataFailed)

			function fnLoadMetadata() {
				oTable.setModel(oModel)
				oTable.setEntitySet(mEntity1)
				oTableItem.setModel(oModel)
				oTableItem.setEntitySet(mEntity2)
				var oMeta = oModel.getServiceMetadata()
				var headerFields = ""
				var itemFields = ""

				for (let entity of oMeta.dataServices.schema[0].entityType){
					if(entity.name == mEntity1){
						for (let property of  entity.property) {
							headerFields += property.name + ","
						}
					}
					if(entity.name == mEntity2){
						for (let property of  entity.property) {
							if(property.name !== "product_productId"){
								itemFields += property.name + ","
							}
						}
					}
				}
			
				oTable.setInitiallyVisibleFields(headerFields)
				oTableItem.setInitiallyVisibleFields(itemFields)
			}

			oModel.attachMetadataLoaded(oModel, function () {
				fnLoadMetadata()
			});

			oModel.attachMetadataFailed(oModel, function () {
				sap.ui.require(["sap/m/MessageBox"], (MessageBox) => {
					MessageBox.show("Bad Service Definition", {
						icon: MessageBox.Icon.ERROR,
						title: "Service Call Error",
						actions: [MessageBox.Action.OK],
						styleClass: "sapUiSizeCompact"
					})
				})
			})
		},
		callExcel: function (oEvent) {
			//Excel Download
			window.open("/rest/excel/download/")
			return
		}
	})
})