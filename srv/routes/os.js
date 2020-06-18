/*eslint no-console: 0, no-unused-vars: 0, no-shadow: 0, new-cap: 0, dot-notation:0, no-use-before-define:0 */
/*eslint-env node, es6 */
"use strict"
global.child = null
module.exports = function(app) {

	//Hello Router
	app.get("/rest/os", (req, res) => {
		var output =
			`<H1>OS level Examples</H1></br> 
			<a href="./osInfo">/osInfo</a></br>		
			<a href="./whoami">/whoami</a></br>` +
			require(global.__base + "utils/exampleTOC").fill()
		res.type("text/html").status(200).send(output)
	})

	/**
	 * @swagger
	 *
	 * /rest/os/osInfo:
	 *   get:
	 *     summary: Simple call to the Operating System
	 *     tags:
	 *       - os
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/os/osInfo", (req, res) => {
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
	 * /rest/os/whoami:
	 *   get:
	 *     summary: Return OS level User
	 *     tags:
	 *       - os
	 *     responses:
	 *       '200':
	 *         description: Output
	 */		
	app.get("/rest/os/whoami", (req, res) => {
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