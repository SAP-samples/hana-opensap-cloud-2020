/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0*/
/*eslint-env node, es6 */
"use strict"
module.exports = function (app) {

	app.get("/rest/auth", (req, res) => {
		let output =
			`<H1>Authorizations Demo</H1></br>
			<a href="./passport">/passport</a> - Security Context via Passport</br>
			<a href="./userinfo2">/userinfo2</a> - Security Context From the DB Level</br>			
			<a href="./xssec">/xssec</a> - Build the Security Context Via XSSEC</br>` +
			require(global.__base + "utils/exampleTOC").fill()
		res.type("text/html").status(200).send(output)
	})

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
	/**
	 * @swagger
	 *
	 * /rest/auth/passport:
	 *   get:
	 *     summary: Security Context via Passport
	 *     tags:
	 *       - auth
	 *     responses:
	 *       '200':
	 *         description: authInfo
	 */
	app.get("/rest/auth/passport", (req, res) => {
		res.type("application/json").status(200).send(mapSecurityContext(req.authInfo))
	})

	/**
	 * @swagger
	 *
	 * /rest/auth/userinfo2:
	 *   get:
	 *     summary: Security Context From the DB Level 
	 *     tags:
	 *       - auth
	 *     responses:
	 *       '200':
	 *         description: authInfo
	 */
	app.get("/rest/auth/userinfo2", async(req, res) => {
		try {
			let dbPromises = require("sap-hdbext-promisfied");
			let db = new dbPromises(req.db);
			const statement = await db.preparePromisified(
				`SELECT TOP 1 CURRENT_USER, SESSION_USER, SESSION_CONTEXT('XS_APPLICATIONUSER') as APPLICATION_USER,  SESSION_CONTEXT('APPLICATION') as APPLICATION, SESSION_CONTEXT('XS_COUNTRY') as XS_COUNTRY
				   FROM DUMMY`);
			const results = await db.statementExecPromisified(statement, []);
			let result = JSON.stringify({
				"hdbCurrentUser": results,
				"user": req.user
			});
			return res.type("application/json").status(200).send(result);
		} catch (e) {
			return res.type("text/plain").status(500).send(`ERROR: ${e.toString()}`);
		}
	})


	/**
	 * @swagger
	 *
	 * /rest/auth/xssec:
	 *   get:
	 *     summary: Build the Security Context Via XSSEC
	 *     tags:
	 *       - auth
	 *     responses:
	 *       '200':
	 *         description: authInfo
	 */
	app.get("/rest/auth/xssec", (req, res) => {
		let xssec = require("@sap/xssec")
		let xsenv = require("@sap/xsenv")
		let accessToken

		function getAccessToken(req) {
			var accessToken = null
			if (req.headers.authorization && req.headers.authorization.split(" ")[0] === "Bearer") {
				accessToken = req.headers.authorization.split(" ")[1]
			}
			return accessToken
		}

		accessToken = getAccessToken(req)
		let uaa = xsenv.getServices({
			uaa: {
				tag: "xsuaa"
			}
		}).uaa
		xssec.createSecurityContext(accessToken, uaa, (error, securityContext) => {
			if (error) {
				app.logger.error("Security Context creation failed")
				res.status(400).send("Security Context creation failed")
				return
			}
			app.logger.info("Security Context created successfully")
			res.type("application/json").status(200).send(JSON.stringify(mapSecurityContext(securityContext)))
			return
		})
	})
	return app
}