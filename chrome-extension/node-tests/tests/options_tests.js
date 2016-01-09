var mempass = require('../mempass_node').mempass;
var test = require('unit.js');
var options = mempass.getOptions();


describe('MemPassOptions', function () {

	

	it('Parse Options String', function () {

		var test_options_string = "0.0.0.14.~`!@|$%";
		options.parseSettingsString(test_options_string);

		test.bool(options.hasNumber).isNotTrue();
		test.bool(options.hasCapital).isNotTrue();
		test.bool(options.hasDiceWords).isNotTrue();
		test.number(options.characterLimit).is(14);
		test.array(options.specialChars).is(["~","`","!","@","|","$","%"]);
	});

	it ('Get Options String', function () {

		var test_options_string = "1.0.1.0.~`!@|.$%()0";
		options.parseSettingsString(test_options_string);

		test.string(options.settingsString()).is(test_options_string);
	});
});