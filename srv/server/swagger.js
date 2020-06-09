function swagger(app) {

	this.getOpenAPI = async() => {
		let swaggerJSDoc = require('swagger-jsdoc')

		var options = {
			swaggerDefinition: {
				openapi: '3.0.0',
				info: {
					title: 'HANA Cloud openSAP 2020',
					version: '1.0.0',
					"x-odata-version": '4.0'
				},
				tags: [{
					name: "openSAP"
				}],
			},
			apis: ['./routes/*']
		}
		var swaggerSpec = swaggerJSDoc(options)

		const odataOptions = {}
		try {
			const {
				parse,
				convert
			} = require('odata2openapi');
			const cds = require("@sap/cds")
			const csn = await cds.load([global.__base + "/gen/csn.json"])
			let metadata = cds.compile.to.edmx(csn, {
				version: 'v4',
			})

			let service = await parse(metadata)
			let swagger = await convert(service.entitySets, odataOptions, service.version)
			Object.keys(swagger.paths).forEach(function (key) {
				let val = swagger.paths[key]
				swaggerSpec.paths[`/srv_api/odata/v4/teamtask${key}`] = val
			})
			swaggerSpec.definitions = swagger.definitions
			return swaggerSpec
		} catch (error) {
			app.logger.error(error)
			return
		}
	}
}
module.exports = swagger