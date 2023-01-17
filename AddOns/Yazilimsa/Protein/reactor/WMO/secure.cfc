<cfcomponent>
    <!--- Güvenlik kontrolleri burada yapılıyor --->
    <cffunction name="secure" returntype="string" output="false">
    	<cfargument name="fuseaction" required="true">
        <cfargument name="workcube_mode_ip" required="true">
        <cfargument name="dsn" required="true">
		<cfset Fuseaction_List = "home.emptypopup_ban,account.popup_add_financial_table,report.emptypopup_upd_table_definition,home.logout,home.emptypopup_calender_functions,home.emptypopup_special_functions,objects2.emptypopup_pm_kontrol">

		<!--- saldiri yapilan ip fbx_workcube_param dosyasındaki workcube_mode_ip tanımlarından farklı ise --->
        <cfif not ListFindNoCase(Fuseaction_List,arguments.fuseaction) and not ListFindNoCase(arguments.workcube_mode_ip,cgi.REMOTE_ADDR,',')>
            <!--- saldirganin saldiri sayisi --->
            <cfstoredproc procedure="GET_WRK_SECURE_BANNED_IP" datasource="#arguments.DSN#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                <cfprocresult name="GET_WRK_SECURE_BANNED_IP"> 
            </cfstoredproc>
            <cfif get_wrk_secure_banned_ip.recordcount>
                <cfset error_ban = "Yaptığınız Saldırılardan Dolayı Sistemden Uzaklaştırıldınız.Sistem Yöneticinize Başvurunuz">
                <cfoutput>#error_ban#</cfoutput>
                <cfabort>
            </cfif>
        
            <cfset attack=StructNew()>
            <cfset attack_return= StructNew()>
            <cfset attack.Remote_Addr = cgi.remote_addr>
            <cfset attack.Http_Host = cgi.http_host>
            <cfset attack.Http_Referer = cgi.http_referer>
            <cfset attack.Http_User_Agent = cgi.http_user_agent>
            <cfset attack.Http_Path_Info = cgi.path_info>
            <cfset attack.Query_String = cgi.query_string>
            <cfset attack.Remote_Host = cgi.remote_host>
            <cfset attack.Script_Name = cgi.script_name>
            <cfset attack.Server_Name = cgi.server_name>
            <cfset attack.X_Forwarded_For = cgi.x_forwarded_for>
            <cfset attack_return.type = 0>
            <cfset attack_return.attacked = false>
            <cfset note = "">
            <cfdump var="#variables#">
            
            <!--- Saldiri tipi belirleniyor --->
            <cfloop collection="#attack#" item="i">
                <cfset value = structfind(attack,i)>

                <cfif i eq 'Http_User_Agent' and (value contains "update" and not value contains "set")>
                    <cfset value = replacelist(value,'update','a')>
                </cfif>
                
                <cfset value = replacelist(value,'emptypopup_delete_cubemail,update_chapter,SUBSCRIPTION_RELATION,SUBSCRIPTION,add_subscription_cancel_type,subscription,table_name,columnlist,update_product_row_id,is_delete_info,is_delete,popup_update_email,is_delete_cargo,update_id,../add_options,description,all_delete,xml_is_order_row_deliver_date_update,AutoUpdate,_update,update_','a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a')>
                <cfif value contains ">"  or value contains "<"  or value contains 'wslite'><!---or value contains '(' or value contains ')' or value contains '[' or value contains ']' or value contains "script" or value contains "%3E" or value contains "%3C" or value contains '"'--->
                    <cfset note = "#note#  <b>[#i#]</b> : XSS Attack <!---XSS saldirisi.---><br/>"> 
                    <cfset attack_return.type = 1>
                    <cfset attack_return.attacked = true>
                </cfif>	
                
                <cfif value contains "'" or value contains "insert " or value contains "delete " or value contains "update" or value contains "truncate" or value contains "drop " or value contains "@@" or value contains "union" or value contains "sp_tables">
                    <!--- <cfif not isdefined("attributes.ajax")> --->
                        <cfset note = "#note#  <b>[#i#]</b> : SQL Injection Attack<!--- Sql Injection Saldirisi--->.<br/>">
                        <cfset attack_return.type = 2>
                        <cfset attack_return.attacked = true>
                    <!--- </cfif> --->
                </cfif>	
                
                <cfif value contains "../" or value contains "..\" >
                    <cfif i eq "query_string">
                        <cfset note = "#note#  <b>[#i#]</b> : Local File Acces Attack<!--- Sunucu yerel dosyaya ulasim istegi.---><br/>">
                        <cfset attack_return.type = 3>
                        <cfset attack_return.attacked = true>	
                    </cfif>
                </cfif>
                
                <cfif value contains "http:">
                    <cfif i eq "query_string">
                        <cfset note = "#note#  <b>[#i#]</b> : Remote File Caller Attack #value#<!--- Uzaktan yabanci dosya cagrilmak istendi.---><br/>">		
                        <cfset attack_return.type = 4>
                        <cfset attack_return.attacked = true>		
                    </cfif>	
                </cfif>
                
                <cfif value contains "cfsavecontent" or value contains "cffile" or value contains "cfhttp" or value contains "cfdirectory" or value contains "cfftp">
                    <cfif i eq "query_string">
                        <cfset note = "#note#  <b>[#i#]</b> : Coldfusion Attack <br/>">		
                        <cfset attack_return.type = 5>
                        <cfset attack_return.attacked = true>		
                    </cfif>	
                </cfif>
            </cfloop>
            
            <cfscript>
                function getRandString(stringLength) 
                {
                    var tempAlphaList = "a|b|c|d|e|g|h|i|k|L|m|n|o|p|q|r|s|t|u|v|w|x|y|z";
                    var tempNumList = "1|2|3|4|5|6|7|8|9|0";
                    var tempCompositeList = tempAlphaList&"|"&tempNumList;
                    var tempCharsInList = listLen(tempCompositeList,"|");
                    var tempCounter = 1;
                    var tempWorkingString = "";
                    
                    while (tempCounter LTE stringLength) {
                        tempWorkingString = tempWorkingString&listGetAt(tempCompositeList,randRange(1,tempCharsInList),"|");
                        tempCounter = tempCounter + 1;
                    }
                    return tempWorkingString;
                }
            </cfscript>
             
            <cfif attack_return.attacked is true>
                <cfstoredproc procedure="GET_WRK_SECURE_LOG" datasource="#DSN#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#attack.remote_addr#">
                    <cfprocresult name="GET_WRK_SECURE_LOG">
                </cfstoredproc>
                        
                <cfif get_wrk_secure_log.recordcount gte 2>
                    <cfquery name="BAN_IP" datasource="#DSN#">
                        INSERT INTO 
                            WRK_SECURE_BANNED_IP
                        (
                            REMOTE_ADDR,
                            LOG_ID,
                            RANDOM,
                            EMPLOYEE_ID
                        )
                        VALUES
                        (
                            <cfqueryparam value="#htmleditformat(attack.remote_addr)#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#GET_WRK_SECURE_LOG.id[1]#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#getRandString(50)#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">
                        )
                    </cfquery>
                
                </cfif>
                <cfquery name="ADD_WRK_SECURE_LOG" datasource="#DSN#">
                    INSERT INTO 
                        WRK_SECURE_LOG 
                    (
                        HTTP_HOST,
                        HTTP_REFERER,
                        HTTP_USER_AGENT,
                        PATH_INFO,
                        QUERY_STRING,
                        REMOTE_ADDR,
                        REMOTE_HOST,
                        SCRIPT_NAME,
                        SERVER_NAME,
                        X_FORWARDED_FOR,
                        ATTACK_TYPE,
                        HIT_COUNT,
                        NOTE,
                        RECORD_DATE,
                        EMPLOYEE_ID
                    )
                    VALUES
                    (
                        '#htmleditformat(attack.Http_Host)#',
                        '#htmleditformat(attack.Http_Referer)#',
                        '#htmleditformat(attack.Http_User_Agent)#',
                        '#htmleditformat(attack.Http_Path_Info)#',
                        '#htmleditformat(attack.Query_String)#',
                        '#htmleditformat(attack.Remote_Addr)#',
                        '#htmleditformat(attack.Remote_Host)#',
                        '#htmleditformat(attack.Script_Name)#',
                        '#htmleditformat(attack.Server_Name)#',
                        '#htmleditformat(attack.X_Forwarded_For)#',
                        '#attack_return.type#',
                        '#client.HitCount#',
                        '#note#',
                        #now()#,
                        <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">
                    )
                </cfquery>
                <cfif GET_WRK_SECURE_LOG.recordcount gte 2>
                    <cfsavecontent variable="session.error_text">Yaptığınız Saldırılardan Dolayı Sistemden Uzaklaştırıldınız.Sistem Yöneticinize Başvurunuz</cfsavecontent>
                    <cfif isdefined("session.ep")>
                       <cflocation addtoken="no" url="#request.self#?fuseaction=home.logout&secure_control=1">
                    <cfelseif isdefined("session.ww.userid") or isdefined("session.pp.userid") >
                        <cflocation addtoken="no" url="#request.self#?fuseaction=home.logout&secure_control=1">
                    <cfelseif isdefined("session.ww") or isdefined("session.pp")>
                        <cflocation addtoken="no" url="#request.self#?fuseaction=objects2.attacked">
                    </cfif>
                <cfelse>
                    <cfif isdefined("session.ep")>
                        <cflocation addtoken="no" url="#request.self#?fuseaction=home.attacked"> 
                    <cfelseif isdefined("session.ww")>
                        <cflocation addtoken="no" url="#request.self#?fuseaction=objects2.attacked">
                    <cfelseif isdefined("session.pp")>
                        <cflocation addtoken="no" url="#request.self#?fuseaction=objects2.attacked">
                    </cfif>
                </cfif>
                <cfexit method="exittemplate">
            </cfif>
        </cfif>
        <cfreturn true>
    </cffunction>
	
</cfcomponent>
