/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0*/
"use strict"

module.exports = (app) => {

	app.get("/rest/ex2/toc", (req, res) => {
		let output =
			`<H1>Exercise #2</H1></br>
			<a href="../">/</a> - HANA DB Client</br>
			<a href="../express">/express</a> - Simple Database Select Via Client Wrapper/Middelware - In-line Callbacks</br>
			<a href="../waterfall">/waterfall</a> - Simple Database Select Via Client Wrapper/Middelware - Async Waterfall</br>	
			<a href="../promises">/promises</a> - Simple Database Select Via Client Wrapper/Middelware - Promises</br>	
			<a href="../await">/await</a> - Simple Database Select Via Client Wrapper/Middelware - Await</br>	
			<a href="../procedures">/procedures</a> - Simple Database Call Stored Procedure</br>		
			<a href="../procedures2">/procedures2</a> - Database Call Stored Procedure With Inputs</br>		
			<a href="../proceduresParallel">/proceduresParallel</a> - Call 2 Database Stored Procedures in Parallel</br>	
			<a href="../whoAmI">/whoAmI</a> - Current User Info</br>	
			<a href="../env">/env</a> - Environment Info</br>
			<a href="../cfApi">/cfApi</a> - Current Cloud Foundry API</br>	
			<a href="../space">/space</a> - Current Space</br>
			<a href="../hdb">/hdb</a> - HANA DB Query</br>	
			<a href="../tables">/tables</a> - All Local Tables</br>	
			<a href="../views">/views</a> - All Local Views</br>				
			<a href="../os">/os</a> - OS Info</br>	
			<a href="../osUser">/osUser</a> - OS User</br>` +			
			require(global.__base + "utils/exampleTOC").fill()
		res.type("text/html").status(200).send(output)
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2:
	 *   get:
	 *     summary: DB Example with Callbacks and the hana-client
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2", (req, res) => {
		let hanaClient = require("@sap/hana-client")
		//Lookup HANA DB Connection from Bound HDB Container Service
		const xsenv = require("@sap/xsenv")
		let hanaOptions = xsenv.getServices({
			hana: {
				tag: "hana"
			}
		})
		//Create DB connection with options from the bound service
		var connParams = {
			serverNode: hanaOptions.hana.host + ":" + hanaOptions.hana.port,
			uid: hanaOptions.hana.user,
			pwd: hanaOptions.hana.password,
			CURRENTSCHEMA: hanaOptions.hana.schema,
			ca: hanaOptions.hana.certificate
		}
		let client = hanaClient.createClient(connParams)
		//connect
		client.connect((err) => {
			if (err) {
				return res.type("text/plain").status(500).send(`ERROR: ${JSON.stringify(err)}`)
			} else {
				client.exec(`SELECT SESSION_USER, CURRENT_SCHEMA 
				             FROM "DUMMY"`, (err, result) => {
					if (err) {
						return res.type("text/plain").status(500).send(`ERROR: ${JSON.stringify(err)}`)
					} else {
						client.disconnect()
						return res.type("application/json").status(200).send(result)
					}
				})
			}
			return null
		})
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2/express:
	 *   get:
	 *     summary: Simple Database Select Via Client Wrapper/Middelware - In-line Callbacks
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/express", (req, res) => {
		let client = req.db
		client.prepare(
			`SELECT SESSION_USER, CURRENT_SCHEMA 
				             FROM "DUMMY"`,
			(err, statement) => {
				if (err) {
					return res.type("text/plain").status(500).send("ERROR: " + err.toString())
				}
				statement.exec([],
					(err, results) => {
						if (err) {
							return res.type("text/plain").status(500).send("ERROR: " + err.toString())
						} else {
							var result = JSON.stringify({
								Objects: results
							});
							return res.type("application/json").status(200).send(result)
						}
					})
				return null
			})
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/waterfall:
	 *   get:
	 *     summary: Simple Database Select Via Client Wrapper/Middelware - Async Waterfall
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	var async = require("async")
	app.get("/rest/ex2/waterfall", (req, res) => {
		let client = req.db
		async.waterfall([
			function prepare(callback) {
				client.prepare(`SELECT SESSION_USER, CURRENT_SCHEMA 
				            	  FROM "DUMMY"`,
					(err, statement) => {
						callback(null, err, statement)
					})
			},

			function execute(err, statement, callback) {
				statement.exec([], (execErr, results) => {
					callback(null, execErr, results)
				})
			},
			function response(err, results, callback) {
				if (err) {
					res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
				} else {
					var result = JSON.stringify({
						Objects: results
					})
					res.type("application/json").status(200).send(result)
				}
				return callback()
			}
		])
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2/promises:
	 *   get:
	 *     summary: Simple Database Select Via Client Wrapper/Middelware - Promises
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/promises", (req, res) => {
		const dbClass = require("sap-hdbext-promisfied")
		let db = new dbClass(req.db)
		db.preparePromisified(`SELECT SESSION_USER, CURRENT_SCHEMA 
				            	 FROM "DUMMY"`)
			.then(statement => {
				db.statementExecPromisified(statement, [])
					.then(results => {
						let result = JSON.stringify({
							Objects: results
						});
						return res.type("application/json").status(200).send(result)
					})
					.catch(err => {
						return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
					})
			})
			.catch(err => {
				return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
			})
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2/await:
	 *   get:
	 *     summary: Simple Database Select Via Client Wrapper/Middelware - Await
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/await", async(req, res) => {
		try {
			const dbClass = require("sap-hdbext-promisfied")
			let db = new dbClass(req.db)
			const statement = await db.preparePromisified(`SELECT SESSION_USER, CURRENT_SCHEMA 
				            								 FROM "DUMMY"`)
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
	 * /rest/ex2/procedures:
	 *   get:
	 *     summary: Simple Database Call Stored Procedure
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/procedures", (req, res) => {
		var client = req.db
		var hdbext = require("@sap/hdbext")
		//(client, Schema, Procedure, callback)
		hdbext.loadProcedure(client, null, "get_po_header_data", (err, sp) => {
			if (err) {
				res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
				return
			}
			//(Input Parameters, callback(errors, Output Scalar Parameters, [Output Table Parameters]))
			sp({}, (err, parameters, results) => {
				if (err) {
					res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
				}
				var result = JSON.stringify({
					EX_TOP_3_EMP_PO_COMBINED_CNT: results
				})
				res.type("application/json").status(200).send(result)
			})
		})
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/procedures2/{partnerRole}:
	 *   get:
	 *     summary: Database Call Stored Procedure With Inputs
	 *     tags:
	 *       - exercises
	 *     parameters:
	 *       - name: partnerRole
	 *         in: path
	 *         description: Parnter Role 
	 *         required: false
	 *         schema:
	 *           type: integer  
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/procedures2/:partnerRole?", (req, res) => {
		var client = req.db
		var hdbext = require("@sap/hdbext")
		var partnerRole = req.params.partnerRole
		var inputParams = ""
		if (typeof partnerRole === "undefined" || partnerRole === null) {
			inputParams = {}
		} else {
			inputParams = {
				IM_PARTNERROLE: parseInt(partnerRole)
			}
		}
		//(cleint, Schema, Procedure, callback)
		hdbext.loadProcedure(client, null, "get_bp_addresses_by_role", (err, sp) => {
			if (err) {
				res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
				return
			}
			//(Input Parameters, callback(errors, Output Scalar Parameters, [Output Table Parameters])
			sp(inputParams, (err, parameters, results) => {
				if (err) {
					res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
				}
				var result = JSON.stringify({
					EX_BP_ADDRESSES: results
				})
				res.type("application/json").status(200).send(result)
			})
		})
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/proceduresParallel:
	 *   get:
	 *     summary: Call 2 Database Stored Procedures in Parallel
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/proceduresParallel/", (req, res) => {
		var client = req.db
		var hdbext = require("@sap/hdbext")
		var inputParams = {
			IM_PARTNERROLE: 1
		}
		var result = {}
		async.parallel([

			function(cb) {
				hdbext.loadProcedure(client, null, "get_po_header_data", (err, sp) => {
					if (err) {
						cb(err)
						return
					}
					//(Input Parameters, callback(errors, Output Scalar Parameters, [Output Table Parameters])
					sp(inputParams, (err, parameters, results) => {
						result.EX_TOP_3_EMP_PO_COMBINED_CNT = results
						cb()
					})
				})
			},
			function(cb) {
				//(client, Schema, Procedure, callback)            		
				hdbext.loadProcedure(client, null, "get_bp_addresses_by_role", (err, sp) => {
					if (err) {
						cb(err)
						return
					}
					//(Input Parameters, callback(errors, Output Scalar Parameters, [Output Table Parameters])
					sp(inputParams, (err, parameters, results) => {
						result.EX_BP_ADDRESSES = results
						cb()
					})
				})
			}
		], (err) => {
			if (err) {
				res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
			} else {
				res.type("application/json").status(200).send(JSON.stringify(result))
			}
		})
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/whoAmI:
	 *   get:
	 *     summary: User Context Information
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/ex2/whoAmI", (req, res) => {
		function mapSecurityContext(context) {
			let output = {}
			output.user = {}
			output.user.logonName = context.getLogonName()
			output.user.givenName = context.getGivenName()
			output.user.familyName = context.getFamilyName()
			output.user.email = context.getEmail()
			output.user.userName = context.getUserName() 
			output.grantType = context.getGrantType()
			output.uniquePrincipalName = context.getUniquePrincipalName()
			output.origin = context.getOrigin()
			output.appToken = context.getAppToken()
			output.hdbToken = context.getHdbToken()
			output.isInForeignMode = context.isInForeignMode()
			output.subdomain = context.getSubdomain()
			output.clientId = context.getClientId()
			output.subaccountId = context.getSubaccountId()
			output.expirationDate = context.getExpirationDate()
			output.cloneServiceInstanceId = context.getCloneServiceInstanceId()
			return output
		}
		let userContext = req.authInfo
		let result = JSON.stringify({
			userContext: mapSecurityContext(userContext)
		})
		res.type("application/json").status(200).send(result)
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/env:
	 *   get:
	 *     summary: Process Environment
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/env", (req, res) => {
		return res.type("application/json").status(200).send(JSON.stringify(process.env))
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2/cfApi:
	 *   get:
	 *     summary: VCAP CF API Endpoint
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	    
	app.get("/rest/ex2/cfApi", (req, res) => {
		let VCAP = JSON.parse(process.env.VCAP_APPLICATION);
		return res.type("application/json").status(200).send(JSON.stringify(VCAP.cf_api))
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/space:
	 *   get:
	 *     summary: VCAP Space
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/space", (req, res) => {
		let VCAP = JSON.parse(process.env.VCAP_APPLICATION)
		return res.type("application/json").status(200).send(JSON.stringify(VCAP.space_name))
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/hdb:
	 *   get:
	 *     summary: VCAP Select from CAP Generated View
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/hdb", async(req, res) => {
		try {
			const dbClass = require("sap-hdbext-promisfied")
			let dbConn = new dbClass(req.db)
			const statement = await dbConn.preparePromisified(
				`SELECT PRODUCTID as "ProductID", 
						AMOUNT as "Amount" 
				 FROM OPENSAP_PURCHASEORDER_ITEMVIEW `
			)
			const results = await dbConn.statementExecPromisified(statement, [])
			let result = JSON.stringify({
				PurchaseOrders: results
			})
			return res.type("application/json").status(200).send(result)
		} catch (err) {
			return res.type("text/plain").status(500).send(`ERROR: ${JSON.stringify(err)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/ex2/tables:
	 *   get:
	 *     summary: List all Tables in Current Schema
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/ex2/tables", async(req, res) => {
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
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2/views:
	 *   get:
	 *     summary: List all Views in Current Schema
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/ex2/views", async(req, res) => {
		try {
			const dbClass = require("sap-hdbext-promisfied")
			let dbConn = new dbClass(req.db)
			const statement = await dbConn.preparePromisified(
				`SELECT VIEW_NAME FROM VIEWS 
				  WHERE SCHEMA_NAME = CURRENT_SCHEMA 
				    AND (VIEW_TYPE = 'ROW' or VIEW_TYPE = 'CALC')`
			)
			const results = await dbConn.statementExecPromisified(statement, [])
			return res.type("application/json").status(200).send(JSON.stringify(results))
		} catch (err) {
			return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
		}
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2/os:
	 *   get:
	 *     summary: Simple call to the Operating System
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/os", (req, res) => {
		var os = require("os")
		var output = {}

		output.tmpdir = os.tmpdir()
		output.endianness = os.endianness()
		output.hostname = os.hostname()
		output.type = os.type()
		output.platform = os.platform()
		output.arch = os.arch()
		output.release = os.release()
		output.uptime = os.uptime()
		output.loadavg = os.loadavg()
		output.totalmem = os.totalmem()
		output.freemem = os.freemem()
		output.cpus = os.cpus()
		output.networkInfraces = os.networkInterfaces()

		var result = JSON.stringify(output)
		res.type("application/json").status(200).send(result)
	})
	
	/**
	 * @swagger
	 *
	 * /rest/ex2/osUser:
	 *   get:
	 *     summary: Return OS level User
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/ex2/osUser", (req, res) => {
		var exec = require("child_process").exec
		exec("whoami", (err, stdout, stderr) => {
			if (err) {
				res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
				return
			} else {
				res.type("text/plain").status(200).send(stdout)
			}
		})
	})
	
	return app
}