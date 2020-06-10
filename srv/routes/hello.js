
'use strict';
module.exports = function (app) {
	/**
	 * @swagger
	 *
	 * /srv_api/hello:
	 *   get:
	 *     summary: Test Endpoint
	 *     tags:
	 *       - Test
	 *     responses:
	 *       '200':
	 *         description: Hello World
	 */
	app.get('/hello', function (req, res) {
		return res.send('Hello World!')
	})
}