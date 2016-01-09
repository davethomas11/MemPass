var MemPass = require('../chrome-extension/mempass/mempass.js').MemPass;

var memPass = new MemPass(
	{
		sqlite3 : require('sqlite3').verbose(), 
		crypto : require('crypto'),
		getRandomValues : require('get-random-values')
	});

exports.mempass = memPass;