$(function() {
    $( "#tabs" ).tabs({
    	load: function (event, ui) {
    		
    		$('#seedQR').each(function () {
    			

    			var seed = mempass.memPassSyncKey();
    			var element = document.getElementById("seedQR");

    			new QRCode(element, seed);
    		});

            $('#phrase').addClear({onClear:phraseCleared});
            $('#show').click(showPhrase);
            $('#mempassResult').click(selectPhrase);
            $('#copyToClipboard').click(copyToClipboard);
    	}
    });
 });

function copyToClipboard() {
    copyTextToClipboard($('#mempassResult').attr('mempass'));
}

function selectPhrase() {
    if ($('#show').html() == "Hide") {
        selectText('mempassResult');
    }
}

function showPhrase() {

    if ($(this).html() == "Show") {
        $(this).html("Hide");
        $('#mempassResult').html($('#mempassResult').attr('mempass'));

    } else {
        $(this).html("Show");
        $('#mempassResult').html("Password Ready");

    }
    
}

function phraseCleared() {

    $('#mempassResult').html("").fadeOut();
    $('#mempassResult').attr('mempass', "");
    $('#show').html('Show').fadeOut();
    $('#copyToClipboard').fadeOut();
}

function selectText(containerid) {
    
    if (document.selection) {
        var range = document.body.createTextRange();
        range.moveToElementText(document.getElementById(containerid));
        range.select();
    } else if (window.getSelection) {
        var range = document.createRange();
        range.selectNode(document.getElementById(containerid));
        window.getSelection().addRange(range);
    }
}

function copyTextToClipboard(text) {
    var textArea = document.createElement("textarea");

    textArea.style.position = 'fixed';
    textArea.style.top = 0;
    textArea.style.left = 0;
    textArea.style.width = '2em';
    textArea.style.height = '2em';
    textArea.style.padding = 0;
    textArea.style.border = 'none';
    textArea.style.outline = 'none';
    textArea.style.boxShadow = 'none';
    textArea.style.background = 'transparent';
    textArea.value = text;

    document.body.appendChild(textArea);

    textArea.select();

    try {
        var successful = document.execCommand('copy');
        var msg = successful ? 'successful' : 'unsuccessful';
        console.log('Copying text command was ' + msg);
    } catch (err) {
        console.log('Oops, unable to copy');
    }

    document.body.removeChild(textArea);
}
