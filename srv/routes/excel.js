/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, dot-notation: 0, new-cap: 0*/
/*eslint-env node, es6 */
"use strict"
var excel = require("node-xlsx")
var fs = require("fs")
var path = require("path")

module.exports = function (app) {

	app.get("/rest/excel", (req, res) => {
		var output =
			`<H1>Excel Examples</H1></br>
			<a href="./download">/download</a> - Download data in Excel XLSX format</br>`
		res.type("text/html").status(200).send(output)
	});

	/**
	 * @swagger
	 *
	 * /rest/excel/download:
	 *   get:
	 *     summary: Export PO Items in Excel
	 *     tags:
	 *       - excel 
	 *     responses:
	 *       '200':
	 *         description: Contents of PO Items in Excel
	 *         content:
	 *           application/vnd.ms-excel:
	 *             schema:
	 *               type: string
	 *               format: binary
	 *       '500':
	 *         description: General DB Error 
	 */
	app.get("/rest/excel/download", async (req, res) => {
		try {
			const dbClass = require("sap-hdbext-promisfied")
			let client = new dbClass(req.db)
			const statement = await client.preparePromisified(
				`SELECT TOP 10 POHEADER_ID as "ID",  
							    PRODUCT_PRODUCTID as "PRODUCT", 
								GROSSAMOUNT as "AMOUNT" 
								FROM OPENSAP_PURCHASEORDER_ITEMS`
			)
			const results = await client.statementExecPromisified(statement, [])
			let out = []
			for (let item of results) {
				out.push([item.ID, item.PRODUCT, item.AMOUNT])
			}
			var result = excel.build([{
				name: "Purchase Orders",
				data: out
			}])
			res.header("Content-Disposition", "attachment; filename=Excel.xlsx")
			return res.type("application/vnd.ms-excel").status(200).send(result)
		} catch (e) {
			return res.type("text/plain").status(500).send(`ERROR: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/excel/upload:
	 *   post:
	 *     summary: Upload Excel File and parse 
	 *     tags:
	 *       - excel
	 *     requestBody:
	 *       description: Excel File
	 *       required: true
	 *       content:
	 *         application/octet-stream:
	 *           schema:
	 *             type: string
	 *             format: binary
	 *     responses:
	 *       '201':
	 *         description: All data uploaded sucessfully
	 *       '500':
	 *         description: General Error 
	 */
	let bodyParser = require('body-parser')
	var excelParser = bodyParser.raw({
		type: 'application/octet-stream'
	})
	app.post('/rest/excel/upload', excelParser, async (req, res) => {
		try {
			const workSheetsFromBuffer = excel.parse(req.body)
			console.log(workSheetsFromBuffer)
			return res.status(201).end(`All Data Imported: ${JSON.stringify(workSheetsFromBuffer)}`)
		} catch (err) {
			return res.type("text/plain").status(500).send(`ERROR: ${JSON.stringify(err)}`)
		}
	})

	return app
}