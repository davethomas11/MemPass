var mempass = require('../mempass_node').mempass();
var test = require('unit.js');
var seed = "2289146dc04e35c66958e75792142c2edb9793072002aa160ea08ae664ee95c0";
var expected = "=&#F!+}^~dE2+_2&d8{(&3d2@f+eb3f2c+cd5e&*23-> less <-a&bd%`cd$d&d3e8019a9bf";
var expected2 = "#~(^{`%$47229=+_&D*+4466d-> Nark <-}5735!e+2+@b55d58bd3a56&3a@+7+f-> Kahn <-e9384&-> French <-&5";
var expected3 = "+*72$%=_A{^@08(2}70&7~}3636&&6`}B9Ab!}bfd&&%&3e&eadb7f}d336-> flavin <-af2-> Cowper <-af";
var value = "mempass";

mempass.setSeed(seed);
mempass.getOptions().reset();

describe("MemPass Tests", function () {

	var passwordResult = null;
    var passwordResult2 = null;
    var passwordResult3 = null;
	var sha256result = null;
	var intialHash = null;

	before(function(done) {

        mempass.getOptions().reset();
		mempass.getIntialHash(value, function (err, result) {

			intialHash = result;
			done();
		});
	});

	before(function(done) {

        mempass.getOptions().reset();
		mempass.generate("johny", function (err, result) {

			if (err) {

				passwordResult2 = err;
			} else {
				
				passwordResult2 = result;
			}
			done();
		});
	});

    before(function(done) {

        mempass.getOptions().reset();
        mempass.generate("cat 5% arb", function (err, result) {

            if (err) {

                passwordResult3 = err;
            } else {

                passwordResult3 = result;
            }
            done();
        });
    });

    before(function(done) {

        mempass.getOptions().reset();
        mempass.generate(value, function (err, result) {

            if (err) {

                passwordResult = err;
            } else {

                passwordResult = result;
            }
            done();
        });
    });

	before(function(done) {

        mempass.getOptions().reset();
		mempass.sha256(value, function (err, result) {

			if (err) {

				sha256result = err;
			} else {
				
				sha256result = result;
			}
			done();
		});
	});



	it("Check Intial Value", function () {

		var expected = "mempass-ssapmem-|" + seed + ".)";
		test.string(mempass.getIntialValue(value)).is(expected);
	});

	it("Check Intial Hash", function () {

		var expected = "f7cfd42bede24827d8a373d25f4eb3f2c4cd5e7123a7bd96cd0d7d3e8019a9bf";
		test.string(intialHash).is(expected);

	});

	it("Check SHA256", function () {

		var expected = "15c0358bdf1c6c662fa77f7ad8118ed01aa8f2a4b16e7dcb9f5c881f19ee1f4c";
		test.string(sha256result).is(expected);

	});

	it("Check Basic Algorythm", function () { 

		test.string(passwordResult).is(expected);
	});

    it("Check Basic Algorythm 2", function () {

        test.string(passwordResult2).is(expected2);
    });

    it("Check Basic Algorythm 3", function () {

        test.string(passwordResult3).is(expected3);
    });

	it("Check String Reverse", function () {

		test.string(mempass.stringReverse("Reversed String Value *")).is("* eulaV gnirtS desreveR");
	});

	it("Check String Sum", function () {

		test.number(mempass.stringSum("abc")).is(294);
	});

	it("Check String Sum 2", function () {

		test.number(mempass.stringSum("abcDEFg")).is(604);
	});

	it("Check Remove Number", function () {

		test.string(mempass.removeNumberPass("567abc567")).is("nnnabcnnn");
	});

	it("Check Capital Letter Pass", function () {

		test.string(mempass.capitalLetterPass("abcDEFg")).is("AbCdEFg");
	});

	it("Check Capital Letter Pass 2", function () {

		test.string(mempass.capitalLetterPass("12345")).is("12345An");
	});

	it("Check Special Char Pass", function () {

		test.string(mempass.specialCharPass("mempass-mempass-mempass")).is("@$m(~&s{mempass{mempass");
	});

    it("Check Special Char Pass 2", function () {

        test.string(mempass.specialCharPass("mempassroadrabbit-mempass")).is("#@m^+!s$&a(ra}b~={mem^ass");
    });

    it("Check Special Char Pass 3", function () {

        test.string(mempass.specialCharPass("mempassrig^&8s-mempass")).is("%_m#+$s&(=^`@s!memp+ss");
    });


});