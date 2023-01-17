<cfsetting showdebugoutput="no">
<cfif attributes.show_type eq 1>
	<cfoutput>
    <b>#session.ep.company#</b> - #session.ep.name# #session.ep.surname# (#session.ep.position_name#)-#Dateformat(dateadd('h',session.ep.time_zone, now()), dateformat_style)# #Timeformat(dateadd('h',session.ep.time_zone, now()), timeformat_style)#
    <a href=javascript:// onClick=windowopen('#request.self#?fuseaction=myhome.popup_list_myaccounts','small','popup_list_myaccounts');><font color='##FF0000'>Muh.Dönem:#session.ep.company_nick# - #session.ep.period_year#</font></a>
    <script type="text/javascript">
		AjaxPageLoad('#request.self#?fuseaction=myhome.emptypopup_show_session_info&show_type=0','mysettings_period_header',1);
		window.location = '<cfoutput>#cgi.http_referer#</cfoutput>';
	</script>
	</cfoutput>
<cfelse>
	<cfoutput>
    <a href=javascript:// onClick=windowopen('#request.self#?fuseaction=myhome.popup_list_myaccounts','small','popup_list_myaccounts');><font color='##ff0000;'><b>#left(session.ep.company_nick,42)# - #session.ep.period_year#</b></font></a>
    </cfoutput>
</cfif>
