const cds = require('@sap/cds')
const Sdk = require('@dynatrace/oneagent-sdk')
const DynaT = Sdk.createInstance()
console.log(DynaT.getCurrentState())
console.log(`CDS Custom Boostrap from /srv/server.js`)
global.__base = __dirname + "/"
process.on('uncaughtException', function (err) {
    console.error(err.name + ': ' + err.message, err.stack.replace(/.*\n/, '\n')) // eslint-disable-line
})

const TextBundle = require("@sap/textbundle").TextBundle
global.__bundle = new TextBundle("../_i18n/i18n", require("./utils/locale").getLocale())

// handle bootstrapping events...
cds.on('bootstrap', async (app) => {
    // add your own middleware before any by cds are added
 
})

cds.on('served', () => {
    // add more middleware after all cds servies
})


// delegate to default server.js:
module.exports = async (o) => {
    o.port = process.env.PORT || 4000
    //API route (Disabled by default)
    o.baseDir = process.cwd()
    //this.publicDir = path.join(this.baseDir, '../app')
    o.routes = []

    const express = require('express')
    let app = express()
    app.express = express
    app.baseDir = process.cwd()
    o.app = app  
    
    const path = require('path')
    const fileExists = require('fs').existsSync
    let expressFile = path.join(app.baseDir, 'server/express.js')
    if (fileExists(expressFile)) {
        await require(expressFile)(app)
    }
    o.app.httpServer = await cds.server(o)

    const glob = require('glob')
    //Load routes
    let baseDir = process.cwd()
    let routesDir = path.join(baseDir, 'routes/**/*.js')
    let files = glob.sync(routesDir)
    this.routerFiles = files;
    if (files.length !== 0) {
        for (let file of files) {
            await require(file)(app, app.httpServer)
        }
    }

    return o.app.httpServer
}
