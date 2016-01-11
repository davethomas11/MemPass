var progressElement = null;

document.addEventListener('DOMContentLoaded', function() {

	progressElement = document.getElementById("status");

});

chrome.extension.onMessage.addListener(function (request, sender, sendResponse) {

	if (!request || !progressElement) {
		return
	}

	if (request.type == "progress") {

		var progress = Math.floor(request.progress * 100);
		progressElement.innerHTML = "Progress " + progress + " %";
		$( "#progressbar" ).progressbar({
      		value: progress
    	});

    	var action = document.getElementById("action");
    	action.innerHTML = "Indexing dice word: " + request.item.word;

	} else if (request.type == "status") {

		results(request.error, request.result);
	}
});

function results(err, action) {

	if (action == "error") {
			progressElement.innerHTML = "Install failed! " + err;
	} else if (action == "complete") {
			showCloseButton();
	} else if (action == "success") {
			progressElement.innerHTML = "Completed.";
	}

}

function showCloseButton() {
	var title = document.getElementById("title");
	title.innerHTML = "MemPass Ready!";
	var close = document.getElementById("close");

	close.addEventListener("click", function () {
		window.close();
	});

	setTimeout(function () {
		window.close();
	}, 3000);

	$('#action').fadeOut(function () {
		$('#close').fadeIn();
	});
}