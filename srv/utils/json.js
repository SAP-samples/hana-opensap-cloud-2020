/*eslint-env node, es6 */
"use strict"

/**
@function Puts a JSON object into the Response Object
@param {object} jsonOut - JSON Object
*/
exports.outputJSON = (jsonOut, res) => {
    let out = []
    for (let item of jsonOut) {
        out.push(item)
    }
    res.type("application/json").status(200).send(JSON.stringify(out))
    return
}
