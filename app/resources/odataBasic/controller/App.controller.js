/*eslint no-console: 0, no-unused-vars: 0, no-use-before-define: 0, no-redeclare: 0, no-undef: 0*/
/*eslint-env es6 */
//To use a javascript controller its name must end with .controller.js
sap.ui.define([
	"sap/openSAP/odataBasic/controller/BaseController",
	"sap/ui/model/json/JSONModel"
], function (BaseController, JSONModel) {
	"use strict"

	return BaseController.extend("sap.openSAP.odataBasic.controller.App", {

		onInit: function () {
			this.getView().addStyleClass("sapUiSizeCompact") // make everything inside this View appear in Compact mode
			var oConfig = this.getOwnerComponent().getModel("config")
			var userName = oConfig.getProperty("/UserName")
			var bpModel = this.getOwnerComponent().getModel("bpModel")
			var oTable = this.getView().byId("bpTable")
			//  oTable.setModel(bpModel)
			//	oTable.setEntitySet("BusinessPartners")
			//	oTable.setInitiallyVisibleFields("ID,companyName,partnerRole")

			//Instead of hardcoding the visible fields as in the previous exercise,
			//lets use the $metadata information from the serivce to expose all the fields for this entity
			function fnLoadMetadata() {
				try {
					oTable.setModel(bpModel)
					oTable.setEntitySet("BusinessPartners")
					var oMeta = bpModel.getServiceMetadata()
					for (let entity of oMeta.dataServices.schema[0].entityType){
						if(entity.name == "BusinessPartners"){
							var headerFields = ""
							for (let property of  entity.property) {
								headerFields += property.name + ","
							}
							oTable.setInitiallyVisibleFields(headerFields)
						}
					}
				} catch (e) {
					console.log(e.toString())
					oDataFailed()
				}
			}
			bpModel.attachMetadataLoaded(bpModel, function () {
				fnLoadMetadata()
			})
			fnLoadMetadata()
		}
	})
})