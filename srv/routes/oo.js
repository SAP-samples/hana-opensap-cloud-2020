/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0, dot-notation:0, no-use-before-define:0, no-inner-declarations:0 */
/*eslint-env node, es6 */
"use strict";
var ooTutorial1 = require("../oo/ooTutorial1");
var ooTutorial2 = require("../oo/ooTutorial2");
var ooTutorial3 = require("../oo/ooTutorial3");
var ooTutorial4 = require("../oo/ooTutorial4");

module.exports = function(app) {

	//Hello Router
	app.get("/rest/oo", (req, res) => {
		let output =
			`<H1>JavaScript Object Oriented</H1></br>
			<a href="./classes1">/classses1</a> - Classes</br>
			<a href="./classes1Error">/classses1Error</a> - Classes, catch errors</br>
			<a href="./classes2a">/classes2a</a> - Classes with Static Methods #1</br>
			<a href="./classes2b">/classes2b</a> - Classes with Static Methods #2</br>
			<a href="./classes3a">/classes3a</a> - Classes with Instance Methods #1</br>
			<a href="./classes3b">/classes3b</a> - Classes with Instance Methods #2</br>	
			<a href="./classes4a">/classes4a</a> - Classes with Inherited Methods #1</br>
			<a href="./classes4b">/classes4b</a> - Classes with Inherited Methods #2</br>`
		res.type("text/html").status(200).send(output)
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes1:
	 *   get:
	 *     summary: OO - First Method Call
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes1", (req, res) => {
		let class1 = new ooTutorial1("first example")
		return res.type("text/html").status(200).send(`Call First Method: ${class1.myFirstMethod(5)}`)
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes1Error:
	 *   get:
	 *     summary: OO - Call and catch errors
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes1Error", (req, res) => {
		let class1 = new ooTutorial1("first example")
		try {
			return class1.myFirstMethod(20)
		} catch (e) {
			return res.type("application/json").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes2a:
	 *   get:
	 *     summary: OO - Call static method
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes2a", async(req, res) => {
		try {
			const results = await ooTutorial2.getFlightDetails(req.db, "AA", "0017", "20100421")
			return res.type("text/html").status(200).send(
				`Call Static Method: ${JSON.stringify(results)}`)
		} catch (e) {
			return res.type("application/json").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes2b:
	 *   get:
	 *     summary: OO - Call Satic Method #2
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes2b", async(req, res) => {
		try {
			const results = await ooTutorial2.calculateFlightPrice(req.db, "AA", "0017", "20100421")
			return res.type("text/html").status(200).send(
				`Call Static Method - Calc Price: ${results.toString()}`)
		} catch (e) {
			return res.type("application/json").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes3a:
	 *   get:
	 *     summary: OO - Call Instance Method
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes3a", async(req, res) => {
		try {
			let class3 = new ooTutorial3(req.db)
			const results = await class3.getFlightDetails("AA", "0017", "20100421")
			return res.type("text/html").status(200).send(
				`Call Instance Method: ${JSON.stringify(results)}`)
		} catch (e) {
			return res.type("application/json").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes3b:
	 *   get:
	 *     summary: OO - Call Instance Method #2
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes3b", async(req, res) => {
		try {
			let class3 = new ooTutorial3(req.db)
			await class3.getFlightDetails("AA", "0017", "20100421")
			const results = await class3.calculateFlightPrice()
			return res.type("text/html").status(200).send(
				`Call Instance Method - Calc Price: ${results.toString()}`)
		} catch (e) {
			return res.type("application/json").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes4a:
	 *   get:
	 *     summary: OO - Call Inherited Method
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes4a", async(req, res) => {
		try {
			let class4 = new ooTutorial4(req.db)
			const results = await class4.getFlightDetails("AA", "0017", "20100421")
			return res.type("text/html").status(200).send(
				`Call Inherited Method: ${JSON.stringify(results)}`)
		} catch (e) {
			return res.type("application/json").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/oo/classes4b:
	 *   get:
	 *     summary: OO - Call Overridden Method
	 *     tags:
	 *       - oo
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/oo/classes4b", async(req, res) => {
		try {
			let class4 = new ooTutorial4(req.db)
			await class4.getFlightDetails("AA", "0017", "20100421")
			const results = await class4.calculateFlightPrice()
			return res.type("text/html").status(200).send(
				`Call Overridden Method - Calc Price: ${results.toString()}`)
		} catch (e) {
			return res.type("application/json").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	return app
}