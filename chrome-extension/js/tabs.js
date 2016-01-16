toastr.options = {
    "positionClass": "toast-bottom-center",
    "preventDuplicates": true
}
var qr = null;
var scanning = false;

$(function() {
    $( "#tabs" ).tabs({
    	load: function (event, ui) {
    		
            $('#phrase').addClear({onClear:phraseCleared});
            $('#show').click(showPhrase);
            $('#mempassResult').click(selectPhrase);
            $('#copyToClipboard').click(copyMemPassToClipboard);

            $('#seedQR').each(generateQR);
            $('#CopySeed').click(copySeedToClipboard);
            $('#ViewSeed').click(viewSeed);
            $('#seedBottomRight').click(confirmReSeed);
            $('#EnterSeed').button().click(enterSeed);
            $('#ScanSeed').button().click(scanSeed);

            var opts = mempass.getOptions();

            $('#includeCapitals').attr('checked', opts.hasCapital);
            $('#includeNumbers').attr('checked', opts.hasNumber);
            $('#includeDiceWords').attr('checked', opts.hasDiceWords);
            $('#specialCharacters').val(opts.getSpecialCharString());
            if (opts.characterLimit > 0) {
                $('#characterLimit').val(opts.characterLimit);
            }
    	}
    });

    
 });

function enterSeed() {
    var seed = null;

    $("#dialog-enter-seed").dialog({
        resizable: false,
        modal: true,
        title: "ReSeed",
        height: 180,
        width: 200,
        buttons: {
            "Done": function () {
                $(this).dialog('close');
                reSeed($('#enteredSeed').val());
            },
            "Cancel": function () {
                $(this).dialog('close');
            }
        }
    });

    
}

function scanSeed() {
    if (scanning) {
        return;
    }
    scanning = true;

    var origBottom = $('#qrScanner').css("bottom");

    $('#reader').html5_qrcode({

        videoStart : function () {
            $('#qrScanner').animate({ bottom: 0 });
        },

        qrcodeSuccess : function(data, stream){
            
            console.log(data);
            reSeed(data);
            closeScan();
        }, 

        videoError: function(videoError){
            
            toastr.error("No web camera available. " + videoError);
        }

    });
    
    $('#closeScanner').button({
        icons: { primary: "ui-icon-closethick" },
        label: "Cancel"

    }).unbind('click').click(function () {

        closeScan();
    });

    function closeScan() {

        $('#reader').html5_qrcode_stop();
        $('#qrScanner').animate({ bottom: origBottom }, function () {
            $('#reader').html("");
        });
        scanning = false;

    }
}

function confirmReSeed() {

    
    $("#dialog-confirm").html(
        '<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>'+
        "Warning! This will change all your passwords. ReSeed passwords?</p>");

    $("#dialog-confirm").dialog({
        resizable: false,
        modal: true,
        title: "ReSeed",
        height: 170,
        width: 240,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
                reSeed();
            },
            "No": function () {
                $(this).dialog('close');
            }
        }
    });
        
    
}

function reSeed(newSeed) {
    mempass.reSeed(newSeed, function (seed) {

        if ($('#ViewSeed').html() != "View Seed") {
            showSeed();
        }

        qr.makeCode(seed);
    });
}

function generateQR() {
    var seed = mempass.memPassSyncKey();
    var element = document.getElementById("seedQR");

    qr = new QRCode(element, seed);
}

function viewSeed() {

    if ($('#ViewSeed').html() == "View Seed") {
        
        showSeed();
    } else {

        $('#ViewSeed').html("View Seed");
    }
}

function showSeed() {
    var seed = mempass.memPassSyncKey();
    var half1 = seed.substring(0, Math.floor(seed.length / 2));
    var half2 = seed.substring(Math.floor(seed.length / 2), seed.length);
    $('#ViewSeed').html(half1 + "<br/>" + half2);
}

function copySeedToClipboard() {
    if (copyTextToClipboard(mempass.memPassSyncKey())) {
        toastr.info('Seed copied to clipboard');
    } else {
        toastr.error('Error coping seed to clipboard!');
    }
}

function copyMemPassToClipboard() {
    if (copyTextToClipboard($('#mempassResult').attr('mempass'))) {
        toastr.info('Password copied to clipboard');
    } else {
        toastr.error('Error coping password to clipboard!');
    }
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
    var success = false;
    try {
        success = document.execCommand('copy');
    } catch (err) {
        console.log(err);
        
    }

    document.body.removeChild(textArea);
    return success;
}
