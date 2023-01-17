<table width="175" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td colspan="2" width="175"><cfinclude template="dsp_calender.cfm"></td>
	</tr>
	<cfif (cgi.QUERY_STRING contains "view_daily") or (cgi.QUERY_STRING contains "welcome")>
		<cfif isdefined("tarih_degeri") and len(tarih_degeri)>
			<cfset attributes.to_day = tarih_degeri>
		<cfelse>
			<cfset attributes.to_day = tarih>
		</cfif>
		<cfinclude template="../query/get_daily_warning.cfm">
		<tr>
			<td class="txtbold" colspan="2"><br /><cf_get_lang no='8.Günlük Uyarılar'></td>
		</tr>
		<cfloop query="get_daily_warnings">
			<tr>
				<td width="20"  style="text-align:right;"><img src="/images/tree_1.gif" alt=""></td>
				<td width="155">
					<cfif type eq 1>
						<cfoutput><a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a></cfoutput>
					<cfelse>
						<cfoutput><a href="#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=#event_id#&warning_is_active=0&sub_warning_id=#event_id#" class="tableyazi">#event_head#</a></cfoutput>
					</cfif>
					<cfif not len(EVENT_PLACE_ID)>
					<cfelseif EVENT_PLACE_ID eq 1><font color=red>(<cf_get_lang no="6.Ofis içi">)
					<cfelseif EVENT_PLACE_ID eq 2><font color=red>(<cf_get_lang no="10.Ofis Dışı">)
					<cfelseif EVENT_PLACE_ID eq 3><font color=red>(3.<cf_get_lang no="11.Parti Kurum">)
					</cfif>
				</td>
			</tr>
		</cfloop>
	</cfif>
</table>
