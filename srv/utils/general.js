exports.getSafe = (fn, defaultVal) => {
    try {
        return fn();
    } catch (e) {
        return defaultVal;
    }
}

exports.callback = (error, res, message) => {
    if (error) {
        res.writeHead(500, {
            'Content-Type': 'application/json'
        })
        res.end(JSON.stringify({
            message: message
        }))
    } else {
        res.writeHead(200, {
            'Content-Type': 'application/json'
        })
        res.end(JSON.stringify({
            message: message
        }))
    }
}

exports.isAlphaNumeric = (str) => {
    let code, i, len
    for (i = 0, len = str.length; i < len; i++) {
        code = str.charCodeAt(i)
        if (!(code > 47 && code < 58) && // numeric (0-9)
            !(code > 64 && code < 91) && // upper alpha (A-Z)
            !(code > 96 && code < 123)) { // lower alpha (a-z)
            return false
        }
    }
    return true
}

exports.isAlphaNumericAndSpace = (str) => {
    let res = str.match(/^[a-z\d\-_\s]+$/i)
    if (res) {
        return true
    } else {
        return false
    }
}

exports.isValidDate = (date) => {
    console.log("date" + date)
    var timestamp = Date.parse(date)
    console.log("timsestamp" + timestamp)
    if (isNaN(timestamp) === true) {
        return false
    }
    return true
}

exports.isEmpty = (val) => {
    if (val === undefined)
        return true
    if (typeof (val) == 'function' || typeof (val) == 'number' || typeof (val) == 'boolean' || Object.prototype.toString.call(val) ===
        '[object Date]')
        return false
    if (val == null || val.length === 0) // null or 0 length array
        return true
    if (typeof (val) == "object") {
        // empty object
        var r = true
        // eslint-disable-next-line no-unused-vars
        for (let f in val)
            r = false
        return r
    }
    return false
}