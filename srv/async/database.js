/*eslint no-console: 0, no-unused-vars: 0, no-undef: 0, no-shadow: 0*/
"use strict"
var hdb = require("@sap/hdbext")
var xsenv = require("@sap/xsenv")
var async = require("async")
var hanaOptions = xsenv.getServices({
	hana: {
		tag: "hana"
	}
})
hanaOptions.hana.pooling = true

module.exports = {
	callHANA: (wss) => {
		hdb.createConnection(hanaOptions.hana, (error, client) => {
			if (error) {
				console.error(error)
			}
			if (client) {
				wss.broadcast("Database Connected")
				client.exec("select TOP 25 * from OPENSAP_PURCHASEORDER_HEADERS",
					(err, res, cb) => {
						if (err) {
							return ("ERROR: " + err)
						}
						wss.broadcast("Database Call Complete")
						for (var i = 0; i < res.length; i++) {
							wss.broadcast(res[i].ID + ": " + res[i].GROSSAMOUNT + "\n")
						}
						client.disconnect((cb) => {
							wss.broadcast("Database Disconnected")
							//	pool.release(client);
						})
						return null
					})
			} //End if client
		}) //end create connection      
		cb()
	}, //end callHANA

	callHANA1: (cb, wss) => {
		hdb.createConnection(hanaOptions.hana, (error, client) => {
			if (error) {
				console.error(error)
			}
			if (client) {

				async.waterfall([

					function execute(callback) {
						wss.broadcast("Database Connected #1");
						client.exec("select TOP 25 * from OPENSAP_PURCHASEORDER_HEADERS",
							(err, res) => {
								if (err) {
									return ("ERROR: " + err)
								}
								callback(null, err, res)
								return null
							})
						return null
					},

					function processResults(err, res, callback) {
						if (err) {
							return ("ERROR: " + err)
						}
						wss.broadcast("Database Call  #1")
						wss.broadcast("--PO Header")
						for (var i = 0; i < res.length; i++) {
							wss.broadcast(res[i].ID + ": " + res[i].GROSSAMOUNT)
						}
						wss.broadcast("\n")
						client.disconnect()
						wss.broadcast("Database Disconnected #1")
						wss.broadcast("End Waterfall #1")
						//pool.release(client);
						cb()
						return null
					},

					function disconnectDone(callback) {
						wss.broadcast("Database Disconnected #1")
						wss.broadcast("End Waterfall #1")
						//	pool.release(client);
						cb()
					}

				], (err, result) => {
					wss.broadcast(err || "done")
					wss.broadcast("Error Occured disrupting flow of Waterfall for #1")
					//	pool.release(client);
					cb()
				}) //end Waterfall

			} //end if client
		}) //end create connection

	}, //end callHANA1

	callHANA2: (cb, wss) => {

		hdb.createConnection(hanaOptions.hana, (error, client) => {
			if (error) {
				console.error(error)
			}
			if (client) {

				async.waterfall([

					function execute(callback) {
						wss.broadcast("Database Connected #2")
						client.exec("select TOP 25 * from OPENSAP_PURCHASEORDER_ITEMS",
							(err, res) => {
								if (err) {
									return ("ERROR: " + err)
								}
								callback(null, err, res)
								return null
							})
					},

					function processResults(err, res, callback) {
						if (err) {
							return ("ERROR: " + err)
						}
						wss.broadcast("Database Call  #2")
						wss.broadcast("--PO Items")
						for (var i = 0; i < res.length; i++) {
							wss.broadcast(res[i]["POHEADER_ID"] + ": " + res[i]["PRODUCT_PRODUCTID"])
						}
						wss.broadcast("\n")
						client.disconnect()
						wss.broadcast("Database Disconnected #2")
						wss.broadcast("End Waterfall #2")
						//	pool.release(client);
						cb()
						return null
					},

					function disconnectDone(callback) {
						wss.broadcast("Database Disconnected #2")
						wss.broadcast("End Waterfall #2")
						//	pool.release(client);
						cb()
					}

				],  (err, result) => {
					wss.broadcast(err || "done")
					wss.broadcast("Error Occured disrupting flow of Waterfall for #2")
					//	pool.release(client);
					cb()
				}) //end Waterfall
			} //end if client
		}) //end create connection

	} //end callHANA2
}