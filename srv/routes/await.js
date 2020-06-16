/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0, dot-notation:0, no-use-before-define:0 */
/*eslint-env node, es6 */

//Promises Examples re-done in Node.js Version 8 Async/Await feature
"use strict";
module.exports = function(app) {

	const util = require("util")
	const readFilePromisified = util.promisify(require("fs").readFile)
	class promisedDB {
		constructor(client) {
			this.client = client
			this.client.promisePrepare = util.promisify(this.client.prepare)
		}

		preparePromisified(query) {
			return this.client.promisePrepare(query)
		}

		statementExecPromisified(statement, parameters) {
			statement.promiseExec = util.promisify(statement.exec)
			return statement.promiseExec(parameters)
		}

		loadProcedurePromisified(hdbext, schema, procedure) {
			hdbext.promiseLoadProcedure = util.promisify(hdbext.loadProcedure)
			return hdbext.promiseLoadProcedure(this.client, schema, procedure)
		}

		callProcedurePromisified(storedProc, inputParams) {
			return new Promise((resolve, reject) => {
				storedProc(inputParams, (error, outputScalar, ...results) => {
					if (error) {
						reject(error)
					} else {
						if (results.length < 2) {
							resolve({
								outputScalar: outputScalar,
								results: results[0]
							})
						} else {
							let output = {};
							output.outputScalar = outputScalar;
							for (let i = 0; i < results.length; i++) {
								output[`results${i}`] = results[i]
							}
							resolve(output)
						}
					}
				})
			})
		}
	}

	//Hello Router
	app.get("/rest/await", (req, res) => {
		var output =
			`<H1>Async/Await - Better Promises</H1></br>
			<a href="./await">/await</a> - Await readFile</br>
			<a href="./awaitError">/awaitError</a> - await readFile and catch error</br> 
			<a href="./awaitDB1">/awaitDB1</a> - Simple HANA DB Select via Await</br>
			<a href="./awaitDB2">/awaitDB2</a> - Simple Database Call Stored Procedure via Await</br>` +
			require(global.__base + "utils/exampleTOC").fill()
		return res.type("text/html").status(200).send(output)
	})

	/**
	 * @swagger
	 *
	 * /rest/await/await:
	 *   get:
	 *     summary: Await readFile
	 *     tags:
	 *       - await
	 *     responses:
	 *       '200':
	 *         description: await info
	 */
	app.get("/rest/await/await", async(req, res) => {
		try {
			const text = await readFilePromisified(global.__base + "async/file.txt")
			return res.type("text/html").status(200).send(text)
		} catch (e) {
			app.logger.error(e)
			return res.type("text/html").status(200).send(e.toString())
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/await/awaitError:
	 *   get:
	 *     summary: Await readFile and catch error
	 *     tags:
	 *       - await
	 *     responses:
	 *       '200':
	 *         description: await info
	 */
	app.get("/rest/await/awaitError", async(req, res) => {
		try {
			const text = await readFilePromisified(global.__base + "async/missing.txt")
			return res.type("text/html").status(200).send(text)
		} catch (e) {
			return res.type("text/html").status(200).send(e.toString())
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/await/awaitDB1:
	 *   get:
	 *     summary: Simple Database Select Await
	 *     tags:
	 *       - await
	 *     responses:
	 *       '200':
	 *         description: await info
	 */
	app.get("/rest/await/awaitDB1", async(req, res) => {
		try {
			let db = new promisedDB(req.db)
			const statement = await db.preparePromisified("select SESSION_USER from \"DUMMY\"")
			const results = await db.statementExecPromisified(statement, [])
			let result = JSON.stringify({
				Objects: results
			})
			return res.type("application/json").status(200).send(result)
		} catch (e) {
			return res.type("text/plain").status(500).send(`ERROR: ${e.toString()}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/await/awaitDB2:
	 *   get:
	 *     summary: Simple Database Call Stored Procedure via Await
	 *     tags:
	 *       - await
	 *     responses:
	 *       '200':
	 *         description: await info
	 */
	app.get("/rest/await/awaitDB2", async(req, res) => {
		try {
			let db = new promisedDB(req.db)
			let hdbext = require("@sap/hdbext")
			const sp = await db.loadProcedurePromisified(hdbext, null, "get_po_header_data")
			const output = await db.callProcedurePromisified(sp, {})
			let result = JSON.stringify({
				EX_TOP_3_EMP_PO_COMBINED_CNT: output.results
			});
			return res.type("application/json").status(200).send(result)
		} catch (e) {
			return res.type("text/plain").status(500).send(`ERROR: ${e.toString()}`)
		}
	})

	return app
}