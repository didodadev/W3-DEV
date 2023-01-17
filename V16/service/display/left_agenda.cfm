<table cellpadding="0" cellspacing="0" border="0" style="width:175px;">
  	<tr> 
    	<td colspan="2">
			<cfinclude template="dsp_calender.cfm">
		</td>
  	</tr>
  	<cfif (cgi.QUERY_STRING contains "view_daily") or (cgi.QUERY_STRING contains "welcome")>
  		<cfset attributes.to_day = tarih>
  		<tr>
			<td class="txtbold" colspan="2"><br/><cf_get_lang no='8.Günlük Uyarılar'></td>
  		</tr>
	  	<cfloop query="get_daily_warnings">
	  		<tr>
				<td style=" width:20px;text-align:right;"><img src="/images/tree_1.gif"></td>
				<td style="width:155px;"><cfoutput><a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a></cfoutput></td>
	  		</tr>
	  	</cfloop>
  	</cfif>
</table>