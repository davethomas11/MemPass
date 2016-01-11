var mempass;
var test;

if (typeof require == "function") {
	mempass3 = require('../../node-tests/mempass_node').mempass;
	test = require('../../node-tests/node_modules/unit.js');
} else {
	mempass3 = new MemPass();
	test = unitjs;
}

var options = mempass3.getOptions();


describe('MemPassOptions', function () {

	

	it('Parse Options String', function () {

		var test_options_string = "0.0.0.14.~`!@|$%";
		options.parseSettingsString(test_options_string, false);

		test.bool(options.hasNumber).isNotTrue();
		test.bool(options.hasCapital).isNotTrue();
		test.bool(options.hasDiceWords).isNotTrue();
		test.number(options.characterLimit).is(14);
		test.array(options.specialChars).is(["~","`","!","@","|","$","%"]);
	});

	it ('Get Options String', function () {

		var test_options_string = "1.0.1.0.~`!@|.$%()0";
		options.parseSettingsString(test_options_string, false);

		test.string(options.settingsString()).is(test_options_string);
	});

	it ('Test Reset', function () {

		options.reset();

		test.bool(options.hasNumber).isTrue();
		test.bool(options.hasCapital).isTrue();
		test.bool(options.hasDiceWords).isTrue();
		test.number(options.characterLimit).is(0);
		test.array(options.specialChars).is(["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"]);

	});
});