<link rel="stylesheet" href="/css/assets/template/message.css" type="text/css">
<cfparam name="attributes.tab" default="1">
<cfparam name="attributes.subtab" default="1">
<cfparam name="attributes.userno" default="">
<script src="https://www.gstatic.com/dialogflow-console/fast/messenger/bootstrap.js?v=1"></script>
<df-messenger
    intent="WELCOME"
    chat-title="Workcube Bot"
    agent-id="3aa337e9-30cc-4197-8d5a-d85bd170269d"
    language-code="en"
    chat-icon="css/assets/icons/catalyst-icon-svg/dialogflow.svg"
></df-messenger>
<div class="flowcard">
    <h4 class="flowcard-header">
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.welcome"><img src="images/helpdesklogo.png" title="Homepage"/></a>
        <label class="flowlabel" onclick="location.href = '<cfoutput>#request.self#?fuseaction=objects.chatflow&tab=1&subtab=#attributes.subtab#</cfoutput>'" id="chat"><i class="fa fa-comments-o"></i><i><cf_get_lang dictionary_id='62192.ChatFlow'></i></label>
        <label class="flowlabel" onclick="location.href = '<cfoutput>#request.self#?fuseaction=objects.workflowpages</cfoutput>&tab=2'" id="workflow"><i class="fa fa-bell-o"></i><i><cf_get_lang dictionary_id='31032.Workflow'></i></label>
        <cfif get_module_user(30)><label class="flowlabel" onclick="window.open('<cfoutput>#request.self#?fuseaction=process.list_warnings</cfoutput>','WorkFlow')" id="notifications" style="border-right:none !important;"><i class="fa fa-list-ul"></i><i><cf_get_lang dictionary_id='62193.Tüm Uyarı ve Onaylar'></i></label></cfif>
        <label class="flowlabel" style="float: right;">
            <div class="portHeadLightMenu">
                <ul>
                    <li>
                        <a href="javascript://"><i class="fa fa-1-5x fa-cog not" style="font-size:22px;"></i></a>
                        <ul style="display: none; opacity: 1;">
                            <li>
                                <div class="checkbox checbox-switch" id="notificationPer">
                                    <label>
                                        <input type="checkbox">
                                        <span></span>
                                        <cf_get_lang dictionary_id='62194.Bildirimleri Al'>
                                    </label>
                                </div> 
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </label>
    </h4>
    <div class="flowcard-body col col-12 scrollbar" id="flowcard-body">
    </div>
</div>

<script>

    <cfset actionUrl = "">
    <cfloop list="#cgi.QUERY_STRING#" index="param" delimiters="&">
        <cfset actionUrl &= (not findNoCase('fuseaction',param) and LCase(param) neq 'tab=3') ? param & "&" : "">
    </cfloop>

    $(function(){	
        if(<cfoutput>#attributes.tab#</cfoutput> == 1){
            var actionUrl = '<cfoutput>#Left(actionUrl, len(actionUrl)-1)#</cfoutput>';
            openTab(1,actionUrl);
        }else if(<cfoutput>#attributes.tab#</cfoutput> == 2) {
            var actionUrl = '<cfoutput>#Left(actionUrl, len(actionUrl)-1)#</cfoutput>';
            openTab(2,actionUrl);
        }else if(<cfoutput>#attributes.tab#</cfoutput> == 3){
            var actionUrl = '<cfoutput>#Left(actionUrl, len(actionUrl)-1)##(isDefined("attributes.page_type") ? "&page_type=#attributes.page_type#" : "")#</cfoutput>';
            openTab(3,actionUrl);
        }
    });

    function openTab(key,actionUrl,messageUserid,storageFilter = false){
        //key = 1 > chat , key = 2 > Workflow(Uyarı ve Onaylar) , key = 3 > Workflow Detail
        if(key == 1){
            var newUrl = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_message&' + actionUrl;
            AjaxPageLoad(newUrl,'flowcard-body');
            if( messageUserid ){
            setTimeout(function(){
                get_all_messages(messageUserid);
            },1000);
            }
            $("#chat, .fa-comments-o").css("color", "black");
            $("#workflow, #thinkflow, #knowledge, .fa-bell-o, .fa-lightbulb-o, .fa-sliders").css("color", "rgba(0,0,0,.5)");
            //history.pushState('', 'title', '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.chatflow&tab=1');
        }else if(key == 2){
            var newUrl = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_warning&' + actionUrl;
            AjaxPageLoad(newUrl + '&storageFilter=' + ((storageFilter) ? 1 : 0) + '','flowcard-body');
            $("#workflow, .fa-bell-o").css("color", "black");
            $("#chat, #thinkflow, #knowledge, .fa-comments-o, .fa-lightbulb-o, .fa-sliders").css("color", "rgba(0,0,0,.5)");
            history.pushState('', 'title', '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=2<cfoutput>#(isDefined("attributes.page_type") ? "&page_type=#attributes.page_type#" : "")#</cfoutput>');
        }else if(key == 3 && actionUrl){
            $("#workflow, .fa-bell-o").css("color", "black");
            $("#chat, #thinkflow, #knowledge, .fa-comments-o, .fa-lightbulb-o, .fa-sliders").css("color", "rgba(0,0,0,.5)");
            history.pushState('', 'title', '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&'+actionUrl);
            var newUrl = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_page_warnings&' + actionUrl;
            AjaxPageLoad(newUrl,'flowcard-body');
        }
    }

    function get_all_messages(employeeid){
        window.messagepageid = employeeid;
        AjaxPageLoad('V16/objects/display/dsp_all_message.cfm?&employee_id='+employeeid,'get_all_right_message');
        if($(window).width() < 769) $(".person-list").css({"display":"none"});  
    }
    <cfif len(attributes.userno)>
        $( window ).load(function() {
            get_all_messages(<cfoutput>#attributes.userno#</cfoutput>);
        });
    </cfif>
    function notificationPer() {
        if (!('Notification' in window)) console.log('Notification API not supported!');
        else Notification.requestPermission(function (result) {
        if( result == 'granted' ) $("#notificationPer input[type = checkbox]").prop("checked",true);
        else $("#notificationPer input[type = checkbox]").prop("checked",false);
        });
    }

    if (!('Notification' in window)) console.log('Notification API not supported!');
    else{
        if( Notification.permission == 'granted' ) $("#notificationPer input[type = checkbox]").prop("checked",true);
        else $("#notificationPer input[type = checkbox]").prop("checked",false);
    }

    $("#notificationPer").click(function() { notificationPer() });

    <cfoutput>setWarningCounts( #totalMessageCount#, #warningCount#, 'WorkFlow' );</cfoutput><!--- header.cfm den gelir || warningCount : Bildirim Sayısı, totalMessageCount : Mesaj Sayısı  --->
        
    /* DialogFlow */
    window.addEventListener('dfMessengerLoaded', function (event) {
        $r1 = document.querySelector("df-messenger");
        $r2 = $r1.shadowRoot.querySelector("df-messenger-chat");

        let sheet1 = new CSSStyleSheet;
        sheet1.replaceSync( 'div.chat-wrapper[opened="true"] { margin-bottom: 100px; height: 500px };');
        $r2.shadowRoot.adoptedStyleSheets = [ sheet1 ];

        let sheet2 = new CSSStyleSheet;
        sheet2.replaceSync( 'button#widgetIcon .df-chat-icon.hidden { opacity: 100 };');
        let sheet3 = new CSSStyleSheet;
        sheet3.replaceSync( 'button#widgetIcon { background-color: rgba(0,0,0,0); box-shadow: none; margin-bottom: 100px };');
        $r1.shadowRoot.adoptedStyleSheets = [ sheet2, sheet3 ];
    });
    /* // DialogFlow */
    
</script>