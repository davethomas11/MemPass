

function MemPass() {

	var options = new MemPassOptions();
	var dice = new MemPassDice();
	var phrase = "";

	options.loadDefaults();

	this.seed = ""

	this.reSeed = function(seed, callback) {

		if (typeof seed == "undefined") {

			newSeed(function (err, seed) {
				
				if (err) {
					this.seed = randomValue();
				} else {
					this.seed = seed;
				}

				callback(this.seed);
			});
		} else if (seed.indexOf("|")) {

			this.seed = parseSeedForOptions(seed);
			callback(this.seed);
		} else {

			this.seed = seed;
			callback(this.seed);
		}
	}

	this.generate = function(mempass, callback) {

		this.phrase = mempass;

		sha256(mempass + "-" + reverse(mempass) + "-" + this.seed, function (err, mempass) {

			if (err) {

				callback(err, null);
			} else {

				if (options.specialChars.length > 0) {

					mempass = specialCharPass(mempass);
				}

				if (options.hasCapital) {

					mempass = capitalLetterPass(mempass);
				}

				if (!options.hasNumber) {

					mempass = removeNumberPass(mempass);
				}

				if (options.hasDiceWords) {

					diceWordPass(mempass, complete);
				
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

		return this.seed + "|" + options.settingsString();
	}

	function newSeed(callback) {

		chrome.system.cpu.getInfo(function (info) {

			var now = new Date().getTime();
			var random = randomValue();

			var value = random + now;
			value += "_" + info.numOfProcessors;
			value += "_" + info.archName;
			value += "_" + info.features.join();

			for (p in processors) {
				value += "_" + processors[p].user;
				value += "_" + processors[p].kernel;
				value += "_" + processors[p].idle;
				value += "_" + processors[p].total;
			}

			chrome.system.memory.getInfo(function (info)) {

				value += "_" + info.capacity;
				value += "_" + info.availableCapacity;

				chrome.system.storage.getInfo(function (infos)) {

					for (i in infos) {

						value += "_" + infos[i].id;
						value += "_" + infos[i].name;
						value += "_" + infos[i].type;
						value += "_" + infos[i].capacity;

					}

					sha256(value, callback);
				});
				
			});
			
		});
	}

	function loadSeed() {

		chrome.storage.sync.get("seed", function (items) {

			if (typeof items["seed"] != "undefined") {
				
				this.seed = items["seed"];
			} else {

				reSeed();
			}
		});
	}();

	function parseSeedForOptions(seed) {

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

	function specialCharPass(mempass) {

		var occurences = {};

		for (var i = 0; i < mempass.length; i++) {

			if (typeof occurences[mempass.charAt(i)] === "undefined") {
				occurences[mempass.charAt(i).toString()] = 0;
			} else {
				occurences[mempass.charAt(i).toString()]++;
			}
		}

		var index = 0;
		var sorted = [];

		for i in occurences {
			sorted.push({
				character: i,
				occurences: occurences[i]
			});
		}

		sorted.sort(function (a, b) {
			return a.occurences - b.occurences;
		});

		var specialChars = options.specialChars;

		while specialChars.length > 0 && sorted.length > 0 {

			var character = sorted[0].character;
			var value = character.charCodeAt(0);
			var specialCharIndex = value % specialChars.length;

			if (specialCharIndex >= specialChars.length || specialCharIndex < 0) {
				specialCharIndex = 0;
			}

			var specialChar = specialChars[specialCharIndex];

			if (index % options.capitalLetterMod == 0) {

				mempass = mempass.replace(regexCreate(character, "g"), specialChar);
			} else {

				mempass = mempass.replace(character, specialChar);
			}

			index++;

			sorted.shift();
			specialChars.splice(specialCharIndex, 1);

		}

		return mempass;
	}

	function capitalLetterPass(mempass) {

		var target = (stringSum(mempass) % options.capitalLetterMod) + 1;
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

	function removeNumberPass(mempass) {

		return mempass.replace(/[0-9]/g, options.numberReplace);
	}

	function diceWordPass(mempass, callback) {

		var wordCount = dice.getWordCount();
		var sum = stringSum(this.phrase + this.seed);
		var characterCount = mempass.length - 1;
		var offset = options.diceOffset;
		var target = (sum % options.diceMod) + 1;
		var parts = [""];
		var index = 1;

		function doDiceWord() {

			if (characterCount <= 0) {

				callback(parts.join("") + mempass);
				return;
			} 

			var position = sum % characterCount;
			var wordX = (sum * offset) % wordCount;

			if wordX <= 0 || wordX >= wordCount {
				wordX = 1;
			}

			dice.wordAt(wordX, function(word) {

				parts.push(mempass.substring(0, position));
				mempass = mempass(position, mempass.length);

				if (options.specialChars.count > 0) {
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
		}();

	}

	function stringSum(str) {

		var sum = 0;
		for (var i = 0; i < str.length; i++) {

			sum += str.charCodeAt(i);
		}

		return sum;
	}

	function randomValue() {
		var randomPool = new Uint8Array(32);
    	crypto.getRandomValues(randomPool);

    	return ua2text(randomPool);
	}

	function sha256(value, callback) {

		crypto.subtle.digest({  

			name: "SHA-256",
	    
	    }, text2ua(value)).then(function(hash){

		    callback(null, ua2text(new Uint8Array(hash)));
		
		}).catch(function(err){

		    console.error(err);
		    callback(err, null);
		});
	}

	function text2ua(s) {

	    var ua = new Uint8Array(s.length);

	    for (var i = 0; i < s.length; i++) {
	        ua[i] = s.charCodeAt(i);
	    }

	    return ua;
	}
 
	function ua2text(ua) {

	    var s = '';

	    for (var i = 0; i < ua.length; i++) {
	        s += String.fromCharCode(ua[i]);
	    }

	    return s;
	}

	var regexSymbolWithCombiningMarks = /([\0-\u02FF\u0370-\u1AAF\u1B00-\u1DBF\u1E00-\u20CF\u2100-\uD7FF\uE000-\uFE1F\uFE30-\uFFFF]|[\uD800-\uDBFF][\uDC00-\uDFFF]|[\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?:[^\uD800-\uDBFF]|^)[\uDC00-\uDFFF])([\u0300-\u036F\u1AB0-\u1AFF\u1DC0-\u1DFF\u20D0-\u20FF\uFE20-\uFE2F]+)/g;
	var regexSurrogatePair = /([\uD800-\uDBFF])([\uDC00-\uDFFF])/g;

	var reverse = function(string) {
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

	var regexCreate = function(s,f) {
    	
    	return RegExp(s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), f);
	};
}

function MemPassDice() {

	var dbName = "Words";
	var dbVersion = 1;
	var isChrome = chrome ? true : false;
	var objectStore = "words";
	var indexKey = "wordId";

	this.getWordCount = function(callback) {

		if (isChrome) {

			return chromeWordCount(callback);

		} else {

			return callback(0);
		}
	}

	this.wordAt = function(index, callback) {

		if (isChrome) {

			chromeGetWordAt(index, callback);
		} else {

			callback("");
		}
	}

	this.chromeInstall = function(callback) {

		openIndexedDB(function (err, connection) {

			if (err) {
				
				console.log(err);
				if (callback) {
					callback(err, false);
				}

			} else {

				var xhr = new XMLHttpRequest();
				xhr.onload = function(event) {
					
					var data = event.target.response;
					var trans = connection.tranasaction(objectStore, "readwrite");

					for (i in data) {

						
						var store = trans.objectStore(objectStore);
						store.put({word:data[i].word, id:data[i].id});
					}

					connection.closePending = true;

					if (callback) {
						callback(null, true);
					}
				}
			
				xhr.open("GET", chrome.extension.getURL('/word.json'), true);
				xhr.type="json";
				xhr.send();

			}


		});

	}

	function chromeWordCount(callback) {

		openIndexedDB(function (err, connection) {

			if (err) {
				
				console.log(err);
				callback(0);
			} else {

				var transaction = connection.transaction(objectStore, "readonly");
				var words = transaction.objectStore(objectStore);
				var index = words.index(indexKey);
				
				callback(index.count());
				connection.closePending = true;

			}
 		});
	}

	function chromeGetWordAt(id, callback) {

		openIndexedDB(function (err, connection) {

			if (err) {
				
				console.log(err);
				callback("");

			} else {

				var trans = connection.transaction(objectStore, "readonly");
				var words = trans.objectStore(objectStore);
				var index = words.index(indexKey);
				var req = index.get(id);
				
				req.onSuccess = function () {

					callback(req.result.word);
					connection.closePending = true;
				};

				req.onError = function () {
					
					callback("");
					connection.closePending = true;
				};

			}
		});


		

	}

	function openIndexedDB(callback) {

		var req = indexedDB.open(dbName, dbVersion);
		req.onUpgradeNeeded = function(event) {
			var db = event.target;
			var store = db.createObjectStore(objectStore);
			store.createIndex(indexKey, "id", {unique:true});
		}

		req.onSuccess = function() {
			callback(null, req);
		}

		req.onError = function() {
			req.closePending = true;
			callback(req.error, null);
		}
	}

}

function MemPassOptions() {

	var isChrome = chrome ? true : false;

	this.specialCharMod = 3;
	this.capitalLetterMod = 4;
	this.diceMod = 4;
	this.numberReplace = "n";
	this.defaultUppercase = "A";
	this.diceOffset = 100000;
	this.diceLeftBrace = "-> ";
    this.diceRightBrace = " <-";

	this.hasNumber = true;
	this.hasCapital = true;
	this.hasDiceWords = true;
	this.characterLimit = 0;
	this.specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"];

	var _properties = ["hasNumber", "hasCapital", "hasDiceWords", "characterLimit", "specialChars"];

	this.getSpecialCharString = function() {

		var specCharString = ""
		for (i in this.specialChars) {
			specCharString += this.specialChars[i];
		}

		return specCharString;
	}

	this.loadDefaults = function() {

		if (isChrome) {

			chrome.storage.sync.get(null, 
				function (items) {

					for (i in _properties) {
						if (typeof items[_properties[i]] != undefined) {
							this[_properties[i]] = items[_properties[i]];
						}
					}

			});
		}
	}

	this.saveDefaults = function () {
		
		if (isChrome) {

			chrome.storage.sync.set({
				"hasNumber" : this.hasNumber,
				"hasCapital" : this.hasCapital,
				"hasDiceWords" : this.hasDiceWords,
				"characterLimit" : this.characterLimit,
				"specialChars" : this.specialChars
			});

		}
	}

	this.settingsString = function() {

		var settings = "";
		settings += this.hasNumber ? 1 : 0;
		settings += ".";
		settings += this.hasCapital ? 1 : 0;
		settings += ".";
		settings += this.hasDiceWords ? 1 : 0;
		settings += ".";
		settings += this.characterLimit 
		settings += ".";
		settings += this.getSpecialCharString();


	}

	this.parseSettingsString(settings) = function () {

		var parts = settings.split(".");

		if parts.length >= 4 {

			if parts[0] === "0" {
				this.hasNumber = false;
			} else if parts[0] === "1" {
				this.hasNumber = true;
			}

			if parts[1] === "0" {
                this.hasCapital = false
            } else if parts[1] === "1" {
                this.hasCapital = true
            }
            
            if parts[2] === "0" {
                this.hasDiceWords = false
            } else if parts[2] === "1" {
                this.hasDiceWords = true
            }
            
            if let limit = Int(parts[3]) {
                self.characterLimit = limit
            }

            this.saveDefaults();

		}
	}

}

