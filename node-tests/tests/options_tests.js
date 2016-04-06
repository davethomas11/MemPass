var mempass = require('../mempass_node').mempass();
var mempass2 = require('../mempass_node').mempass();
var mempass3 = require('../mempass_node').mempass();
var test = require('unit.js');
var options = mempass.getOptions();


describe('MemPassOptions', function () {

    before(function (done) {

        mempass3.reSeed("89d9703c2266e596c21b0f339cc3f3f9c3b813a02be3dbce01ec484ced18698a|1.1.1.1.0.!@#$%^`~&*(=_{+}", function (seed) {
            done();
        });
    });

    it('Check reseed 2', function () {

        test.string(mempass3.getOptions().getSpecialCharString()).is("!@#$%^`~&*(=_{+}");
    });


    before(function (done) {

        mempass2.getOptions().reset();
        mempass2.reSeed("garblegoop|1.1.1.1.0.!@#", function (seed) {
            done();
        });
    });

    it('Check reseed', function () {

        test.string("garblegoop").is(mempass2.getSeed());
        test.array(["!", "@", "#"]).is(mempass2.getOptions().specialChars);
    });

    it('Parse Options String', function () {

        var test_options_string = "1.0.0.0.14.~`!@|$%";
        options.parseSettingsString(test_options_string);

        test.bool(options.applyLimitBeforeDice).isTrue();
        test.bool(options.hasNumber).isNotTrue();
        test.bool(options.hasCapital).isNotTrue();
        test.bool(options.hasDiceWords).isNotTrue();
        test.number(options.characterLimit).is(14);
        test.array(options.specialChars).is(["~", "`", "!", "@", "|", "$", "%"]);
    });

    it('Get Options String', function () {

        var test_options_string = "0.1.0.1.0.~`!@|.$%()0";
        options.parseSettingsString(test_options_string);

        test.string(options.settingsString()).is(test_options_string);
    });

    it('MemPass Parse Seed Test', function () {

        var test_string = "89d9703c2266e596c21b0f339cc3f3f9c3b813a02be3dbce01ec484ced18698a|1.1.1.1.0.!@#$%^`~&*(=_{+}";
        var seed = mempass.parseSeedForOptions(test_string);
        mempass.setSeed(seed);

        test.string(seed).isEqualTo("89d9703c2266e596c21b0f339cc3f3f9c3b813a02be3dbce01ec484ced18698a");

        test.bool(options.applyLimitBeforeDice).isTrue();
        test.bool(options.hasNumber).isTrue();
        test.bool(options.hasCapital).isTrue();
        test.bool(options.hasDiceWords).isTrue();
        test.number(options.characterLimit).is(0);
        test.array(options.specialChars).is("!@#$%^`~&*(=_{+}".split(""));

        test.string(options.getSpecialCharString()).is("!@#$%^`~&*(=_{+}");
        test.string(mempass.memPassSyncKey()).is(test_string);
    });
});