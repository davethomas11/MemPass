function MemPassOptions() {

	this.specialCharMod = 7;
	this.capitalLetterMod = 7;
	this.diceMod = 4;
	this.numberReplace = "n";
	this.defaultUppercase = "A";
	this.diceOffset = 100000;
	this.diceLeftBrace = "-> ";
    this.diceRightBrace = " <-";

	this.applyLimitBeforeDice = false;
	this.hasNumber = true;
	this.hasCapital = true;
	this.hasDiceWords = true;
	this.characterLimit = 0;
	this.specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"];

    var _properties = [
        "applyLimitBeforeDice",
        "hasNumber",
        "hasCapital",
        "hasDiceWords",
        "characterLimit",
        "specialChars"
    ];

	var self = this;

	this.reset = function () {

		self.applyLimitBeforeDice = false;
		self.hasNumber = true;
		self.hasCapital = true;
		self.hasDiceWords = true;
		self.characterLimit = 0;
		self.specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"];

		self.saveDefaults();

	};

	this.getSpecialCharString = function() {

		var specCharString = "";
		for (var i = 0; i < self.specialChars.length; i++) {
			specCharString += self.specialChars[i];
		}

		return specCharString;
	};

	this.loadDefaults = function() {

		if (isChrome && chrome.storage) {

			chrome.storage.sync.get(null, 
				function (items) {


					for (var i = 0; i < _properties.length; i++) {
						if (typeof items[_properties[i]] != "undefined") {
							self[_properties[i]] = items[_properties[i]];
						}
					}

			});
		}
	};

	this.saveDefaults = function () {
		
		if (isChrome) {

            var settings = {};
            for (var i = 0; i < _properties.length; i++) {
                settings[_properties[i]] = self[_properties[i]];
            }

            if (chrome.storage) {
                chrome.storage.sync.set(settings);

            }
		}
	};

	this.settingsString = function() {

		var settings = "";
        for (var i = 0; i < _properties.length; i++) {
            var prop = self[_properties[i]];

            if (typeof prop == 'boolean') {
                settings += (prop ? 1 : 0) + ".";
            } else if (typeof prop == 'object' && prop.length > 0) {
                settings += self.getSpecialCharString();
            } else {
                settings += prop + ".";
            }

        }

		return settings;
	};

	this.parseSettingsString = function (settings, save) {

        var parts = settings.split(".");
        var firstPropertiesLength = _properties.length - 1;

		if (parts.length >= _properties.length) {

            for (var i = 0; i < _properties.length; i++) {
                var prop = self[_properties[i]];

                if (typeof prop == 'boolean') {

                    self[_properties[i]] = parts[i] == 1;

                } else if (typeof prop == 'number') {

                    self[_properties[i]] = parseInt(parts[i]);
                }
            }

            if (parts.length > firstPropertiesLength) {

                var regex = new RegExp("^([0-9]+.){" + firstPropertiesLength + "}");
            	self.specialChars = settings.replace(regex, "").split("");

        	}

        	if (save !== false) {

            	self.saveDefaults();
        	}

		}
	}

}