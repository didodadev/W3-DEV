<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
<meta name="content-language" content="<cfoutput>#session_base.language#</cfoutput>" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="mobile-web-app-capable" content="yes">
<link rel="manifest" href="../manifest.json">
<script>
    if ('serviceWorker' in navigator) navigator.serviceWorker.register('../whops-sw.js');
</script>
<title>Whops</title>
<script type="text/javascript" src="../asset/js/lib/workcube/js_functions.js"></script>
<script type="text/javascript" src="../asset/js/lib/js_calender/js/jscal2.js"></script>
<script type="text/javascript" src="../asset/js/lib/jquery/jquery-min.js"></script>
<script type="text/javascript" src="../asset/js/lib/jquery-ui/jquery-ui.js"></script>
<script type="text/javascript" src="../asset/js/lib/jquery-mobile/jquery.mobile.custom.js"></script>
<script type="text/javascript" src="../asset/js/lib/workcube/js_functions_all.js"></script>
<cfif not isdefined("session_base.userid") or (not isdefined("moneyformat_style")) or (isdefined("moneyformat_style") and moneyformat_style eq 0)>
    <script type="text/javascript" src="../asset/js/lib/workcube/js_functions_money_tr.js"></script>
<cfelse>
    <script type="text/javascript" src="../asset/js/lib/workcube/js_functions_money.js"></script>
</cfif>
<script async type="text/javascript" src="../asset/js/lib/workcube/autocomplete.js"></script>
<script async type="text/javascript" src="../asset/js/lib/workcube/printThis.js"></script>
<script type="text/javascript" src="../asset/js/lib/tablesorter/jquery.tablesorter2.js"></script>
<script type="text/javascript" src="../asset/js/lib/workcube/nano.js"></script>
<script type="text/javascript" src="../asset/js/lib/select2/js/select2.min.js"></script>
<script type="text/javascript" src="../asset/js/lib/AjaxControl/dist/build.js"></script>
<script type="text/javascript" src="../asset/js/script.js"></script>
<cfinclude template="../asset/js/special_functions.cfm">

<link rel="stylesheet" type="text/css" href="../asset/icons/icon-Set/font-awesome/4.7.0/css/font-awesome.css">
<link rel="stylesheet" type="text/css" href="../asset/icons/simple-line/simple-line-icons.css">
<link rel="stylesheet" type="text/css" href="../asset/icons/icon-Set/icon-Set.css">
<link rel="stylesheet" type="text/css" href="../asset/icons/fontello/fontello.css"> 
<link rel="stylesheet" type="text/css" href="../asset/css/lib/bootstrap/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../asset/js/lib/jquery-ui/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="../asset/js/lib/js_calender/css/border-radius.css">  
<link rel="stylesheet" type="text/css" href="../asset/css/svg.css">
<link rel="stylesheet" type="text/css" href="../asset/css/gui_custom.css">
<link rel="stylesheet" type="text/css" href="../asset/js/lib/select2/css/select2.min.css">
<link rel="stylesheet" type="text/css" href="../asset/css/style.css">
<link rel="stylesheet" type="text/css" href="../asset/css/lib/retail/whops.css">
<link rel="shortcut icon" type="image/x-icon" href="../asset/img/w.png">