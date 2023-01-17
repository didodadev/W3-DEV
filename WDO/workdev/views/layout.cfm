<cfquery name="qUserFriendly" datasource="#dsn#">
    SELECT FRIENDLY_URL, HEAD FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#attributes.fuseact#" cfsqltype="cf_sql_nvarchar">
</cfquery>
<style>
.modalMenuContent {
	background: #2b3643;
}
ul.modalMenu li {
    border-bottom:none;
	background: transparent;
}
ul.modalMenu li:hover {
    background:#2b3643;
}
.fs .modal-header {
	background: #2b3643 !important;
	border-bottom: 1px solid #fff !important;
	box-shadow: -20px -12px 15px 9px rgba(0, 0, 0, 0.1);
}
.modal-header-buttons i {
	height: 26px;
    background: transparent;
    font-size:16px;
}
.modal-header-buttons i:hover {
    background:transparent;
	border-bottom:2px solid #fff;
}
</style>
<script type="text/javascript">
    <cfif isDefined("attributes.fuseact")>
    window.fuseact = '<cfoutput>#attributes.fuseact#</cfoutput>';
    window.friendly = '<cfoutput>#qUserFriendly.FRIENDLY_URL#</cfoutput>';
    <cfelse>
    window.fuseact = "";
    window.friendl = "";
    </cfif>
</script>
<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
<script src="/JS/assets/plugins/menuDesigner/jquery.nestable.min.js"></script>
<script src="/JS/assets/plugins/menuDesigner/bootstrap-select.min.js"></script>

<link rel="stylesheet" href="/WDO/workdev/assets/layout.css" type="text/css">
    <div class="fs" id="workDev" style="">
        <div class="modal-dialog" id="modalContainer">
            <div class="modal-content">
                <div class="modal-header">
                 <div class="modal-logo"><img src="images/w3-white.png" title="Workcube Catalyst"></div>
                   <div class="modal-header-buttons" id="workdevtopmenu">
                       <!---  <i class="mhdText" onclick="Router.navigate('cs')" title="Class Document">CS</i> 
                        <i class="mhdText" onclick="Router.navigate('icn')" title="Icons">IC</i> 
                        <i class="mhdText" onclick="Router.navigate('is');" title="Implementation Steps">IS</i>
                        <i class="mhdText" onclick="Router.navigate('qpic')" title="QPIC-RS">QP</i> 
                        <i class="mhdText" onclick="Router.navigate('bp');" title="Best Practice">BP</i>
                        <i class="mhdText" onclick="Router.navigate('md')" title="Modul Menu">MD</i> --->
                        <a href="<cfoutput>#request.self#?fuseaction=dev.tools</cfoutput>" target="_blank" title="Dev Tools"><i class="catalyst-folder-alt"></i></a>
                       <!---  <i class="mhdText" onclick="Router.navigate('tst')" title="Testkits">TST</i>
                        <i class="mhdText" onclick="Router.navigate('sc')" title="Schema Compare">SC</i>
                        <i class="mhdText" onclick="Router.navigate('db')" title="Database">DB</i>
                        <i class="mhdText" onclick="Router.navigate('ut')" title="Utility">UT</i>
                        <i class="mhdText" onclick="Router.navigate('widget');" title="Widgets">WI</i>
                        <i class="mhdText" onclick="Router.navigate('wo');" title="Workcube Objects">WO</i>
                        <i class="mhdText" onclick="Router.navigate('wx');" title="WEX">WX</i> --->
                    </div> 
                    <h4 class="modal-title">workDev / <cfoutput>#qUserFriendly.HEAD#</cfoutput> <span class="workdevMenuTitle"></span></h4>
                </div>
                <div class="modal-body-content scrollContent">
                    <div class="modalMenuContent">
                        <ul class="modalMenu" id="workdevmenu">
                            <li onclick="Router.navigate('wrk')"  title="Workcube Object">
                                <i class="catalyst-info"></i>
                                <span class="title">Workcube Object</span>
                            </li>
                            <li onclick="Router.navigate('model')" title="Model">
                                <i class="catalyst-calculator" title="Model"></i>
                                <span class="title">Model</span>
                            </li>
                            <li onclick="Router.navigate('widget&selfwo=1')" title="Widgets">
                                <i class="fa fa-stack-overflow" ></i>
                                <span class="title">Widgets</span>
                            </li>
                            <li onclick="Router.navigate('event&selfwo=1')" title="Events">
                                <i class="catalyst-layers"></i>
                                <span class="title">Events</span>
                            </li>
                            <li onclick="Router.navigate('controller')" title="Controler">
                                <i class="catalyst-directions"></i>
                                <span class="title">Controller</span>
                            </li>
                            <li onclick="Router.navigate('trigger')" title="Trigger">
                                <i class="catalyst-link" ></i>
                                <span class="title">Trigger</span>
                            </li>
                            <li onclick="Router.navigate('output')" title="Output"><!---callPage('output');--->
                                <i class="catalyst-printer" ></i>
                                <span class="title">Output</span>
                            </li>                
                            <li onclick="Router.navigate('tst&fuse=<cfoutput>#attributes.fuseact#</cfoutput>&is_submited=1')" title="Test Results">
                                <i class="catalyst-eyeglasses"></i>
                                <span class="title">Test</span>
                            </li>
                            <li onclick="Router.navigate('support')" title="Helps">
                                <i class="catalyst-support"></i>
                                <span class="title">Helps</span>
                            </li>     
                        </ul>
                    </div>
                    <div class="modal-body">
                        <div id="warningContainer"></div>
                        <div class="workDevTab" id="workDev-page-content">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="/WDO/workdev/assets/router.js" type="text/javascript"></script>
    <script src="/JS/assets/custom/script.js" type="text/javascript"></script>
    <style rel="stylesheet">
        @media screen and (max-width: 768px) {
            .workdevList-heading {
                margin-top: 1em;
            }
            .modal-header-buttons {
                margin: -15px 0 15px 0;
            }
            .modalMenuContent {
                height: calc(100% - 50px);
            }
            .workDevTab .workdevColPadding {
                padding: 0 !important;
            }
            .modalDbTableNfo label i {
                line-height: 28px !important;
            }
            .fs .modal-body-content {
                margin-bottom: -50px;
            }
            .fs .modal-body {
                max-height: calc(100% - 50px);
            }
        }
</style>
<script src="/JS/assets/plugins/menuDesigner/popper.min.js" crossorigin="anonymous"></script>
<script src="/JS/assets/plugins/menuDesigner/bootstrap.min.js" crossorigin="anonymous"></script>