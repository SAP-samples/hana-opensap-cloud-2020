/*eslint no-console: 0, no-unused-vars: 0, no-use-before-define: 0, no-redeclare: 0, no-undef: 0*/
/*eslint-env es6 */
//To use a javascript controller its name must end with .controller.js
sap.ui.define([
	"sap/openSAP/odataCreate/controller/BaseController",
	"sap/ui/model/json/JSONModel"
], function (BaseController, JSONModel) {
	"use strict";

	return BaseController.extend("sap.openSAP.odataCreate.controller.App", {

		onInit: function () {

			var oConfig = this.getOwnerComponent().getModel("config");
			var userName = oConfig.getProperty("/UserName");

			var urlMulti = "/odata/v2/POService/";
			this.getOwnerComponent().getModel().setProperty("/mPath", urlMulti);
			this.getOwnerComponent().getModel().setProperty("/mEntity1", "POnoDraft");

		},
		callService: function () {
			var oTable = this.getView().byId("tblPOHeader");

			var mPath = this.getOwnerComponent().getModel().getProperty("/mPath");
			var mEntity1 = this.getOwnerComponent().getModel().getProperty("/mEntity1");

			var oParams = {};
			oParams.json = true;
			oParams.useBatch = false;
			var oModel = new sap.ui.model.odata.v2.ODataModel(mPath, oParams);
			oModel.attachEvent("requestFailed", oDataFailed);

			function fnLoadMetadata() {
				oTable.setModel(oModel);
				oTable.setEntitySet(mEntity1);
				var oMeta = oModel.getServiceMetadata();
				var headerFields = "";
				for (let entity of oMeta.dataServices.schema[0].entityType){
					if(entity.name == mEntity1){
						var headerFields = ""
						for (let property of  entity.property) {
							headerFields += property.name + ","
						}
						oTable.setInitiallyVisibleFields(headerFields)
					}
				}			
			}

			oModel.attachMetadataLoaded(oModel, function () {
				fnLoadMetadata();
			});

			oModel.attachMetadataFailed(oModel, oDataFailed);
		},

		callCreate: function (oEvent) {
			var oTable = this.getView().byId("tblPOHeader");
			var oModel = oTable.getModel();
			var oEntry = {};
			oEntry.partner_ID = '02BD2137-0890-1EEA-A6C2-BB55C19BA7FB'
			oEntry.item = [{}]
			oEntry.item[0].product_productId = "HT-1000"
			oEntry.item[0].currency_code = "EUR"
			oEntry.currency_code = "EUR"		
			oEntry.grossAmount = "1137.64"
			oEntry.item[0].grossAmount = "1137.64"		
			oEntry.netAmount = "956.00"
			oEntry.item[0].netAmount = "956.00"			
			oEntry.taxAmount = "181.64"
			oEntry.item[0].taxAmount = "181.64"			
			oEntry.item[0].quantity = "1.000"
			oEntry.item[0].quantityUnit = "EA"
			oEntry.item[0].deliveryDate = new Date()
			var mParams = {};
			mParams.success = function () {
				sap.ui.require(["sap/m/MessageToast"], (MessageToast) => {
					MessageToast.show("Create successful");
				});
			};
			mParams.error = onODataError;
			var mEntity1 = this.getOwnerComponent().getModel().getProperty("/mEntity1");
			oModel.create("/" + mEntity1, oEntry, mParams);			
		}
	});
});