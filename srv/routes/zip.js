/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, dot-notation: 0, new-cap: 0*/
/*eslint-env node, es6 */
"use strict"

module.exports = function(app) {

	app.get("/rest/zip", (req, res) => {
		var output =
			`<H1>ZIP Examples</H1></br> 
			<a href="./example1">/example1</a> - Download data in ZIP format - folder and files</br>
			<a href="./zipPO">/zipPO</a> - Download Purchase Orders in ZIP format</br>`
		res.type("text/html").status(200).send(output)
	})

	/**
	 * @swagger
	 *
	 * /rest/zip/example1:
	 *   get:
	 *     summary: Manually Assemble content into Zip
	 *     tags:
	 *       - zip 
	 *     responses:
	 *       '200':
	 *         description: Zip File
	 *         content:
	 *           application/zip:
	 *             schema:
	 *               type: string
	 *               format: binary
	 *       '500':
	 *         description: General DB Error 
	 */	
	app.get("/rest/zip/example1", (req, res) => {
		let zip = new require("node-zip")()
		zip.file("folder1/demo1.txt", "This is the new ZIP Processing in Node.js")
		zip.file("demo2.txt", "This is also the new ZIP Processing in Node.js")
		let data = zip.generate({
			base64: false,
			compression: "DEFLATE"
		})
		res.header("Content-Disposition", "attachment; filename=ZipExample.zip")
		return res.type("application/zip").status(200).send(new Buffer(data, "binary"))
	})

	/**
	 * @swagger
	 *
	 * /rest/zip/zipPO:
	 *   get:
	 *     summary: DB query results in Zip
	 *     tags:
	 *       - zip 
	 *     responses:
	 *       '200':
	 *         description: Zip File
	 *         content:
	 *           application/zip:
	 *             schema:
	 *               type: string
	 *               format: binary
	 *       '500':
	 *         description: General DB Error 
	 */	
	app.get("/rest/zip/zipPO", async(req, res) => {
		try {
			const dbClass = require("sap-hdbext-promisfied")
			let client = new dbClass(req.db)
			const statement = await client.preparePromisified(
				`SELECT TOP 25000 PURCHASEORDERID, PARTNERID, COMPANYNAME, CREATEDBYLOGINNAME, CREATEDAT, GROSSAMOUNT 
				   FROM  OPENSAP_PURCHASEORDER_HEADERVIEW ORDER BY PURCHASEORDERID `
			)
			const results = await client.statementExecPromisified(statement, [])
			let out = ""
			for (let item of results) {
				out += item.PURCHASEORDERID + "\t" + item.PARTNERID + "\t" + item.COMPANYNAME + "\t" + item.CREATEDBYLOGINNAME + "\t" + item.CREATEDAT +
					"\t" + item.GROSSAMOUNT + "\n"
			}
			let zip = new require("node-zip")()
			zip.file("po.txt", out)
			let data = zip.generate({
				base64: false,
				compression: "DEFLATE"
			})
			res.header("Content-Disposition", "attachment; filename=poWorklist.zip")
			return res.type("application/zip").status(200).send(new Buffer(data, "binary"))
		} catch (e) {
			return res.type("text/plain").status(500).send(`ERROR: ${e.toString()}`)
		}
	})

	return app
}