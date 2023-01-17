
	<cfinclude template="dsp_calender.cfm">

<cfif (cgi.QUERY_STRING contains "view_daily") or (cgi.QUERY_STRING contains "welcome")>
	<table width="175" cellpadding="0" cellspacing="0" border="0">
		<cfif isdefined("tarih_degeri") and len(tarih_degeri)>
			<cfset attributes.to_day = tarih_degeri>
		<cfelse>
			<cfset attributes.to_day = tarih>
		</cfif>
		<cfinclude template="../query/get_daily_warning.cfm">
		<tr>
			<td class="txtbold" colspan="2"><br/><cf_get_lang no='8.Günlük Uyarılar'></td>
		</tr>
		<cfloop query="get_daily_warnings">
			<tr>
				<td width="20"  style="text-align:right;"><img src="/images/tree_1.gif" alt="<cf_get_lang no='8.Günlük Uyarılar'>"></td>
				<td width="155"><cfoutput><a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a>
					<cfif not len(EVENT_PLACE_ID)>
					<cfelseif EVENT_PLACE_ID eq 1><font color=red>(Ofis içi)
					<cfelseif EVENT_PLACE_ID eq 2><font color=red>(Ofis Dışı)
					<cfelseif EVENT_PLACE_ID eq 3><font color=red>(3.Parti Kurum)
					</cfif>
					</cfoutput>
				</td>
			</tr>
		</cfloop>
	</table>
</cfif>