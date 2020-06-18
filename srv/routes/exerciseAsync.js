/*eslint no-console: 0, no-unused-vars: 0, new-cap:0 */
/*eslint-env node, es6 */
"use strict"
var WebSocketServer = require("ws").Server

module.exports =  (app, server) => {
	const asyncLib = require(global.__base + "async/async.js")
	const dbAsync = require(global.__base + "async/databaseAsync.js")
	const dbAsync2 = require(global.__base + "async/databaseAsync2.js")
	const fileSync = require(global.__base + "async/fileSync.js")
	const fileAsync = require(global.__base + "async/fileAsync.js")
	const httpClient = require(global.__base + "async/httpClient.js")

	app.use('/rest/excAsync', (req, res) => {
		var output =
			`<H1>Asynchronous Examples</H1></br> 
			<a href="/exerciseAsync">/exerciseAsync</a> - Test Framework for Async Examples</br>`
		res.type("text/html").status(200).send(output)
	})

	try {
		var wss = new WebSocketServer({
			//server: server
			noServer: true,
			path: "/rest/excAsync"
		})

		server.on("upgrade", (request, socket, head) => {
			const url = require("url")
			const pathname = url.parse(request.url).pathname

			if (pathname === "/rest/excAsync") {
				wss.handleUpgrade(request, socket, head, (ws) => {
					wss.emit("connection", ws, request)
				})
			}
		})

		wss.broadcast = (data) => {
			var message = JSON.stringify({
				text: data
			})
			wss.clients.forEach((client) => {
				try {
					client.send(message, (error) => {
						if (typeof error !== "undefined") {
							app.logger.error(`Send Error: ${error.toString()}`)
						}
					})
				} catch (e) {
					app.logger.error(`Broadcast Error: ${e.toString()}`)
				}
			})
			app.logger.info(`Sent: ${message}`)
		}

		wss.on("error", (error) => {
			app.logger.error(`Web Socket Server Error: ${error.toString()}`)
		})

		wss.on("connection", (ws) => {
			app.logger.info("Connected")

			ws.on("message", (message) => {
				app.logger.info(`Received: ${message}`)
				var data = JSON.parse(message)
				switch (data.action) {
				case "async":
					asyncLib.asyncDemo(wss)
					break
				case "fileSync":
					fileSync.fileDemo(wss)
					break
				case "fileAsync":
					fileAsync.fileDemo(wss)
					break
				case "httpClient":
					httpClient.callService(wss)
					break
				case "dbAsync":
					dbAsync.dbCall(wss)
					break
				case "dbAsync2":
					dbAsync2.dbCall(wss)
					break
				default:
					wss.broadcast(`Error: Undefined Action: ${data.action}`)
					break
				}
			})

			ws.on("close", () => {
				app.logger.info("Closed")
			})

			ws.on("error", (error) => {
				app.logger.error(`Web Socket Error: ${error.toString()}`)
			})

			ws.send(JSON.stringify({
				text: "Connected to Exercise 3"
			}), (error) => {
				if (typeof error !== "undefined") {
					app.logger.error(`Send Error: ${error.toString()}`)
				}
			})
		})
	} catch (e) {
		app.logger.error(`General Error: ${e.toString()}`)
	}
	return app
}