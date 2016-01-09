var clickedEl = null;

document.addEventListener("mousedown", function(event){
    //right click
    if(event.button == 2) { 
        clickedEl = event.target;
    }
}, true);

chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
    if(request == "getClickedEl") {
        sendResponse({value: clickedEl.value});
    }
});