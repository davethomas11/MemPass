var inNode = false;
var isChrome = typeof chrome == "undefined" ? false : true;

if (typeof window === 'undefined' && exports) {
	inNode = true;
	exports.MemPass = MemPass;

} 

function MemPass(injection) {
	injection = typeof injection !== 'undefined' ? injection : false;

	var self = this;
	var options = new MemPassOptions();
	var dice = new MemPassDice(injection);
	var phrase = "";

	var loading = true;

	var cryp = inNode ? injection.crypto : crypto;

	if (inNode) {
		cryp.getRandomValues = injection.getRandomValues;
	}

	options.loadDefaults();

	var seed = "";

	this.READY = "READY";
	this.PENDING = "PENDING";


	this.readyState = function() {
		return loading ? "PENDING" : "READY";
	}

	this.getSeed = function() {
		return seed;
	}

	this.setSeed = function(nseed) {
		seed = nseed;
	}

	this.getPhrase = function () {
		return phrase;
	}

	this.setPhrase = function (p) {
		phrase = p;
	}

	this.getDice = function() {
		return dice;
	}

	this.getOptions = function () {
		return options;
	}

	this.reSeed = function(reSeed, callback) {

		function done() {

			if (typeof chrome !== 'undefined') {
				chrome.storage.sync.set({"seed":seed});
			}

			if (callback) {
				callback(seed);
			}
		}

		if (!reSeed) {

			self.newSeed(function (err, s) {
				
				if (s) {
					
					seed = s;
				} else {

					seed = self.randomValue();
				}

				done();
			});

		} else if (reSeed.indexOf("|")) {

			seed = self.parForOptions(reSeed);

			done();

		} else if (reSeed) {

			seed = reSeed;
			
			done();

		} else if (callback) {

			callback(seed);
		}
	}

	this.getIntialValue = function(mempass) {

		return mempass + "-" + self.stringReverse(mempass) + "-|" + seed + ".)";
	}

	this.getIntialHash = function(mempass, callback) {

		self.sha256(self.getIntialValue(mempass), callback);
	}

	this.generate = function(mempass, callback) {

		phrase = mempass;

		self.getIntialHash(mempass, function (err, mempass) {

			if (err) {

				callback(err, null);
			} else {

				if (options.specialChars.length > 0) {

					mempass = self.specialCharPass(mempass);
				}

				if (options.hasCapital) {

					mempass = self.capitalLetterPass(mempass);
				}

				if (!options.hasNumber) {

					mempass = self.removeNumberPass(mempass);
				}

				if (options.hasDiceWords) {

					self.diceWordPass(mempass, complete);
				
				} else {

					complete(mempass);
				}

				
			}

		});

		function complete(mempass) {

			if (options.characterLimit > 0 && options.characterLimit < mempass.length) {

				mempass = mempass.substring(0, options.characterLimit);
			}

			callback(null, mempass);
		}
	}

	this.memPassSyncKey = function () {

		return seed + "|" + options.settingsString();
	}

	this.newSeed = function(callback) {

		var now = new Date().getTime();
		var random = self.randomValue();
		var value = random + now;

		if (isChrome) {

			chrome.system.cpu.getInfo(function (info) {

				value += "_" + info.numOfProcessors;
				value += "_" + info.archName;
				value += "_" + info.features.join();

				var processors = info.processors;

				for (p in processors) {
					value += "_" + processors[p].user;
					value += "_" + processors[p].kernel;
					value += "_" + processors[p].idle;
					value += "_" + processors[p].total;
				}

				chrome.system.memory.getInfo(function (info) {

					value += "_" + info.capacity;
					value += "_" + info.availableCapacity;

					chrome.system.storage.getInfo(function (infos) {

						for (i in infos) {

							value += "_" + infos[i].id;
							value += "_" + infos[i].name;
							value += "_" + infos[i].type;
							value += "_" + infos[i].capacity;

						}

						self.sha256(value, callback);
					});
					
				});
				
			});
		} else {

			self.sha256("-" + now + value, callback);
		}
	}

	this.loadSeed = function() {

		if (isChrome) {

			chrome.storage.sync.get("seed", function (items) {

				if (typeof items["seed"] != "undefined") {
					
					seed = items["seed"];
					loading = false;
				} else {

					noseed();
				}
			});
		} else {

			noseed();
		}

		function noseed() {
			self.reSeed(null, function () {
						loading = false;
					});
		}
	}

	this.parseSeedForOptions = function(seed) {

		var parts = seed.split("|");

		if (parts.length > 1) {

			var optString = parts[1];
			if (parts.length > 1) {
				optString = seed.replace(parts[0] + "|", "");
			}

			seed = parts[0];

			options.parseSettingsString(optString);
		}

		return seed;
	}

	this.specialCharPass = function(mempass) {

		var occurences = {};

		for (var i = 0; i < mempass.length; i++) {

			var character = mempass.charAt(i);

			if (typeof occurences[character] === "undefined") {
				occurences[character] = 1;
			} else {
				occurences[character]++;
			}
		}

		var index = 0;
		var sorted = [];

		for (i in occurences) {
			sorted.push({
				character: i,
				occurences: occurences[i]
			});
		}

		sorted.sort(function (a, b) {
			if (a.occurences == b.occurences) {
				return a.character > b.character;
			}

			return a.occurences - b.occurences;
		});

		var specialChars = options.specialChars.slice();

		while (specialChars.length > 0 && sorted.length > 0) {

			var character = sorted[0].character;
			var value = character.charCodeAt(0);
			var specialCharIndex = value % specialChars.length;
			

			if (specialCharIndex >= specialChars.length || specialCharIndex < 0) {
				specialCharIndex = 0;
			}

			var specialChar = specialChars[specialCharIndex];

			if (index % options.capitalLetterMod == 0) {

				mempass = mempass.replace(self.regexEscape(character, "g"), specialChar);
			} else {

				mempass = mempass.replace(character, specialChar);
			}

			index++;

			sorted.shift();
			specialChars.splice(specialCharIndex, 1);

		}

		return mempass;
	}

	this.capitalLetterPass = function(mempass) {

		var target = (self.stringSum(mempass) % options.capitalLetterMod) + 1;
		var found = 0;
		var hasUpperCase = false;

		for (var i = 0; i < mempass.length; i++) {

			var letter = mempass.charAt(i).toString();

			if (letter.match(/[a-z]/)) {

				mempass = mempass.replace(letter, letter.toUpperCase());
				hasUpperCase = true;

				found++;

				if (target == found) {
					break;
				}
			}
		}

		if (!hasUpperCase) {

			mempass += options.defaultUppercase;
		}

		return mempass;
	}

	this.removeNumberPass = function(mempass) {

		return mempass.replace(/[0-9]/g, options.numberReplace);
	}

	this.diceWordPass = function(mempass, callback) {

		var wordCount = 0;
		var sum = self.stringSum(phrase + seed);
		var characterCount = mempass.length - 1;
		var offset = options.diceOffset;
		var target = (sum % options.diceMod) + 1;
		var parts = [""];
		var index = 1;

		dice.getWordCount(function (count) {
			wordCount = count;

			doDiceWord();
		});		

		function doDiceWord() {

			if (characterCount <= 0) {

				callback(parts.join("") + mempass);
				return;
			} 

			var position = sum % characterCount;
			var wordX = (sum * offset) % wordCount;

			if (wordX <= 0 || wordX >= wordCount) {
				wordX = 1;
			}

			dice.wordAt(wordX, function(word) {

				parts.push(mempass.substring(0, position));
				mempass = mempass.substring(position, mempass.length);

				if (options.specialChars.length > 0) {

					parts.push(options.diceLeftBrace + word + options.diceRightBrace);
				} else {

					parts.push(word);
				}

				characterCount = mempass.length;
				offset--;
				index++;

				if (index <= target) {
					
					doDiceWord();
				} else {

					callback(parts.join("") + mempass);
				}
			});
		};

	}

	this.stringSum = function(str) {

		var sum = 0;
		for (var i = 0; i < str.length; i++) {

			sum += str.charCodeAt(i);
		}

		return sum;
	}

	this.randomValue = function() {
		var randomPool = new Uint8Array(32);
    	cryp.getRandomValues(randomPool);

    	return self.ua2text(randomPool);
	}

	this.sha256 = function(value, callback) {

		if (inNode) {

			var hash = cryp.createHash('sha256');
			var r = hash.update(value, 'utf8');

			callback(null, r.digest('hex'));
		
		} else {

			_sha256(value).then(function(digest) {
				callback(null, digest);
			});
		}	
	}

	function _sha256(str) {

		var buffer = new TextEncoder("utf-8").encode(str);
		return crypto.subtle.digest("SHA-256", buffer).then(function (hash) {
	    	return hex(hash);
	  	});
	}

	function hex(buffer) {
		var hexCodes = [];
		var view = new DataView(buffer);
		for (var i = 0; i < view.byteLength; i += 4) {
		   
			var value = view.getUint32(i)

			var stringValue = value.toString(16)

			var padding = '00000000'
			var paddedValue = (padding + stringValue).slice(-padding.length)
			hexCodes.push(paddedValue);
		}

	  	return hexCodes.join("");
	}

	this.text2ua = function(s) {

	    var ua = new Uint8Array(s.length);

	    for (var i = 0; i < s.length; i++) {
	        ua[i] = s.charCodeAt(i);
	    }

	    return ua;
	}

	this.ua2hex = function(ua) {

		var s = '';

		for (var i = 0; i < ua.length; i++) {
			s += ua[i].toString(16);
		}

		return s;
	}
 
	this.ua2text = function(ua) {

	    var s = '';

	    for (var i = 0; i < ua.length; i++) {
	        s += String.fromCharCode(ua[i]);
	    }

	    return s;
	}

	this.stringReverse = function(string) {

		var regexSymbolWithCombiningMarks = /([\0-\u02FF\u0370-\u1AAF\u1B00-\u1DBF\u1E00-\u20CF\u2100-\uD7FF\uE000-\uFE1F\uFE30-\uFFFF]|[\uD800-\uDBFF][\uDC00-\uDFFF]|[\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?:[^\uD800-\uDBFF]|^)[\uDC00-\uDFFF])([\u0300-\u036F\u1AB0-\u1AFF\u1DC0-\u1DFF\u20D0-\u20FF\uFE20-\uFE2F]+)/g;
		var regexSurrogatePair = /([\uD800-\uDBFF])([\uDC00-\uDFFF])/g;
		// Step 1: deal with combining marks and astral symbols (surrogate pairs)
		string = string
			// Swap symbols with their combining marks so the combining marks go first
			.replace(regexSymbolWithCombiningMarks, function($0, $1, $2) {
				// Reverse the combining marks so they will end up in the same order
				// later on (after another round of reversing)
				return reverse($2) + $1;
			})
			// Swap high and low surrogates so the low surrogates go first
			.replace(regexSurrogatePair, '$2$1');
		// Step 2: reverse the code units in the string
		var result = '';
		var index = string.length;
		while (index--) {
			result += string.charAt(index);
		}
		return result;
	};

	this.regexEscape = function(s,f) {
    	
    	return RegExp(s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), f);
	};

	self.loadSeed();
}



