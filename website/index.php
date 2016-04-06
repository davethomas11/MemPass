<!doctype html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/style.css"/>
    <link rel="stylesheet" href="css/jquery-ui.min.css"/>
    <link rel="stylesheet" href="css/toastr.min.css"/>


    <script src="js/sha256.js"></script>
    <script src="js/jquery.min.js"></script>
    <script src="js/jquery-ui.min.js"></script>
    <script src="js/qrcode.min.js"></script>
    <script src="js/html5-qrcode.js"></script>
    <script src="js/addclear.min.js"></script>
    <script src="js/toastr.min.js"></script>
    <script src="js/mempass.min.js"></script>
    <script src="js/script.js"></script>
</head>
<body>
<header>
    <h1>MemPass</h1>
</header>
<section id="section1">
    <div id="phone">

        <div id="dialog-confirm"></div>
        <div id="dialog-enter-seed" style="display:none;">
            <p>Enter your seed:</p>
            <input type="text" id="enteredSeed"/>
        </div>

        <div id="space">
            <div class="menu-btn" id="menu-btn">
                <div>SYNC TO APP</div>
                <span></span>
                <span></span>
                <span></span>

            </div>
            <div id="contextMenu">
                <ul>
                    <li id="EnterSeed">Enter Seed</li>
                    <li id="ScanSeed">Scan Seed</li>
                    <li id="ShowSeed">Show Seed</li>
                    <li id="ReSeed">ReSeed</li>
                </ul>
            </div>

        </div>
        <form id="mempass">
            <input type="password" placeholder="Enter a simple phrase" id="phrase"/>
        </form>

        <br/>
        <div id="mempassResult"></div>

        <div id="buttons">
            <button id="show">Show</button>
            <button id="copyToClipboard">Copy to Clipboard</button>
        </div>

        <div id="seedview" style="display:none;">
            <p id="closeseedview">x</p>
            <p id="ViewSeed">View Seed</p>
            <div id="seedQR"></div>
            <p id="CopySeed">Copy to Clipboard</p>
            <small>Note: seed is stored locally on your computer only</small>
        </div>


    </div>
</section>
<section id="section2">
    <small>Disclaimer: This is a client side application only. None of your information entered here is saved or sent
        remotely through the internet.
    </small>

    <br/>
    <br/>
    <a href="https://chrome.google.com/webstore/detail/mempass/hnlodhabpchholkbhgajfjabhokbglnn">
        <img src="img/ChromeWebStore_BadgeWBorder_v2_340x96.png"/>
    </a>
    <br/>
    <a href="https://itunes.apple.com/us/app/mempass/id1068402284?ls=1&mt=8">
        <img src="img/Download_on_the_App_Store_Badge_US-UK_135x40.svg" />
    </a>

    <br/>
    <br/>
    <p style="color:white; font-family: arial">Help support MemPass</p>
    <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
        <input type="hidden" name="cmd" value="_s-xclick">
        <input type="hidden" name="hosted_button_id" value="555KDQ7DELYWW">
        <input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
        <img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
    </form>

    <p class="copy">Copyright 2016 - <a href="http://www.daveanthonythomas.com">Dave Thomas</a></p>
</section>

<div id="qrScanner" style="display:none;">
    <h1>MemPass QR-Scan Sync</h1>
    <div id="closeScanner">
    </div>
    <div class="center" id="reader">
    </div>

</div>

<script>
    (function (i, s, o, g, r, a, m) {
        i['GoogleAnalyticsObject'] = r;
        i[r] = i[r] || function () {
                    (i[r].q = i[r].q || []).push(arguments)
                }, i[r].l = 1 * new Date();
        a = s.createElement(o),
                m = s.getElementsByTagName(o)[0];
        a.async = 1;
        a.src = g;
        m.parentNode.insertBefore(a, m)
    })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

    ga('create', 'UA-75910727-1', 'auto');
    ga('send', 'pageview');

</script>

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- mempass -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-5827844351178219"
     data-ad-slot="4505461080"
     data-ad-format="auto"></ins>
<script>
    (adsbygoogle = window.adsbygoogle || []).push({});
</script>

</body>
</html>