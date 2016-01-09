
chrome.contextMenus.create({"title": "MemPass", "contexts": ["editable"], "onclick": function(info, tab) {

	chrome.tabs.sendMessage(tab.id, "getClickedEl", function(clickedEl) {
        alert(clickedEl.value);
    });
}});