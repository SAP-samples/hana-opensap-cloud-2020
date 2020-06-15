
'use strict';
module.exports = function (app) {
	/**
	 * @swagger
	 *
	 * /rest/hello:
	 *   get:
	 *     summary: Test Endpoint
	 *     tags:
	 *       - Test
	 *     responses:
	 *       '200':
	 *         description: Hello World
	 */
	app.get('/rest/hello', function (req, res) {
		return res.send('Hello World!')
	})
}