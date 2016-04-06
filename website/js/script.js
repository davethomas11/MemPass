toastr.options = {
    "positionClass": "toast-bottom-center",
    "preventDuplicates": true
};
var qr = null;
var scanning = false;
var mempass = new MemPass();

$(function () {


    $('#phrase').addClear({onClear: phraseCleared});
    $('#show').click(showPhrase);
    $('#mempassResult').click(selectPhrase);
    $('#copyToClipboard').click(copyMemPassToClipboard);

    $('#seedQR').each(generateQR);
    $('#CopySeed').click(copySeedToClipboard);
    $('#ViewSeed').click(viewSeed);
    $('#seedBottomRight').click(confirmReSeed);
    $('#EnterSeed').click(enterSeed);
    $('#ScanSeed').click(scanSeed);
    $('#ShowSeed').click(function () {
        $('#contextMenu').toggle("drop");
        $('#seedview').toggle('slideup');
    });


    $('#menu-btn').click(function () {

        $('#contextMenu').toggle("drop");
    });

    $('#closeseedview').click(function () {

        $('#seedview').toggle("slidedown");
    });

    $('#ReSeed').click(function () {
       reSeed();
        $('#contextMenu').toggle("drop");
    });


});

$(document).on('submit', '#mempass', function (e) {
    e.preventDefault();

    if ($('#phrase').val()) {


        $('#phrase').focus();

        mempass.generate($('#phrase').val(), function (err, result) {
            if (err) {
                console.log(err);
            } else if (result) {

                $('#mempassResult').html("Password Ready").fadeIn();
                $('#mempassResult').attr('mempass', result);
                $('#show').html('Show').fadeIn();
                $('#copyToClipboard').fadeIn();
            }
        });

    }


});


function enterSeed() {
    var seed = null;

    $('#contextMenu').toggle("drop");
    $("#dialog-enter-seed").dialog({
        resizable: false,
        modal: true,
        title: "ReSeed",
        height: 300,
        width: 300,
        buttons: {
            "Done": function () {
                $(this).dialog('close');
                if ($('#enteredSeed').val()) {
                    reSeed($('#enteredSeed').val());
                }
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
    $('#contextMenu').toggle("drop");

    var origBottom = $('#qrScanner').css("bottom");

    $('#reader').html5_qrcode({

        videoStart: function () {
            $('#qrScanner').fadeIn();
            $('#qrScanner').animate({bottom: 0});
        },

        qrcodeSuccess: function (data, stream) {


            reSeed(data);
            closeScan();
        },

        videoError: function (videoError) {

            toastr.error("No web camera available. " + videoError);
        }

    });

    $('#closeScanner').button({
        icons: {primary: "ui-icon-closethick"},
        label: "Cancel"

    }).unbind('click').click(function () {

        closeScan();
    });

    function closeScan() {

        $('#qrScanner').fadeOut();
        $('#reader').html5_qrcode_stop();
        $('#qrScanner').animate({bottom: origBottom}, function () {
            $('#reader').html("");
        });
        scanning = false;

    }
}

function customConfirm(message, title, confirm) {
    $("#dialog-confirm").html(
        '<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>' +
        message + "</p>");

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

        toastr.info("Seed set to: " + seed);

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
        alert("Sorry your web browser doesn't support this feature. Copy manually or try Google Chrome.");

    }

    document.body.removeChild(textArea);
    return success;
}
