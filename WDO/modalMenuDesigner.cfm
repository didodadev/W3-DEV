<!-- Bootstrap core CSS     -->
<link href="/css/assets/template/w3-menuDesigner/css/bootstrap-catalyst.css" rel="stylesheet" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
<link href='http://fonts.googleapis.com/css?family=Roboto:400,700,300' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="/css/assets/template/w3-menuDesigner/css//bootstrap-select.min.css">
<link rel="stylesheet" href="css/assets/icons/icon-Set/font-awesome/4.7.0/css/font-awesome.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/w3-menuDesigner/css/jquery.nestable.min.css" />
<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
<script src="/JS/assets/plugins/menuDesigner/jquery.nestable.min.js"></script>
<script src="/JS/assets/plugins/menuDesigner/bootstrap-select.min.js"></script>
<script src="/JS/assets/plugins/menuDesigner/popper.min.js" crossorigin="anonymous"></script>
<script src="/JS/assets/plugins/menuDesigner/bootstrap.min.js" crossorigin="anonymous"></script>
<cfparam  name="url.event" default="list">
<cfswitch expression = "#url.event#">
    <cfcase value="list">  
    <cfinclude template="\WDO\workdev\views\menuDesigner\listMenu.cfm">
</cfcase>
<cfcase value="add,upd">  
    <cfinclude template="\WDO\workdev\views\menuDesigner\designMenu.cfm">
</cfcase>
<cfdefaultcase>
        <cfinclude template="\WDO\workdev\views\menuDesigner\listMenu.cfm">
</cfdefaultcase>
</cfswitch>