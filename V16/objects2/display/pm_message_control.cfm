<cfsetting showdebugoutput="no">
<cfif isdefined('session.ep.userid')>
	<cfstoredproc procedure="GET_MESSAGE" datasource="#DSN#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="0">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.ep.userid#">
		<cfprocresult name="RECORDCOUNT" resultset="1">
	</cfstoredproc>
<cfelseif isdefined('session.pp.userid')>
	<cfstoredproc procedure="GET_MESSAGE" datasource="#DSN#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="1">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.pp.userid#">
		<cfprocresult name="RECORDCOUNT" resultset="1">
	</cfstoredproc>
<cfelseif isdefined('session.ww.userid')>
	<cfstoredproc procedure="GET_MESSAGE" datasource="#DSN#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="2">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.ww.userid#">
		<cfprocresult name="RECORDCOUNT" resultset="1">
	</cfstoredproc>
<cfelseif isdefined('session.pda.userid')>
	<cfstoredproc procedure="GET_MESSAGE" datasource="#DSN#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="0">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.pda.userid#">
		<cfprocresult name="RECORDCOUNT" resultset="1">
	</cfstoredproc>
</cfif>

<cfif isdefined('session.ep.userid')>

		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="0">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.ep.userid#">

<cfelseif isdefined('session.pp.userid')>
	<cfstoredproc procedure="GET_MESSAGE" datasource="#DSN#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="1">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.pp.userid#">

<cfelseif isdefined('session.ww.userid')>
	<cfstoredproc procedure="GET_MESSAGE" datasource="#DSN#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="2">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.ww.userid#">

<cfelseif isdefined('session.pda.userid')>
	<cfstoredproc procedure="GET_MESSAGE" datasource="#DSN#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="0">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#session.pda.userid#">

</cfif>

<cfif isdefined("RECORDCOUNT.RECEIVER_ID") and len(RECORDCOUNT.RECEIVER_ID)>
	<cfset msg_cont_ = RECORDCOUNT.RECORDCOUNT>
<cfelse>
	<cfset msg_cont_ = 0>
</cfif>

<cfset alert_list = "">
<cfset closed_list = "">
<cfif isdefined('session.ep.userid')>
	<cfif msg_cont_ gte 1>
        <cfset alert_list = valuelist(RECORDCOUNT.is_alerted)>
        <cfset closed_list = valuelist(RECORDCOUNT.IS_CLOSED)>
        <cfset wrk_msg_id_list = valuelist(RECORDCOUNT.WRK_MESSAGE_ID)>
        <cfquery name="upd_" datasource="#dsn#">
            UPDATE
                WRK_MESSAGE
            SET
                IS_ALERTED = 1
            WHERE
                WRK_MESSAGE_ID IN (#wrk_msg_id_list#)
        </cfquery>
    </cfif>
<cfelseif isdefined('session.pda.userid')>
	<cfif msg_cont_ gte 1>
        <cfset alert_list = valuelist(RECORDCOUNT.is_alerted)>
        <cfset closed_list = valuelist(RECORDCOUNT.is_closed)>
        <cfset wrk_msg_id_list = valuelist(RECORDCOUNT.WRK_MESSAGE_ID)>
        <cfquery name="upd_" datasource="#dsn#">
            UPDATE
                WRK_MESSAGE
            SET
                IS_ALERTED = 1
            WHERE
                WRK_MESSAGE_ID IN (#wrk_msg_id_list#)
        </cfquery>
    </cfif>
</cfif>
<cfset is_closed_list = 0>
<cfloop index="aaa" from="1" to="#listlen(closed_list)#">
	<cfif listgetAt(closed_list,aaa) is 'true'>
    	<cfset is_closed_list = is_closed_list + 1> <!--- Kapatilmis mesajlarin sayisi --->
    </cfif>
</cfloop>










<script type="text/javascript">
	function Kapat(type_)
	{
		document.getElementById('pm_varmi').style.display = 'none';
		document.title = wrk_message_temp_title;
	}
	function Kapat2(type_)
	{
		document.getElementById('pm_varmi').style.display = 'none';
		document.title = wrk_message_temp_title;
		<cfif isdefined("wrk_msg_id_list")>
			var upd_messages = wrk_safe_query('upd_messages','dsn',0,'<cfoutput>#wrk_msg_id_list#</cfoutput>');
		</cfif>
	}







</script>

<cfif msg_cont_ gte 1>
	<cfif isdefined('session.ep.userid')>
		<cfif is_closed_list neq msg_cont_>
			<a id="link_pm" href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_message&employee_id=<cfoutput>#session.ep.userid#</cfoutput>','small','popup_banner');Kapat(1);">
                <i class="catalyst-bell"></i> <span class="badge badgeCount"><cfoutput>#msg_cont_#</cfoutput></span>
            </a>
        </cfif>
    <cfelseif isdefined('session.pda.userid') and session.pda.userid eq 25>
    	<a href="/index.cfm?fuseaction=pda.list_messages">
            <div id="divTxt" style="text-align:center; border:solid 2px #AAA;width:135px; height:90px; background-color:#CCFFFF;">
                <div title="Kapat" onClick="Kapat();" style="border:solid 0px #CCC; width:15px; margin-left:120px; margin-top:1px;">x</div>
                <img src="/images/iletisimcrm.gif" border="0" align="absmiddle" /><br /><br />
                <cfoutput>#msg_cont_#</cfoutput> <cf_get_lang_main no ='1135.You have got message'>
            </div>
        </a>
	<cfelseif isdefined('session.pda.userid')>
         <cfoutput><a href="/index.cfm?fuseaction=pda.list_messages">#msg_cont_# <cf_get_lang_main no ='1135.You have got message'></a></cfoutput>
	<cfelseif isdefined('session.pp.userid')>
	<a id="link_pm" style="font-weight:bold;" href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_message&partner_id=<cfoutput>#session.pp.userid#</cfoutput>','small','popup_banner');Kapat(1);">
		<div id="divTxt" style="text-align:center; border:solid 2px #AAA;width:135px; height:90px; background-color:#CCFFFF;">
			<div title="Kapat" onClick="Kapat();" style="border:solid 0px #CCC; width:15px; margin-left:120px; margin-top:1px;">x</div>
			<img src="/images/iletisimcrm.gif" border="0" align="absmiddle" /><br />
			<cf_get_lang_main no ='1135.You have got message'>
		</div>
	</a>
	</cfif>
    <cfif not len(alert_list) or listfind(alert_list,'0') or listfind(alert_list,'false')>
            <!DOCTYPE html>
            <html>
             <head>
             </head>
             <body>
                <audio src="documents/new_message.mp3" id="audiomsg" autoplay>
                   	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="1" height="1">
                        <param name="movie" value="/images/new_message.swf">
                        <param name="quality" value="high">
                        <embed src="/images/new_message.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="1" height="1"></embed>
                    </object>
                </audio>
             </body>
            </html>
    </cfif>
    <cfif is_closed_list neq msg_cont_>
		<script type="text/javascript">
            document.getElementById('pm_varmi').style.display = '';
            document.title = "<cf_get_lang_main no ='1135.You have got message'>" + "<cfoutput>#UCase(ListFirst(employee_url, ';'))#</cfoutput>";
        </script>
    <cfelse>
		<script type="text/javascript">
            Kapat(0);
        </script>
    </cfif>
<cfelse>
	<script type="text/javascript">
		Kapat(0);
	</script>
</cfif>
