'use strict';
module.exports = async (app) => {

    const cds = require("@sap/cds")
   // const {index} = require ('@sap/cds/lib/utils/app/index_html')

    const index = require ('@sap/cds/app/index.js')

    let odataURL = "/odata/v4/"
    let restURL = "/rest/"

    let cdsOptions = {
        kind: "hana",
        logLevel: "error"
    }
    cds.connect.to('db', cdsOptions)

    //CDS OData V4 Handler
    cds.serve('POService')
        .from(global.__base + "/gen/csn.json")
        .to("fiori")
        .at(odataURL + 'POService')
        .in(app)
        .catch((err) => {
            app.logger.error(err);
        })

    cds.serve('MasterDataService')
        .from(global.__base + "/gen/csn.json")
        .to("fiori")
        .at(odataURL + 'MasterDataService')
        .in(app)
        .catch((err) => {
            app.logger.error(err);
        })

    //CDS REST Handler
    cds.serve('POService')
        .from(global.__base + "/gen/csn.json")
        .to("rest")
        .at(restURL + 'POService')
        .in(app)
        .catch((err) => {
            app.logger.error(err);
        })

    cds.serve('MasterDataService')
        .from(global.__base + "/gen/csn.json")
        .to("rest")
        .at(restURL + 'MasterDataService')
        .in(app)
        .catch((err) => {
            app.logger.error(err);
        })

    //V2 Fallback handler
    cds.serve(
        global.__base + "/gen/csn.json", {
        crashOnError: false
    })
        .to("fiori")
        .in(app)
        .catch((err) => {
            app.logger.error(err);
        });

    const odatav2proxy = require("@sap/cds-odata-v2-adapter-proxy");
    app.use(odatav2proxy({ model: global.__base + "/gen/csn.json", path: "odata/v2", 
                           port: process.env.PORT || 4000,
                           disableNetworkLog: false }));


    app.get ('/odata/test',(_,res) => res.send (index.html))
} 