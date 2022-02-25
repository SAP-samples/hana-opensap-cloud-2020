'use strict'
module.exports = (app) => {

    //Helmet for Security Policy Headers
        const helmet = require("helmet")
        app.use(helmet());
        app.use(helmet.contentSecurityPolicy({
            directives: {
                defaultSrc: ["'self'","sapui5.hana.ondemand.com"],
                styleSrc: ["'self'", "sapui5.hana.ondemand.com", "'unsafe-inline'"],
                scriptSrc: ["'self'", "sapui5.hana.ondemand.com", "'unsafe-inline'", "'unsafe-eval'", "cdnjs.cloudflare.com"],
                imgSrc: ["'self'", "sapui5.hana.ondemand.com", "www.loc.gov", "data:"]
            }
        })) 


    //Insecure - DO NOT LEAVE THIS HERE!
/*     app.use(function (req, res, next) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    })*/

    // Sets "Referrer-Policy: no-referrer".
         app.use(helmet.referrerPolicy({ policy: "no-referrer" }))
    
        const passport = require("passport")
        const xssec = require("@sap/xssec")
        const xsenv = require("@sap/xsenv")
    /* 
        passport.use("JWT", new xssec.JWTStrategy(xsenv.getServices({
            uaa: {
                tag: "xsuaa"
            }
        }).uaa))
        app.use(passport.initialize())
        app.use(
            passport.authenticate("JWT", {
                session: false
            })
        )  */
};