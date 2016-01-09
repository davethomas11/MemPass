
var mempass = require('../mempass_node').mempass;
var test = require('unit.js');


describe('MemPassDice', function () {

	var db_word_count = 0;
	var db_word_5 = null;
	var db_word_40005 = null;

	before(function(done) {

		mempass.getDice().getWordCount(function (count) {
			db_word_count = count;
			done();
		});

	});

	before(function(done) {
	
		mempass.getDice().wordAt(5, function(word) {
			db_word_5 = word;
			done();
		});
	});

	before(function(done) {
	
		mempass.getDice().wordAt(40005, function(word) {
			db_word_40005 = word;
			done();
		});
	});

	it('Database Word Count', function () {
		
		test.number(db_word_count).is(40636);
	});

	it('Database Word at 5', function () {
		
		test.string(db_word_5).is("Aalost");
	});

	it('Database Word at 40005', function () {
		
		test.string(db_word_40005).is("woodsy");
	});

});



