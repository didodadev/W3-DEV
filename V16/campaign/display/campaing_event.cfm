<table cellSpacing="0" cellpadding="0" width="98%" border="0">
	<tr class="color-border">
		<td>
			<table cellspacing="1" cellpadding="2" width="100%" border="0">
				<cfquery name="GET_RELATED_EVENTS" datasource="#dsn3#">
					SELECT ORE.*,E.EVENT_HEAD FROM RELATED_EVENTS ORE,#dsn_alias#.EVENT E WHERE ORE.CAMPAING_ID = #attributes.camp_id# AND E.EVENT_ID = ORE.EVENT_ID
				</cfquery>
				<tr class="color-header">
					<td height="22" class="form-title" width="99%">Toplantılar&nbsp;</td>
					<td nowrap="nowrap" style="text-align:right;">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_events&campaing_id=#url.camp_id#</cfoutput>','list');"><img src="/images/report_square.gif" alt="Olay İlişkilendir" title="Olay İlişkilendir" border="0"></a>
					</td>
				</tr>
				<cfif not GET_RELATED_EVENTS.recordcount>
					<tr class="color-row">
						<td colspan="2"><cf_get_lang_main no='72.kayıt yok'></td>
					</tr>
				<cfelse>
					<cfoutput query="GET_RELATED_EVENTS">
						<tr class="color-row">
							<td><a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a></td>
							<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaing.emptypopup_del_camp_event_relation&event_id=#event_id#&campaing_id=#url.camp_id#','small');" class="tableyazi"><img src="/images/delete_list.gif" alt="Sil" border="0"></a></td>
						</tr>
					</cfoutput>
				</cfif>
			</table>
		</td>
	</tr>
</table>
