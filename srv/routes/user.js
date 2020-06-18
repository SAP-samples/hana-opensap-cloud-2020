/*eslint no-undef: 0 */
'use strict'
module.exports = function (app) {
	/**
	 * @swagger
	 *
	 * /rest/user:
	 *   get:
	 *     summary: User/Member Information
	 *     tags:
	 *       - User
	 *     responses:
	 *       '200':
	 *         description: User Details
	 */
	app.get('/rest/user', async (req, res) => {
        const { getSafe } = require(global.__base + "utils/general")
        try {            
            let body = JSON.stringify({
                "session": [{
                    "UserName": getSafe(() => req.user.id, ''),
                    "familyName": getSafe(() => req.user.name.familyName, ''),
                    "givenName": getSafe(() => req.user.name.givenName, ''),
                    "emails": getSafe(() => req.user.emails, ''),
                    "Language": require(global.__base + "utils/locale").getLocaleReq(req)
                }]
            });
            return res.type("application/json").status(200).send(body)
        } catch (err) {
            return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
        } 
	})

}