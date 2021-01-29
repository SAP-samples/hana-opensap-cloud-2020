'use strict';

//const bodyParser = require('body-parser')

module.exports = function (app) {


	let logging = require('@sap/logging')
	let appContext = logging.createAppContext({})
	app.logger = appContext.createLogContext().getLogger('/Application')

	const swagger = require('./swagger')
	app.swagger = new swagger(app)
    require('./expressSecurity')(app)
	const xsenv = require("@sap/xsenv")
	xsenv.loadEnv()
	const HDBConn = require("@sap/hdbext")
	let hanaOptions = xsenv.getServices({
		hana: {
			tag: "hana"
		}
	})
	hanaOptions.hana.pooling = true

//	app.use(bodyParser.json())

	require('./healthCheck')(app, { hdbext: HDBConn, hanaOptions: hanaOptions })
	require('./overloadProtection')(app)

	app.use(require('express-status-monitor')())

	//app.use(express.static('../app/webapp'))
	app.use(logging.middleware({ appContext: appContext, logNetwork: false }))

	app.use(
		HDBConn.middleware(hanaOptions.hana)
	)
};