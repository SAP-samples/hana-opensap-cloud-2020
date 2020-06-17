/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0*/
"use strict"

module.exports = (app) => {

	/**
	 * @swagger
	 *
	 * /rest/ex1:
	 *   get:
	 *     summary: Hello World
	 *     tags:
	 *       - exercises
	 *     responses:
	 *       '200':
	 *         description: Output
	 */	
	app.get("/rest/ex1", (req, res) => {
		res.send("Hello World Node.js")
	})
	return app
}