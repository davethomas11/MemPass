
chrome.contextMenus.create({"title": "MemPass", "contexts": ["editable"], "onclick": function(info, tab) {

	chrome.tabs.sendMessage(tab.id, "getClickedEl", function(clickedEl) {
        
		var memPass = new MemPass();

		memPass.generate(clickedEl.value, function (err, mempass) {

			if (err) {
				console.log(err);
			} 

			chrome.tabs.sendMessage(tab.id, {type:"setClickedEl",value:mempass});
		});



    });
}});