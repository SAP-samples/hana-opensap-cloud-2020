'use strict'
exports.getAccessToken = (req) => {
    let accessToken = null
    if (req.headers.authorization && req.headers.authorization.split(" ")[0] === "Bearer") {
        accessToken = req.headers.authorization.split(" ")[1]
    }
    return accessToken
}
