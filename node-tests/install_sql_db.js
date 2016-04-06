var memPassNode = require('./mempass_node');
var injector = memPassNode.injector;
var memPass = memPassNode.mempass;

memPass.getDice().nodeSqlLite3Install("../word.json", function () {

	console.log("Finalized.");
	process.exit();
});


