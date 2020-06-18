/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0*/
/*eslint-env node, es6 */
"use strict"
module.exports = (app) => {

	const bodyParser = require("body-parser")
	app.use("/rest/secureStore", bodyParser.raw({
		type: "text/plain"
	})) //Process request Body and return a Buffer

	function getSecureStore() {
		return new Promise((resolve, reject) => {
			const xsenv = require("@sap/xsenv")
			let hanaOptions = xsenv.getServices({
				secureStore: {
					plan: "securestore"
				}
			})

			var hdbext = require("@sap/hdbext")
			hdbext.createConnection(hanaOptions.secureStore, (error, client) => {
				if (error) {
					reject(error)
				} else {
					resolve(client)
				}
			})
		})
	}

	/**
	 * @swagger
	 *
	 * /rest/secureStore/{key}:
	 *   post:
	 *     summary: Secure Store Insert
	 *     tags:
	 *       - secureStore
	 *     requestBody:
	 *       description: Key Content
	 *       required: true
	 *       content:
	 *         text/plain:
	 *           schema:
	 *             type: string
	 *     parameters:
	 *       - name: key
	 *         in: path
	 *         description: Secure store key 
	 *         required: false
	 *         schema:
	 *           type: string  
	 *     responses:
	 *       '201':
	 *         description: Info
	 */
	app.post("/rest/secureStore/:key?", async (req, res) => {
		const hdbext = require("@sap/hdbext")
		const key = req.params.key
		let inputParams = ""
		if (typeof key === "undefined" || key === null) {
			res.type("text/plain").status(500).send("ERROR: No Secure Store Key Input Parameter Specified")
			return
		} else {
			inputParams = {
				KEY: key
			}
		}
		inputParams.STORE_NAME = "OPENSAP_HANA7_TEST_STORE"
		inputParams.FOR_XS_APPLICATIONUSER = true
		inputParams.VALUE = req.body
		try {
			const client = await getSecureStore()
			//(client, Schema, Procedure, callback)
			hdbext.loadProcedure(client, "SYS", "USER_SECURESTORE_INSERT", (err, sp) => {
				if (err) {
					res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
					return
				}
				//(Input Parameters, callback(errors, Output Scalar Parameters, [Output Table Parameters])
				sp(inputParams, (err, parameters, results) => {
					if (err) {
						res.type("text/plain").status(500).send(`ERROR: ${err.message.toString()}`)
						return
					}
					res.type("application/json").status(201).send(
						`Entry in secure store successsfully created for key: ${key} and value: ${req.body.toString("utf8")} `)
				})
			})
		} catch (error) {
			res.type("text/plain").status(500).send(`ERROR: ${error.message.toString()}`)
			return
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/secureStore/{key}:
	 *   get:
	 *     summary: Secure Store Retrieve
	 *     tags:
	 *       - secureStore
	 *     parameters:
	 *       - name: key
	 *         in: path
	 *         description: Secure store key 
	 *         required: false
	 *         schema:
	 *           type: string  
	 *     responses:
	 *       '200':
	 *         description: Info
	 */
	app.get("/rest/secureStore/:key?", async (req, res) => {
		const hdbext = require("@sap/hdbext")
		const key = req.params.key
		let inputParams = ""
		if (typeof key === "undefined" || key === null) {
			res.type("text/plain").status(500).send("ERROR: No Secure Store Key Input Parameter Specified")
			return
		} else {
			inputParams = {
				KEY: key
			}
		}
		inputParams.STORE_NAME = "OPENSAP_HANA7_TEST_STORE"
		inputParams.FOR_XS_APPLICATIONUSER = true

		try {
			const client = await getSecureStore()
			//(client, Schema, Procedure, callback)
			hdbext.loadProcedure(client, "SYS", "USER_SECURESTORE_RETRIEVE", (err, sp) => {
				if (err) {
					res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
					return
				}
				//(Input Parameters, callback(errors, Output Scalar Parameters, [Output Table Parameters])
				sp(inputParams, (err, parameters, results) => {
					if (err) {
						res.type("text/plain").status(500).send(`ERROR: ${err.message.toString()}`)
						return
					}
					app.logger.info(`Results: ${parameters.VALUE.toString("utf8")} `)
					res.type("application/json").status(200).send(`Entry in secure store successsfully retrieved for key: ${key} and value: ${parameters.VALUE.toString("utf8")} `)
				})
			})
		} catch (error) {
			res.type("text/plain").status(500).send(`ERROR: ${error.message.toString()}`)
			return
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/secureStore/{key}:
	 *   delete:
	 *     summary: Secure Store Delete
	 *     tags:
	 *       - secureStore
	 *     parameters:
	 *       - name: key
	 *         in: path
	 *         description: Secure store key 
	 *         required: false
	 *         schema:
	 *           type: string  
	 *     responses:
	 *       '200':
	 *         description: Info
	 */
	app.delete("/rest/secureStore/:key?", async (req, res) => {
		const hdbext = require("@sap/hdbext")
		const key = req.params.key
		let inputParams = ""
		if (typeof key === "undefined" || key === null) {
			res.type("text/plain").status(500).send("ERROR: No Secure Store Key Input Parameter Specified")
			return
		} else {
			inputParams = {
				KEY: key
			}
		}
		inputParams.STORE_NAME = "OPENSAP_HANA7_TEST_STORE"
		inputParams.FOR_XS_APPLICATIONUSER = true
		try {
			const client = await getSecureStore()
			//(client, Schema, Procedure, callback)
			hdbext.loadProcedure(client, "SYS", "USER_SECURESTORE_DELETE", (err, sp) => {
				if (err) {
					res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
					return
				}
				//(Input Parameters, callback(errors, Output Scalar Parameters, [Output Table Parameters])
				sp(inputParams, (err, parameters, results) => {
					if (err) {
						res.type("text/plain").status(500).send(`ERROR: ${err.message.toString()}`)
						return
					}
					res.type("application/json").status(200).send(`Entry in secure store successsfully deleted for key: ${key} `)
				})
			})
		} catch (error) {
			res.type("text/plain").status(500).send(`ERROR: ${error.message.toString()}`)
			return
		}
	})
	return app
}