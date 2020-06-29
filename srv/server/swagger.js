
async function convertEdmxToOpenAPI(csn, entity, path, swaggerSpec) {
    let metadata = await cds.compile.to.edmx(csn, {
        odataVersion: 'v4', service: entity
    })
    const {
        parse,
        convert
    } = require('odata2openapi')
    const converter = require('swagger2openapi')
    const odataOptions = {}         
    let convOptions = {}
    convOptions.anchors = true
    let service = await parse(metadata)
    let swagger = await convert(service.entitySets, odataOptions, service.version)
    let output = await converter.convertObj(swagger, convOptions)
    Object.keys(output.openapi.paths).forEach((key) => {
        let val = output.openapi.paths[key]
        Object.keys(val).forEach((item) => {
            val[item].tags = [entity]
        })
        swaggerSpec.paths[`${path}${key}`] = val
    })
    Object.keys(output.openapi.components.schemas).forEach((key) => {
        let val = output.openapi.components.schemas[key]
        swaggerSpec.components.schemas[key] = val
    })
    Object.keys(output.openapi.components.requestBodies).forEach((key) => {
        let val = output.openapi.components.requestBodies[key]
        swaggerSpec.components.requestBodies[key] = val
    })    
}

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
            apis: ['./routes/*']
        }
        var swaggerSpec = swaggerJSDoc(options)
        swaggerSpec.components.requestBodies = []
        try {
            const cds = require("@sap/cds")
            const csn = await cds.load([global.__base + "/gen/csn.json"])
            await convertEdmxToOpenAPI(csn, 'MasterDataService', '/odata/v4/MasterDataService', swaggerSpec)
            await convertEdmxToOpenAPI(csn, 'POService', '/odata/v4/POService', swaggerSpec)            
            return swaggerSpec 
        } catch (error) {
            app.logger.error(error)
            return
        }
    }
}
module.exports = swagger