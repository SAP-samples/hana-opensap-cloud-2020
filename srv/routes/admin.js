/*eslint no-undef: 0 */
'use strict';
module.exports = function (app) {

	/**
	 * @swagger
	 *
	 * /admin:
	 *   get:
	 *     summary: Test Admin Endpoint
	 *     tags:
	 *       - Admin
	 *     responses:
	 *       '200':
	 *         description: Admin Features
	 */
	app.get('/admin', function (req, res) {
		if (req.authInfo !== undefined && req.authInfo.checkLocalScope("Admin")) {
			return res.send('Admin Features')
		} else {
			return res.type("text/plain").status(401).send(`ERROR: Not Authorized. Missing Admin scope`)
		}
    })
    
	/**
	 * @swagger
	 *
	 * components:
	 *   schemas:
	 *     Table:
	 *       type: object
	 *       properties:
	 *         TABLE_NAME:
	 *           type: string
	 */

	/**
	 * @swagger
	 *
	 * /admin/tables:
	 *   get:
	 *     summary: Get a list of all tables in the local container Schema
	 *     tags:
	 *       - Admin 
	 *     responses:
	 *       '200':
	 *         description: A List of all tables
	 *         content:
	 *           application/json: 
	 *             schema:
	 *               type: array
	 *               items:
	 *                 $ref: '#/components/schemas/Table'
	 *       '401':
	 *         description: ERROR Not Authorized. Missing Admin scope 
	 *       '500':
	 *         description: General DB Error 
	 */
	app.get("/admin/tables", async (req, res) => {
		if (req.authInfo !== undefined && req.authInfo.checkLocalScope("Admin")) {
			try {
				const dbClass = require("sap-hdbext-promisfied")
				let dbConn = new dbClass(req.db)
				const statement = await dbConn.preparePromisified(
					`SELECT TABLE_NAME FROM M_TABLES 
				  WHERE SCHEMA_NAME = CURRENT_SCHEMA 
				    AND RECORD_COUNT > 0 `
				)
				const results = await dbConn.statementExecPromisified(statement, [])
				return res.type("application/json").status(200).send(JSON.stringify(results))
			} catch (err) {
				return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
			}
		} else {
			return res.type("text/plain").status(401).send(`ERROR: Not Authorized. Missing Admin scope`)
		}
	});

	/**
	 * @swagger
	 *
	 * /admin/export:
	 *   get:
	 *     summary: Export all table content as JSON in a ZIP file
	 *     tags:
	 *       - Admin 
	 *     responses:
	 *       '200':
	 *         description: Contents of all tables as JSON in a ZIP file
	 *         content:
	 *           application/zip:
	 *             schema:
	 *               type: string
	 *               format: binary
	 *       '401':
	 *         description: ERROR Not Authorized. Missing Admin scope 
	 *       '500':
	 *         description: General DB Error 
	 */
	app.get("/admin/export", async (req, res) => {
		if (req.authInfo !== undefined && req.authInfo.checkLocalScope("Admin")) {
			try {
				const dbClass = require("sap-hdbext-promisfied")
				let dbConn = new dbClass(req.db)
				const statement = await dbConn.preparePromisified(
					`SELECT TABLE_NAME FROM M_TABLES 
				  WHERE SCHEMA_NAME = CURRENT_SCHEMA 
				    AND RECORD_COUNT > 0 `
				)
				const results = await dbConn.statementExecPromisified(statement, [])
				let zip = new require("node-zip")();
				for (let result of results) {
					const statementMain = await dbConn.preparePromisified(`SELECT * FROM ${result.TABLE_NAME} `)
					const resultsMain = await dbConn.statementExecPromisified(statementMain, [])
					zip.file(`${result.TABLE_NAME}.json`, JSON.stringify(resultsMain))
				}
				let data = zip.generate({
					base64: false,
					compression: "DEFLATE"
				});
				res.header("Content-Disposition", "attachment; filename=TeamTaskExport.zip");
				return res.type("application/zip").status(200).send(Buffer.from(data, "binary"));
			} catch (err) {
				return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
			}
		} else {
			return res.type("text/plain").status(401).send(`ERROR: Not Authorized. Missing Admin scope`)
		}
	});

	/**
	 * @swagger
	 *
	 * /admin/import:
	 *   post:
	 *     summary: Import all table content as JSON in a ZIP file
	 *     tags:
	 *       - Admin
	 *     requestBody:
	 *       description: Uploaded zip file with tables as JSON
	 *       required: true
	 *       content:
	 *         application/octet-stream:
	 *           schema:
	 *             type: string
	 *             format: binary
	 *     responses:
	 *       '201':
	 *         description: All data uploaded sucessfully
	 *       '401':
	 *         description: ERROR Not Authorized. Missing Admin scope 
	 *       '500':
	 *         description: General DB Error 
	 */
	let bodyParser = require('body-parser')
	var zipParser = bodyParser.raw({
		type: 'application/zip'
	})
	app.post('/admin/import', zipParser, async (req, res) => {
		if (req.authInfo !== undefined && req.authInfo.checkLocalScope("Admin")) {
			try {
				let zip = new require('node-zip')(req.body, {
					base64: false,
					checkCRC32: true
				});
				const cds = require("@sap/cds")
				const srv = await cds.connect.to('db')

				const dbClass = require("sap-hdbext-promisfied")
				let dbConn = new dbClass(req.db)
				const statement = await dbConn.preparePromisified(
					`SELECT TABLE_NAME FROM M_TABLES 
				  WHERE SCHEMA_NAME = CURRENT_SCHEMA `
				)
				const results = await dbConn.statementExecPromisified(statement, [])
				for (let result of results) {
					if (zip.files[`${result.TABLE_NAME}.json`] !== undefined) {
						let inputData = JSON.parse(zip.files[`${result.TABLE_NAME}.json`]._data)
						const deleteStatement = await dbConn.preparePromisified(`DELETE FROM ${result.TABLE_NAME} `)
						await dbConn.statementExecPromisified(deleteStatement, [])
						await srv.run(INSERT.into(result.TABLE_NAME).entries(inputData))
					}
				}
				res.status(201).end(`All tables imported`)
			} catch (err) {
				return res.type("text/plain").status(500).send(`ERROR: ${JSON.stringify(err)}`)
			}

		} else {
			return res.type("text/plain").status(401).send(`ERROR: Not Authorized. Missing Admin scope`)
		}
	})

};