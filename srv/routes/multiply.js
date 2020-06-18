'use strict'
module.exports = function (app) {
	/**
	 * @swagger
	 *
	 * /rest/multiply/{num1}/{num2}:
	 *   get:
	 *     summary: Multiply Two Numbers
	 *     tags:
	 *       - multiply
     *     parameters:
	 *       - name: num1
	 *         in: path
	 *         description: Number 1 
	 *         required: false
	 *         schema:
	 *           type: integer  
	 *       - name: num2
	 *         in: path
	 *         description: Number 2 
	 *         required: false
	 *         schema:
	 *           type: integer      
	 *     responses:
	 *       '200':
	 *         description: Results
	 */
    app.get('/rest/multiply/:num1?/:num2?', async (req, res) => {

        let body = ""
        let num1 = 0
        if (!isNaN(parseInt(req.params.num1))) {
            num1 = parseInt(req.params.num1)
        }
        let num2 = 0
        if (!isNaN(parseInt(req.params.num2))) {
            num2 = parseInt(req.params.num2)
        }
        let answer

        answer = num1 * num2

        body = answer.toString();
        return res.type("application/json").status(200).send(body)
    })
}