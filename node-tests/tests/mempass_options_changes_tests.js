/**
 * Created by dave on 2016-03-19.
 */
var tmempass = require('../mempass_node').mempass();
var tmempass2 = require('../mempass_node').mempass();
var tmempass3 = require('../mempass_node').mempass();
var tmempass4 = require('../mempass_node').mempass();
var tmempass5 = require('../mempass_node').mempass();

var test = require('unit.js');
var seed = "2289146dc04e35c66958e75792142c2edb9793072002aa160ea08ae664ee95c0";
var expected = "#~(^{-> NaRk <-`%$4722-> Kahn <--> French <-9=";
var expected2 = "#~(^{-> NaRk <-`%$nnnn-> Kahn <--> French <-n=";
var expected3 = "#~(^{-> nark <-`%$nnnn-> kahn <--> french <-n=";
var expected4 = "#~(^{`%$nnnnn=";
var expected5 = "nnnnfneannnnnd";

tmempass.setSeed(seed);
tmempass.getOptions().reset();

tmempass2.setSeed(seed);
tmempass2.getOptions().reset();

tmempass3.setSeed(seed);
tmempass3.getOptions().reset();

tmempass4.setSeed(seed);
tmempass4.getOptions().reset();

tmempass5.setSeed(seed);
tmempass5.getOptions().reset();

describe("MemPass Configure Options Tests", function () {

    var passwordResult = null;
    var passwordResult2 = null;
    var passwordResult3 = null;
    var passwordResult4 = null;
    var passwordResult5 = null;

    before(function (done) {

        tmempass.getOptions().applyLimitBeforeDice = true;
        tmempass.getOptions().characterLimit = 14;
        tmempass.generate("johny", function (err, result) {

            if (err) {

                passwordResult = err;
            } else {

                passwordResult = result;
            }
            done();
        });
    });


    before(function (done) {

        tmempass2.getOptions().applyLimitBeforeDice = true;
        tmempass2.getOptions().characterLimit = 14;
        tmempass2.getOptions().hasNumber = false;
        tmempass2.generate("johny", function (err, result) {

            if (err) {

                passwordResult2 = err;
            } else {

                passwordResult2 = result;
            }
            done();
        });
    });

    before(function (done) {

        tmempass3.getOptions().applyLimitBeforeDice = true;
        tmempass3.getOptions().characterLimit = 14;
        tmempass3.getOptions().hasCapital = false;
        tmempass3.getOptions().hasNumber = false;
        tmempass3.generate("johny", function (err, result) {

            if (err) {

                passwordResult3 = err;
            } else {

                passwordResult3 = result;
            }
            done();
        });
    });

    before(function (done) {

        tmempass4.getOptions().characterLimit = 14;
        tmempass4.getOptions().hasCapital = false;
        tmempass4.getOptions().hasNumber = false;
        tmempass4.getOptions().hasDiceWords = false;
        tmempass4.generate("johny", function (err, result) {

            if (err) {

                passwordResult4 = err;
            } else {

                passwordResult4 = result;
            }
            done();
        });
    });

    before(function (done) {

        tmempass5.getOptions().characterLimit = 14;
        tmempass5.getOptions().hasCapital = false;
        tmempass5.getOptions().hasNumber = false;
        tmempass5.getOptions().hasDiceWords = false;
        tmempass5.getOptions().specialChars = [];
        tmempass5.generate("johny", function (err, result) {

            if (err) {

                passwordResult5 = err;
            } else {

                passwordResult5 = result;
            }
            done();
        });
    });



    it("Check Basic Algorythm With Limit", function () {

        test.string(passwordResult).is(expected);
    });

    it("Check Basic Algorythm With Limit And No Number", function () {

        test.string(passwordResult2).is(expected2);
    });

    it("Check Basic Algorythm With Limit And No Number And No Capital", function () {

        test.string(passwordResult3).is(expected3);
    });

    it("Check Basic Algorythm With Limit And No Number And No Capital And No Dice", function () {

        test.string(passwordResult4).is(expected4);
    });

    it("Check Basic Algorythm With Limit And No Number And No Capital And No Dice And No Special Char", function () {

        test.string(passwordResult5).is(expected5);
    });
});