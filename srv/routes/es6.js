/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0, dot-notation:0, no-use-before-define:0, no-inner-declarations:0 */
/*eslint-env node, es6 */
"use strict";
var ooTutorial1 = require("../oo/ooTutorial1.js")
var ooTutorial2 = require("../oo/ooTutorial2.js")
var ooTutorial3 = require("../oo/ooTutorial3.js")
var ooTutorial4 = require("../oo/ooTutorial4.js")

module.exports = (app) => {

	//Hello Router
	app.get("/rest/es6", (req, res) => {
		let output =
			`<H1>ES6 Features</H1></br>
			<a href="../promises/promises">/promises</a> - Manual Promisefy readFile</br>
			<a href="../promises/promisesError">/promisesError</a> - Manual Promisefy readFile and catch error</br> 
			<a href="../promises/promisesDB1">/promisesDB1</a> - Simple HANA DB Select via Promises</br>
			<a href="../promises/promisesDB2">/promisesDB2</a> - Simple Database Call Stored Procedure via Promises</br> 
			<a href="./constants">/constants</a> - Constants</br>
			<a href="./blockScoped">/blockScoped</a> - Block-Scoped Variables and Functions</br>	
			<a href="./parameterDefaults">/parameterDefaults</a> - Parameter Defaults</br>	
			<a href="./parameterMultiple">/parameterMultiple</a> - Handling unknown number of input parameters easily</br>		
			<a href="./unicode">/unicode</a> - Unicode Strings and Literals</br>
			<a href="./classes1">/classses1</a> - Classes</br>
			<a href="./classes1Error">/classses1Error</a> - Classes, catch errors</br>
			<a href="./classes2a">/classes2a</a> - Classes with Static Methods #1</br>
			<a href="./classes2b">/classes2b</a> - Classes with Static Methods #2</br>
			<a href="./classes3a">/classes3a</a> - Classes with Instance Methods #1</br>
			<a href="./classes3b">/classes3b</a> - Classes with Instance Methods #2</br>	
			<a href="./classes4a">/classes4a</a> - Classes with Inherited Methods #1</br>
			<a href="./classes4b">/classes4b</a> - Classes with Inherited Methods #2</br>
			<a href="./numFormat">/numFormat</a> - International Number Formatting</br>	
			<a href="./currFormat">/currFormat</a> - International Currency Formatting</br>
			<a href="./dateFormat">/dateFormat</a> - International Date/Time Formatting</br>` +
			require(global.__base + "utils/exampleTOC").fill()
		res.type("text/html").status(200).send(output)
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/constants:
	 *   get:
	 *     summary: ES6 Constants
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/constants", (req, res) => {
		const fixVal = 10
		let newVal = fixVal
		try {
			newVal++
			// eslint-disable-next-line no-const-assign
			fixVal++
		} catch (e) {
			res.type("text/html").status(200).send(
				`Constant Value: ${fixVal.toString()}, Copied Value: ${newVal.toString()}, Error: ${e.toString()}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/blockScoped:
	 *   get:
	 *     summary: Block Scoped
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/blockScoped", (req, res) => {
		let output

		function foo() {
			return 1
		}
		output = `Outer function result: ${foo()} `
		if (foo() === 1) {
			function foo() {
				return 2
			}
			output += `Inner function results: ${foo()}`
		}
		res.type("text/html").status(200).send(output)
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/parameterDefaults:
	 *   get:
	 *     summary: Parameter Defaults
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/parameterDefaults", (req, res) => {
		function math(a, b = 10, c = 12) {
			return a + b + c
		}
		res.type("text/html").status(200).send(`With Defaults: ${math(5)}, With supplied values: ${math(5, 1, 1)}`)

	})

	/**
	 * @swagger
	 *
	 * /rest/es6/parameterMultiple:
	 *   get:
	 *     summary: Multiple Parameter
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/parameterMultiple", (req, res) => {
		function getLength(a, b, ...p) {
			return a + b + p.length
		}
		res.type("text/html").status(200).send(`2 plus 4 parameters: ${getLength(1, 1, "stuff", "More Stuff", 8, "last param")}`)

	})

	/**
	 * @swagger
	 *
	 * /rest/es6/unicode:
	 *   get:
	 *     summary: Unicode Strings and Literals
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/unicode", (req, res) => {
		if ("𠮷".length === 2) {
			res.type("text/html").status(200).send(`Output: ${"𠮷".toString()}, Code Points: ${"𠮷".codePointAt(0)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes1:
	 *   get:
	 *     summary: OO - First Method Call
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes1", (req, res) => {
		let class1 = new ooTutorial1("first example");
		res.type("text/html").status(200).send(`Call First Method: ${class1.myFirstMethod(5)}`)
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes1Error:
	 *   get:
	 *     summary: OO - Call and catch errors
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes1Error", (req, res) => {
		let class1 = new ooTutorial1("first example")
		try {
			class1.myFirstMethod(20)
		} catch (e) {
			res.type("text/html").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
		}
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes2a:
	 *   get:
	 *     summary: OO - Call static method
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes2a", (req, res) => {
		ooTutorial2.getFlightDetails(req.db, "AA", "0017", "20100421").then(results => {
			res.type("text/html").status(200).send(
				`Call Static Method: ${JSON.stringify(results)}`)
		})
			.catch(e => {
				res.type("text/html").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
			})
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes2b:
	 *   get:
	 *     summary: OO - Call Satic Method #2
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes2b", (req, res) => {
		ooTutorial2.calculateFlightPrice(req.db, "AA", "0017", "20100421").then(results => {
			res.type("text/html").status(200).send(
				`Call Static Method - Calc Price: ${results.toString()}`)
		})
			.catch(e => {
				res.type("text/html").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
			})
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes3a:
	 *   get:
	 *     summary: OO - Call Instance Method
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes3a", (req, res) => {
		let class3 = new ooTutorial3(req.db)
		class3.getFlightDetails("AA", "0017", "20100421").then(results => {
			res.type("text/html").status(200).send(
				`Call Instance Method: ${JSON.stringify(results)}`)
		})
			.catch(e => {
				res.type("text/html").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
			})

	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes3b:
	 *   get:
	 *     summary: OO - Call Instance Method #2
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes3b", (req, res) => {
		let class3 = new ooTutorial3(req.db)
		class3.calculateFlightPrice("AA", "0017", "20100421").then(results => {
			res.type("text/html").status(200).send(
				`Call Instance Method - Calc Price: ${results.toString()}`)
		})
			.catch(e => {
				res.type("text/html").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
			})
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes4a:
	 *   get:
	 *     summary: OO - Call Inherited Method
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes4a", (req, res) => {
		let class4 = new ooTutorial4(req.db)
		class4.getFlightDetails("AA", "0017", "20100421").then(results => {
			res.type("text/html").status(200).send(
				`Call Inherited Method: ${JSON.stringify(results)}`)
		})
			.catch(e => {
				res.type("text/html").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
			})
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/classes4b:
	 *   get:
	 *     summary: OO - Call Overridden Method
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/classes4b", (req, res) => {
		let class4 = new ooTutorial4(req.db)
		class4.calculateFlightPrice("AA", "0017", "20100421").then(results => {
			res.type("text/html").status(200).send(
				`Call Overridden Method - Calc Price: ${results.toString()}`)
		})
			.catch(e => {
				res.type("text/html").status(200).send(`Call and catch errors: ${JSON.stringify(e)}`)
			})
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/numFormat:
	 *   get:
	 *     summary: Number Format
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/numFormat", (req, res) => {
		let numEN = new Intl.NumberFormat("en-US")
		let numDE = new Intl.NumberFormat("de-DE")
		res.type("text/html").status(200).send(`US: ${numEN.format(123456789.10)}, DE: ${numDE.format(123456789.10)}`)
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/currFormat:
	 *   get:
	 *     summary: Currency Formatting
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/currFormat", (req, res) => {
		let curUS = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" })
		let curDE = new Intl.NumberFormat("de-DE", { style: "currency", currency: "EUR" })
		res.type("text/html").status(200).send(`US: ${curUS.format(123456789.10)}, DE: ${curDE.format(123456789.10)}`)
	})

	/**
	 * @swagger
	 *
	 * /rest/es6/dateFormat:
	 *   get:
	 *     summary: Date/Time Formatting
	 *     tags:
	 *       - es6
	 *     responses:
	 *       '200':
	 *         description: Output
	 */
	app.get("/rest/es6/dateFormat", (req, res) => {
		let dateUS = new Intl.DateTimeFormat("en-US")
		let dateDE = new Intl.DateTimeFormat("de-DE")
		res.type("text/html").status(200).send(`US: ${dateUS.format(new Date())}, DE: ${dateDE.format(new Date())}`)
	})

	return app
}