<table cellpadding="0" cellspacing="0" border="0" style="width:175px;">
	<tr> 
    	<td colspan="2">
			<cfinclude template="dsp_calender.cfm">
		</td>
  	</tr>
  	<cfif (cgi.QUERY_STRING contains "view_daily") or (cgi.QUERY_STRING contains "welcome")>
		<cfset attributes.to_day = tarih>
		<cfinclude template="../query/get_daily_warning.cfm">
		<tr>
			<td class="txtbold" colspan="2"><br/>&nbsp;&nbsp;<cf_get_lang no='736.Günlük Uyarılar'></td>
		</tr>
		<cfloop query="get_daily_warnings">
			<tr>
				<td  style="text-align:right; width:20px;"><img src="/images/tree_1.gif" alt="<cf_get_lang no='736.Günlük Uyarılar'>" title="<cf_get_lang no='736.Günlük Uyarılar'>"/></td>
				<td><cfoutput><a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi">#event_head#</a></cfoutput></td>
			</tr>
		</cfloop>
  	</cfif>
</table>
