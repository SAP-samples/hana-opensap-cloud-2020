function swagger(app) {

    this.getOpenAPI = async () => {
        let swaggerJSDoc = require('swagger-jsdoc')

        var options = {
            swaggerDefinition: {
                openapi: '3.0.0',
                info: {
                    title: 'HANA Cloud openSAP 2020',
                    version: '1.0.0',
                    "x-odata-version": '4.0'
                },
            },
            apis: ['./srv/routes/*']
        }
        var swaggerSpec = swaggerJSDoc(options)
        swaggerSpec.components.requestBodies = []
        return swaggerSpec 
    }
}
module.exports = swagger