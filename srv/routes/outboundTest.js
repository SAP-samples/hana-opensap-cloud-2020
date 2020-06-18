'use strict'
module.exports = function (app) {
	/**
	 * @swagger
	 *
	 * /rest/outboundTest/{search}/{index}:
	 *   get:
	 *     summary: Multiply Two Numbers
	 *     tags:
	 *       - outboundTest
     *     parameters:
	 *       - name: search
	 *         in: path
	 *         description: Search String
	 *         required: true
	 *         schema:
	 *           type: string  
	 *       - name: index
	 *         in: path
	 *         description: Result Index 
	 *         required: false
	 *         schema:
	 *           type: integer      
	 *     responses:
	 *       '200':
	 *         description: Results
	 */
    app.get('/rest/outboundTest/:search/:index?', async (req, res) => {

        let search = req.params.search
        let index = 0
        if (!isNaN(parseInt(req.params.index))) {
            index = parseInt(req.params.index)
        }
        try {
            let http = require("http")
            http.get({
                path: `http://www.loc.gov/pictures/search/?fo=json&q=${search}&`,
                host: "www.loc.gov",
                port: "80",
                headers: {
                    host: "www.loc.gov"
                }
            },
                (response) => {
                    response.setEncoding("utf8")
                    let body = ''

                    response.on("data", (data) => {
                        body += data
                    })

                    response.on("end", () => {
                        let searchDet = JSON.parse(body)
                        let outBody =
                            "First Result of " + encodeURIComponent(searchDet.search.hits) + "</br>" +
                            "<img src=\"" + encodeURI(searchDet.results[index].image.full) + "\">";
                        return res.type("text/html").status(200).send(outBody)
                    })

                    response.on("error", (err) => {
                        return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
                    })
                })
        } catch (err) {
            return res.type("text/plain").status(500).send(`ERROR: ${err.toString()}`)
        }

    })
}