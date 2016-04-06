var MemPass = require('../chrome-extension/mempass/mempass.min.js').MemPass;
var injector = {
    sqlite3Path: __dirname + "/words.sqlite3",
    sqlite3: require('sqlite3').verbose(),
    crypto: require('crypto'),
    getRandomValues: require('get-random-values'),
    wordJSONPath: "../word.json"
};


exports.mempass = function () {
    return new MemPass(injector);
};
exports.injector = injector;