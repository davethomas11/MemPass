var memPass = require('./mempass_node').mempass();

memPass.getDice().nodeSqlLite3Install("../word.json", function () {

	console.log("Finalized.");
	process.exit();
});


