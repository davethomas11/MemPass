toastr.options = {
    "positionClass": "toast-bottom-center",
    "preventDuplicates": true
};
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

            setupSettings(false, opts);

            $('#optionReset').click(function () {
                customConfirm("Reset settings?", "Reset", function () {
                    opts.reset();
                    setupSettings(true, opts);

                });
            })
    	}
    });

    
 });

function setupSettings(nobind, opts) {

    setupBooleanSetting("applyLimitBeforeDice", opts, nobind);
    setupBooleanSetting("hasCapital", opts, nobind);
    setupBooleanSetting("hasNumber", opts, nobind);
    setupBooleanSetting("hasDiceWords", opts, nobind);

    $('#specialCharacters').val(opts.getSpecialCharString());
    if (opts.characterLimit > 0) {
        $('#characterLimit').val(opts.characterLimit);
    } else{
        $('#characterLimit').val("");
    }

    if (!nobind) {
        $('#characterLimit').bind('keyup change', function () {

            if (parseInt($(this).val()) > 0) {
                opts['characterLimit'] = parseInt($(this).val());
                opts.saveDefaults();
            }

        });

        $('#specialCharacters').keyup(function () {

            if ($(this).val()) {
                opts.specialChars = $(this).val().split("");
                opts.saveDefaults();
            } else {
                opts.specialChars = [];
                opts.saveDefaults();
            }

        });
    }
}

function setupBooleanSetting(name, options, nobind) {

    var id = "#" + name;

    $(id).prop('checked', options[name]);

    if (!nobind) {
        $(id).change(function () {
            options[name] = $(this).is(":checked");
            options.saveDefaults();
        });
    }
}

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

function customConfirm(message, title, confirm) {
    $("#dialog-confirm").html(
        '<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>'+
        message+"</p>");

    $("#dialog-confirm").dialog({
        resizable: false,
        modal: true,
        title: title,
        height: 170,
        width: 240,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
                confirm();
            },
            "No": function () {
                $(this).dialog('close');
            }
        }
    });
}

function confirmReSeed() {

    customConfirm("Warning! This will change all your passwords. ReSeed passwords?",
        "ReSeed", reSeed);

    
}

function reSeed(newSeed) {
    mempass.reSeed(newSeed, function (seed) {

        if ($('#ViewSeed').html() != "View Seed") {
            showSeed();
        }

        qr.makeCode(mempass.memPassSyncKey());
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
