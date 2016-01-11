var mempass;
var test;

if (typeof require == "function") {
	mempass2 = require('../../node-tests/mempass_node').mempass;
	test = require('../../node-tests/node_modules/unit.js');
} else {
	mempass2 = new MemPass();
	test = unitjs;
}

describe('MemPassDice', function () {

	var db_word_count = 0;
	var db_word_5 = null;
	var db_word_40005 = null;

	before(function(done) {

		mempass2.getDice().getWordCount(function (count) {
			db_word_count = count;
			done();
		});

	});

	before(function(done) {
	
		mempass2.getDice().wordAt(5, function(word) {
			db_word_5 = word;
			done();
		});
	});

	before(function(done) {
	
		mempass2.getDice().wordAt(40005, function(word) {
			db_word_40005 = word;
			done();
		});
	});

	it('Database Word Count', function () {
		
		test.number(db_word_count).is(40638);
	});

	it('Database Word at 5', function () {
		
		test.string(db_word_5).is("Aalost");
	});

	it('Database Word at 40005', function () {
		
		test.string(db_word_40005).is("woodsy");
	});

});



