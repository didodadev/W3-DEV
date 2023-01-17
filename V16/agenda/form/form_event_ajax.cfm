<cf_ajax_list>
    <thead>
        <tr>
            <th width="45"><cf_get_lang_main no='1655.Varlık'></th>
            <th width="130"><cf_get_lang no='66.Rezervasyon'></th>
            <th width="20">&nbsp;</th>
            <th width="20">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <cfinclude template="../query/get_event_assetp.cfm">
        <cfoutput query="event_assetp">
            <tr>
                <td>#event_assetp.assetp#</td>
                <td nowrap>#dateformat(date_add('h',session.ep.time_zone,event_assetp.startdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,event_assetp.startdate),timeformat_style)# <cfif len(event_assetp.finishdate)>- #dateformat(date_add('h',session.ep.time_zone,event_assetp.finishdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,event_assetp.finishdate),timeformat_style)#</cfif></td>
                <td align="center"><a href="javascript:windowopen('#request.self#?fuseaction=objects.popup_form_upd_assetp_reserve&ASSETP_RESID=#event_assetp.ASSETP_RESID#&ASSETP_ID=#event_assetp.ASSETP_ID#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Guncelle'>" border="0"></a></td>
                <td align="center"><a href="#request.self#?fuseaction=agenda.del_event_assetp&ASSETP_RESID=#event_assetp.ASSETP_RESID#"><img src="/images/delete_list.gif" title="<cf_get_lang no='23.Rezervi İptal Et'>" border="0"></a></td>
            </tr>
        </cfoutput>
    </tbody>
        <tr>
            <td style="text-align:right;background-color:white;" colspan="4">
				<cfoutput>
                	<input type="button" value="<cf_get_lang no='1.Fiziki Varlık Rezervasyon'>" onClick="windowopen('#request.self#?fuseaction=objects.popup_assets&event_id=#attributes.event_id#<cfif len(get_event.link_id)>&link_id=#get_event.link_id#&warning_type='+document.upd_event.warning_type.value+'</cfif>','project');">
				</cfoutput>
            </td>
        </tr>
</cf_ajax_list>
