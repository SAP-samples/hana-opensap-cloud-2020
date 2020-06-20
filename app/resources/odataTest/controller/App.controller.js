/*eslint no-console: 0, no-unused-vars: 0, no-use-before-define: 0, no-redeclare: 0, no-undef: 0*/
/*eslint-env es6 */
//To use a javascript controller its name must end with .controller.js
sap.ui.define([
	"sap/openSAP/odataTest/controller/BaseController",
	"sap/ui/model/json/JSONModel"
], function (BaseController, JSONModel) {
	"use strict";

	return BaseController.extend("sap.openSAP.odataTest.controller.App", {

		onInit: function () {

			var oConfig = this.getOwnerComponent().getModel("config");
			var userName = oConfig.getProperty("/UserName");
			var userModel = this.getOwnerComponent().getModel("userModel");
			var oTable = this.getView().byId("userTable");
			oTable.setModel(userModel);

			var urlMulti = "/odata/v2/POService/";
			var urlSimple = "/odata/v2/MasterDataService/";
			this.getOwnerComponent().getModel().setProperty("/mPath", urlMulti);
			this.getOwnerComponent().getModel().setProperty("/sPath", urlSimple);
			this.getOwnerComponent().getModel().setProperty("/mEntity1", "POs");
			this.getOwnerComponent().getModel().setProperty("/mEntity2", "POItems");
			this.getOwnerComponent().getModel().setProperty("/sEntity1", "BusinessPartners");
		},
		callMultiService: function () {
			var oTable = this.getView().byId("tblPOHeader");
			var oTableItem = this.getView().byId("tblPOItem");

			var mPath = this.getOwnerComponent().getModel().getProperty("/mPath");
			var mEntity1 = this.getOwnerComponent().getModel().getProperty("/mEntity1");
			var mEntity2 = this.getOwnerComponent().getModel().getProperty("/mEntity2");

			var oParams = {};
			oParams.json = true;
			oParams.useBatch = true;
			var oModel = new sap.ui.model.odata.v2.ODataModel(mPath, oParams);
			oModel.attachEvent("requestFailed", oDataFailed);

			function fnLoadMetadata() {
				oTable.setModel(oModel);
				oTable.setEntitySet(mEntity1);
				oTableItem.setModel(oModel);
				oTableItem.setEntitySet(mEntity2);
				var oMeta = oModel.getServiceMetadata();
				var headerFields = "";
				var itemFields = "";
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
				oTable.setInitiallyVisibleFields(headerFields);
				oTableItem.setInitiallyVisibleFields(itemFields);
			}

			oModel.attachMetadataLoaded(oModel, function () {
				fnLoadMetadata();
			});

			oModel.attachMetadataFailed(oModel, function () {
				oDataFailed();
			});
		},

		callSingleService: function () {
			var oTable = this.getView().byId("tblBPHeader");

			var sPath = this.getOwnerComponent().getModel().getProperty("/sPath");
			var sEntity1 = this.getOwnerComponent().getModel().getProperty("/sEntity1");

			var oParams = {};
			oParams.json = true;
			oParams.useBatch = true;
			var oModel = new sap.ui.model.odata.v2.ODataModel(sPath, oParams);
			oModel.attachEvent("requestFailed", oDataFailed);

			function fnLoadMetadata() {
				oTable.setModel(oModel);
				oTable.setEntitySet(sEntity1);

				var oMeta = oModel.getServiceMetadata();
				var headerFields = "";
				for (let entity of oMeta.dataServices.schema[0].entityType){
					if(entity.name == sEntity1){
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

			oModel.attachMetadataFailed(oModel, function () {
				oDataFailed();
			});
		},

		callExcel: function (oEvent) {
			//Excel Download
			window.open("/rest/excel/download/");
			return;
		},

		callUserService: function () {
			var oModel = this.getOwnerComponent().getModel("userModel");
			var result = this.getView().getModel().getData();
			var oEntry = {};
			//oEntry.UserId = "0000000000";
			oEntry.FIRSTNAME = result.FIRSTNAME;
			oEntry.LASTNAME = result.LASTNAME;
			oEntry.EMAIL = result.EMAIL;

			var mParams = {};
			mParams.success = function () {
				sap.ui.require(["sap/m/MessageToast"], (MessageToast) => {
					MessageToast.show("Create successful");
				});

			};
			mParams.error = onODataError;
			oModel.create("/User", oEntry, mParams);
		},

		callUserUpdate: function () {
			var oModel = this.getOwnerComponent().getModel("userModel");
			var mParams = {};
			mParams.error = onODataError;

			mParams.success = function () {
				sap.ui.require(["sap/m/MessageToast"], (MessageToast) => {
					MessageToast.show("Update successful");
				});
			};
			oModel.submitChanges(mParams);
		}
	});
});