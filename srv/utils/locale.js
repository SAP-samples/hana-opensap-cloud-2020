exports.getLocaleReq = (req) => {
    let langparser = require("accept-language-parser")
    let lang = req.headers["accept-language"]
    if (!lang) {
        return null
    }
    var arr = langparser.parse(lang)
    if (!arr || arr.length < 1) {
        return null
    }
    var locale = arr[0].code
    if (arr[0].region) {
        locale += "_" + arr[0].region
    }
    return locale
}

exports.getLocale = (env) => {
    env = env || process.env
    return env.LC_ALL || env.LC_MESSAGES || env.LANG || env.LANGUAGE
}

