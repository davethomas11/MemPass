function MemPassOptions() {

	this.specialCharMod = 3;
	this.capitalLetterMod = 7;
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

	var self = this;

	var _properties = ["hasNumber", "hasCapital", "hasDiceWords", "characterLimit", "specialChars"];

	this.reset = function () {

		self.hasNumber = true;
		self.hasCapital = true;
		self.hasDiceWords = true;
		self.characterLimit = 0;
		self.specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"];

		self.saveDefaults();

	}

	this.getSpecialCharString = function() {

		var specCharString = ""
		for (i in self.specialChars) {
			specCharString += self.specialChars[i];
		}

		return specCharString;
	}

	this.loadDefaults = function() {

		if (isChrome) {

			chrome.storage.sync.get(null, 
				function (items) {

					for (i in _properties) {
						if (typeof items[_properties[i]] != "undefined") {
							self[_properties[i]] = items[_properties[i]];
						}
					}

			});
		}
	}

	this.saveDefaults = function () {
		
		if (isChrome) {

			chrome.storage.sync.set({
				"hasNumber" : self.hasNumber,
				"hasCapital" : self.hasCapital,
				"hasDiceWords" : self.hasDiceWords,
				"characterLimit" : self.characterLimit,
				"specialChars" : self.specialChars
			});

		}
	}

	this.settingsString = function() {

		var settings = "";
		settings += self.hasNumber ? 1 : 0;
		settings += ".";
		settings += self.hasCapital ? 1 : 0;
		settings += ".";
		settings += self.hasDiceWords ? 1 : 0;
		settings += ".";
		settings += self.characterLimit 
		settings += ".";
		settings += self.getSpecialCharString();

		return settings;
	}

	this.parseSettingsString = function (settings, save) {

		var parts = settings.split(".");

		if (parts.length >= 4) {

			if (parts[0] === "0") {
				self.hasNumber = false;
			} else if (parts[0] === "1") {
				self.hasNumber = true;
			}

			if (parts[1] === "0") {
                self.hasCapital = false;
            } else if (parts[1] === "1") {
                self.hasCapital = true;
            }
            
            if (parts[2] === "0") {
                self.hasDiceWords = false;
            } else if (parts[2] === "1") {
                self.hasDiceWords = true;
            }
            
            if (Number.isInteger(parseInt(parts[3]))) {
                self.characterLimit = parseInt(parts[3]);
            }

            if (parts.length > 4) {
            	
            	self.specialChars = settings.replace(/^([0-9]+.){4}/, "").split("");

        	}

        	if (save !== false) {
            	self.saveDefaults();
        	}

		}
	}

}