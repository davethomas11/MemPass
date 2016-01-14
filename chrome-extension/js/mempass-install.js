chrome.runtime.onInstalled.addListener(function (details) {

    install();

});

var installTabId;

function install() {
	chrome.storage.local.get("mempassDatabaseInstalled", function (items) {

		if (!items.mempassDatabaseInstalled) {

			createProgressWindow(installDatabase);
		}

	});
}

function createProgressWindow(callback) {
	chrome.tabs.create({
            url: chrome.extension.getURL('install-progress.html'),
            active: false
        }, function(tab) {

        	installTabId = tab.id;

            chrome.windows.create({
                tabId: tab.id,
                type: 'popup',
                focused: true,
                width: 300,
                height: 200
            });

            callback();
        });
}

function installDatabase() {

	var dice = new MemPassDice();

	dice.chromeInstall(function (err, success) {

		if (err) {
			console.log(err);
			error(err);
		} else if (success) {
			successful();
			chrome.storage.local.set({"mempassDatabaseInstalled":true});
		}

		complete();

	}, function (item, completed) {

		chrome.tabs.sendMessage(installTabId, {type:"progress",item:item, progress:completed});

	});

}

function error(error) {
	chrome.tabs.sendMessage(installTabId, {type:"status",result:"error",error:error});
}

function successful() {
	chrome.tabs.sendMessage(installTabId, {type:"status",result:"success"});
}

function complete() {
	chrome.tabs.sendMessage(installTabId, {type:"status",result:"complete"});

}

