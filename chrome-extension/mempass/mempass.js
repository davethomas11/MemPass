

function MemPass() {





}

function MemPassOptions() {

	this.hasNumber = true;
	this.hasCapital = true;
	this.characterLimit = 0;
	this.specialChars = ["!","@","#","$","%","^","`","~","&","*","(","=","_","{","+","}"];

	this.getSpecialCharString = function() {

		var specCharString = ""
		for (i in this.specialChars) {
			specCharString += this.specialChars[i];
		}

		return specCharString;
	}

	this.settingsString = function() {

		var settings = "";
		settings += this.hasNumber ? 1 : 0;
		settings += ".";
		settings += this.hasCapital ? 1 : 0;
		settings += ".";
		settings += this.characterLimit 
		settings += ".";
		settings += this.getSpecialCharString();


	}

	this.parseSettingsString(settings) = function () {

		
	}

}

