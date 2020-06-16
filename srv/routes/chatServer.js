/*eslint-env node, es6 */
"use strict";
var WebSocketServer = require("ws").Server;

module.exports = function (app, server) {
	app.use('/rest/chat', (req, res) => {
		let output =
			`<H1>Node.js Web Socket Examples</H1></br>
			<a href="/exerciseChat">/exerciseChat</a> - Chat Application for Web Socket Example</br>`+			
			require(global.__base + "utils/exampleTOC").fill()
		res.type("text/html").status(200).send(output)
	})
	var wss = new WebSocketServer({
		noServer: true,
		path: "/rest/chatServer"
	})

	server.on("upgrade", (request, socket, head) => {
		const url = require("url");	
		const pathname = url.parse(request.url).pathname

		if (pathname === "/rest/chatServer") {
			wss.handleUpgrade(request, socket, head, function done(ws) {
				wss.emit("connection", ws, request)
			})
		}
	})

	wss.broadcast = (data) => {
		wss.clients.forEach((client) => {
			try {
				client.send(data);
			} catch (e) {
                app.logger.error(`Broadcast Error: ${e.toString()}`)
			}
        })
        app.logger.info(`Sent: ${data}`)
	}

	wss.on("connection", (ws) => {
		app.logger.info(`Web Socket Connected`)
		ws.on("message", (message) => {
            app.logger.info(`Received: ${message}`)
			wss.broadcast(message)
		})
		ws.send(JSON.stringify({
			user: "Node",
			text: "Hello from Node.js Server"
		}))
	})

	return app
}